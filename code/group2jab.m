function jab = group2jab(obs_id, XYZ, Y_b, surround,XYZ_background)

    % List of color labels
    colors = {'W1','W2','R1','R2','G1','G2','B1','B2','Y1','Y2','M1','M2','C1','C2'};      
    numColors = numel(colors);
    
    % Initialize accumulators
    colorSums = cell(1, numColors);
    colorCounts = cell(1, numColors);

    % Process each observer
    for idx = 1:numel(obs_id)
        id = obs_id(idx);
        filename = fullfile(pwd, 'resultsAni', sprintf('obs_%02d.csv', id));
        data = readtable(filename);

        % Extract color blocks
        colorCol = data{:,1}; 
        for i = 1:numColors
            match = strcmp(colorCol, colors{i});
            block = data(match, :);
            numericData = table2array(block(:, 2:end));

            % Number of rows for current block
            nRows = size(numericData, 1);
            nCols = size(numericData, 2);

            % Initialize sum/count for this color if needed
            if isempty(colorSums{i})
                colorSums{i} = zeros(nRows, nCols);
                colorCounts{i} = zeros(nRows, 1);
            end

            % Expand if current block is longer than existing
            existingRows = size(colorSums{i}, 1);
            if nRows > existingRows
                colorSums{i}(end+1:nRows, :) = 0;
                colorCounts{i}(end+1:nRows, :) = 0;
            end

            % Accumulate sum and count only for rows that exist in this block
            colorSums{i}(1:nRows, :) = colorSums{i}(1:nRows, :) + numericData;
            colorCounts{i}(1:nRows) = colorCounts{i}(1:nRows) + 1;
        end
    end

    % compute per-row means for each color block
    colorMean = cell(1, numColors);
    for i = 1:numColors
        count = colorCounts{i};
        colorMean{i} = colorSums{i} ./ count;
    end
   
    % Jab and deltaE calculation
    jab=cell(1,numColors);
    for i = 1:numColors

        row=length(colorMean{i});
        colorJab=zeros(row,4);
        XYZ_w=colorMean{i}(:,2:4);
        L_A=colorMean{i}(:,5);

        for j=1:row
            % landolt-C Jab calcualtion
            [J, ~, M, ~, h, ~, ~, ~] = CAM16Forward(XYZ, XYZ_w(j,:)', L_A(j,1), Y_b, surround);
            [J_c, a_c, b_c, ~]=CAM16_UCS(J, M, h);

            % black background Jab calculation
            [J, ~, M, ~, h, ~, ~, ~] = CAM16Forward(XYZ_background, XYZ_w(j,:)', L_A(j,1), Y_b, surround);
            [J_b, a_b, b_b, ~]=CAM16_UCS(J, M, h);
            [DECAM16UCS, ~] = CAM16_UCS_Colour_Difference(J_c, a_c, b_c, J_b, a_b, b_b);

            colorJab(j,:) = [J_c, a_c, b_c, DECAM16UCS];

        end

        jab{i}=colorJab;

    end

end
