clc;clear;close all;
addpath('CAM16_main/');

% load the xyz_data
load('xyz_data.mat');
ramps=readmatrix('ramps7.csv');

% Define XYZ of Landolt-C and Black Background
XYZ_c=[0.0660534282341221;	0.0700000000000000;	0.0737310674223519];
XYZ_b=[0.0283086121003380;	0.0300000000000000;	0.0315990288952936];

% Define the CAM16-UCS parameters
Y_b = 0.01;         % Background luminance factor (%)
surround = 'dark';  % Surround condition

% Define the Jzazbz parameters
D=1;
mode='f';
XYZ_wt=[986.806174971112;	1045.29837132620;	1101.59560797447];

% XYZ_wt=(XYZ_wt./XYZ_wt(2))*10000;

% Create XYZ mapper for 14 conditions
xyz_mats = {
    white_xyz; white_xyz;     % W1, W2
    red_xyz; red_xyz;         % R1, R2
    green_xyz; green_xyz;     % G1, G2
    blue_xyz; blue_xyz;       % B1, B2
    yellow_xyz; yellow_xyz;   % Y1, Y2
    magenta_xyz; magenta_xyz; % M1, M2
    cyan_xyz; cyan_xyz        % C1, C2
};

% Create output directory
output_dir = fullfile(pwd, 'resultsAni');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

for obs = 1:30
    pathobs = sprintf('%02d', obs);
    csv_file = fullfile('data', pathobs, 'test.csv');
    
    % Read header to find Time column
    fid = fopen(csv_file);
    header_line = fgetl(fid);
    fclose(fid);
    headers = strsplit(header_line, ',');
    time_col = find(strcmpi(headers, 'Time'), 1);
    
    % load data and sort
    data = readmatrix(csv_file);
    sortdata = sortrows(data, [6 1]);  % Sort by Color then Index
    sortdata (sortdata (:,4) > 1023, :) = 1023; % process the data

    % columns to extract
    cols_to_extract = [4, time_col, size(data, 2)];  % Surrounding (4) and Match (last)

    % Surrounding, Time, Match
    values = cell(14,1);
    for col = 1:7
        cond1 = 2*col-1;
        cond2 = 2*col;
        
        % Extract columns
        values{cond1} = sortdata(sortdata(:,6) == cond1, cols_to_extract);
        values{cond2} = sortdata(sortdata(:,6) == cond2, cols_to_extract);
    end
    
    % Calculate row indices for each color block
    idx = cumsum(cellfun(@(x) size(x,1), values));
    total_rows = idx(end);
    start_idx = [1; idx(1:13)+1];  
    end_idx = idx;                
    
    % Initialize table with specified columns
    varTypes = {'string', 'double', 'double', 'double', 'double', 'double', 'double','double','double','double', 'double', 'double','double','double','double','int8'};
    varNames = {'color', 'surrounding', 'X', 'Y', 'Z', 'J','a','b','deltaE_CAM16', 'Jz','az','bz','deltaE_Jzazbz','luminance', 'time', 'match'};
    mat = table('Size', [total_rows, length(varNames)], ...
                'VariableTypes', varTypes, ...
                'VariableNames', varNames);

    % Assign color names in each blocks
    conditions = {'W1','W2','R1','R2','G1','G2','B1','B2','Y1','Y2','M1','M2','C1','C2'};
    for block = 1:14
        mat.color(start_idx(block):end_idx(block)) = conditions(block);
    end

    %% Assign values for all 14 blocks
    for block = 1:14
        rows = start_idx(block):end_idx(block); 
        
        for i = 1:length(rows)
            tab_row = rows(i);
            
            % Get surrounding rgb value
            stim_idx = values{block}(i, 1);
            
            % Assign luminance from ramps
            ramp_col = ceil(block/2); % looking for color
            mat.luminance(tab_row) = ramps(stim_idx, ramp_col);

            % Assign XYZ from xyz__mats
            xyz_vals = xyz_mats{block}(stim_idx, :);
            mat.X(tab_row) = xyz_vals(1);
            mat.Y(tab_row) = xyz_vals(2);
            mat.Z(tab_row) = xyz_vals(3);

            % Calculate the CAM16-UCS Jab and DeltaE
            XYZ_w=xyz_vals';
            L_A=ramps(stim_idx, ramp_col);

            % landolt-C Jab calculation
            [J, ~, M, ~, h, ~, ~, ~] = CAM16Forward(XYZ_c, XYZ_w, L_A, Y_b, surround);
            [J_c, a_c, b_c, ~]=CAM16_UCS(J, M, h);

            % black background Jab calculation
            [J, ~, M, ~, h, ~, ~, ~] = CAM16Forward(XYZ_b, XYZ_w, L_A, Y_b, surround);
            [J_b, a_b, b_b, ~]=CAM16_UCS(J, M, h);
            [DECAM16UCS, ~] = CAM16_UCS_Colour_Difference(J_c, a_c, b_c, J_b, a_b, b_b);

            % Assign Jab and deltaE
            mat.J(tab_row)=J_c;
            mat.a(tab_row)=a_c;
            mat.b(tab_row)=b_c;
            mat.deltaE_CAM16(tab_row)=DECAM16UCS;
            
            % Assing surrounding values
            mat.surrounding(tab_row) = stim_idx;
            
            % Assign time values
            mat.time(tab_row) = values{block}(i, 2);

            % Assign match values
            mat.match(tab_row) = values{block}(i, end);

            % Calculate the  Jzazbz values
            % landolt-C
            INPUT_c = CAT16_A2B(XYZ_c, XYZ_w, XYZ_wt, D);
            OUTPUT_c = JzAzBz(INPUT_c', mode);

            %black background
            INPUT_b = CAT16_A2B(XYZ_b, XYZ_w, XYZ_wt, D);
            OUTPUT_b = JzAzBz(INPUT_b', mode);
            OUTPUT_deltaE = sqrt(sum((OUTPUT_c - OUTPUT_b).^2));

            % Assign the Jzazbz values
            mat.Jz(tab_row)=OUTPUT_c(1);
            mat.az(tab_row)=OUTPUT_c(2);
            mat.bz(tab_row)=OUTPUT_c(3);

            mat.deltaE_Jzazbz(tab_row)=OUTPUT_deltaE;
                       
        end
    end
    
    % Write to file
    output_file = fullfile(output_dir, ['obs_' pathobs '.csv']);
    
    % CRITICAL: Write the table to disk
    writetable(mat, output_file, ...
        'Delimiter', ',', ...
        'WriteVariableNames', true, ...
        'QuoteStrings', false);
    
    fprintf('Successfully wrote: %s\n', output_file);
end

rmpath('CAM16_main/');
