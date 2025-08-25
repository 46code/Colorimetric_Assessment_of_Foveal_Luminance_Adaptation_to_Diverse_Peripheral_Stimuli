clc;clear;close all;
% option for point plotting
last_p=5;
option='B'; % A (all points) or B (last last_p points)      

% plot three paramters
[all_j_mean, all_j_std, total_obs_mistake, all_stimuli] = j_plot(option,last_p);
[all_e_mean, all_e_std] = deltaE_plot(option,last_p);
[all_l_mean, all_l_std, all_time] = luma_plot(option,last_p);

close all;

%% last_p mistake poitns for all observer 
% 1st order
mistake_plot(1:2:14,total_obs_mistake)
% 2nd order
mistake_plot(2:2:14,total_obs_mistake)

%% total number of stimuli for all observer 
% 1st order
mistake_plot(1:2:14,all_stimuli)
% 2nd order
mistake_plot(2:2:14,all_stimuli)

%% cluster of last_p points mean for 30 observer
cluster_line_plot(all_j_mean,all_j_std,'Jz (Lightness)');
cluster_line_plot(all_e_mean,all_e_std,'DeltaE');
cluster_line_plot(all_l_mean,all_l_std,'Luminance');

%% a vs b chromatic plot
colors = {'W1','W2','R1','R2','G1','G2','B1','B2','Y1','Y2','M1','M2','C1','C2'};

% Create figure with better aspect ratio
figure('Position', [100, 100, 800, 700]);
hold on;
grid on;
box on;

% Preallocate legend handles
legendHandles = gobjects(1, 7);
legendLabels = cell(1, 7);
colorIndex = 1;

for i = 1:2:14  % Only first-order colors
    [name, code, ~] = colorName(i);
    
    % Store for legend
    legendHandles(colorIndex) = plot(NaN, NaN, 'Color', code, 'LineWidth', 2);
    legendLabels{colorIndex} = name;
    colorIndex = colorIndex + 1;
    
    for obs = 1:30
        filename = fullfile('resultsAni', sprintf('obs_%02d.csv', obs));
        
        data = readtable(filename);
        
        % Extract color block
        colorCol = data{:,1}; 
        match = strcmp(colorCol, colors{i});
        
        numericData = table2array(data(match, 2:end));
        a = numericData(:,10);
        b = numericData(:,11);
        
        % Calculate displacement vector
        da = a(end) - a(1);
        db = b(end) - b(1);
        
        % Plot vector with arrowhead
        quiver(a(1), b(1), da, db, 0, ...
            'Color', code, ...
            'LineWidth', 1.2, ...
            'MaxHeadSize', 1.5, ...
            'AutoScale', 'off');
    end
end

% Add reference lines at origin
xline(0, 'k-', 'LineWidth', 1.2, 'Alpha', 0.7);
yline(0, 'k-', 'LineWidth', 1.2, 'Alpha', 0.7);

% Set plot limits and labels
axis equal;
xlim([-0.025 0.015]);
ylim([-0.040 0.008]);

% Custom axis labels with improved positioning
text(85, 0, 'Az*', 'FontSize', 12, 'FontWeight', 'bold', ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
text(0, 85, 'Bz*', 'FontSize', 12, 'FontWeight', 'bold', ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
     'Rotation', 0);

% Add title and legend
t = title('Chromatic Shift: Second-Order Colors', 'FontSize', 14, 'FontWeight', 'bold');
set(t, 'Position', [0, 88 , 0]); % Move title slightly higher
legend(legendHandles, legendLabels, 'Location', 'bestoutside');

% Add grid with minor ticks
ax = gca;
ax.GridColor = [0.85, 0.85, 0.85];
ax.GridAlpha = 0.7;
ax.MinorGridColor = [0.92, 0.92, 0.92];
ax.MinorGridLineStyle = '-';
ax.MinorGridAlpha = 0.4;
grid minor;

% Add axis box
ax.LineWidth = 1.2;

xlabel('Az')
ylabel('Bz')

hold off;

filename = sprintf('Figures/JzAzBz_AzBz_1st.png');        
exportgraphics(gca, filename, 'Resolution', 300);

%% frequency plot of J, DeltaE and L

% Create figure for 1st pass (odd channels)
fig1 = figure('Color', 'white', 'Position', [100, 100, 1400, 600]);
sgtitle('CAM16 UCS DeltaE Distribution - First Pass', ...
    'FontSize', 16, 'FontWeight', 'bold');

for channel = 1:2:14  % Odd channels = 1st pass
    subplot(2, 4, ceil(channel/2));  % 2x4 grid for 7 plots (last spot empty)
    
    % Get color information
    [name, code, ~] = colorName(channel);
    
    % Get and sort data
    val = sort(all_e_mean(:, channel));
    
    % Create enhanced histogram
    histogram(val, 'BinWidth', 0.2, ...
        'FaceColor', code, ...
        'EdgeColor', 'k', ...
        'FaceAlpha', 0.8);
    
    % Formatting
    ax = gca;
    ax.FontName = 'Arial';
    ax.FontSize = 10;
    ax.LineWidth = 1.2;
    ax.Box = 'on';
    ax.GridColor = [0.85 0.85 0.85];
    ax.GridAlpha = 1;
    grid on;
    
    % Set consistent axis limits
    xlim([0 10]);
    ylim([0 25]);
    
    % Add titles and labels
    title(sprintf('%s (1st)', name), 'FontSize', 12, 'FontWeight', 'bold');
    xlabel('\DeltaE', 'FontSize', 10);
    ylabel('Observer Count', 'FontSize', 10);
end

% Save first pass figure
exportgraphics(fig1, 'Figures/CAM16_UCS_DeltaE_Distributions_First_Pass.png', 'Resolution', 300);

% Create figure for 2nd pass (even channels)
fig2 = figure('Color', 'white', 'Position', [100, 100, 1400, 600]);
sgtitle('CAM16 UCS DeltaE Distribution - Second Pass', ...
    'FontSize', 16, 'FontWeight', 'bold');

for channel = 2:2:14  % Even channels = 2nd pass
    subplot(2, 4, ceil(channel/2));  % 2x4 grid for 7 plots (last spot empty)
    
    % Get color information
    [name, code, ~] = colorName(channel);
    
    % Get and sort data
    val = sort(all_e_mean(:, channel));
    
    % Create enhanced histogram
    histogram(val, 'BinWidth', 0.2, ...
        'FaceColor', code, ...
        'EdgeColor', 'k', ...
        'FaceAlpha', 0.8);
    
    % Formatting
    ax = gca;
    ax.FontName = 'Arial';
    ax.FontSize = 10;
    ax.LineWidth = 1.2;
    ax.Box = 'on';
    ax.GridColor = [0.85 0.85 0.85];
    ax.GridAlpha = 1;
    grid on;
    
    % Set consistent axis limits
    xlim([0 10]);
    ylim([0 25]);
    
    % Add titles and labels
    title(sprintf('%s (2nd)', name), 'FontSize', 12, 'FontWeight', 'bold');
    xlabel('\DeltaE', 'FontSize', 10);
    ylabel('Observer Count', 'FontSize', 10);
end

% Save second pass figure
exportgraphics(fig2, 'Figures/CAM16_UCS-DeltaE_Distributions_Second_Pass.png', 'Resolution', 300);

%% Adaptation Time
time_data=all_time;
% Step 1: Compute observer rankings from time data
diffs = abs(time_data(:,1:2:13) - time_data(:,2:2:14));
mean_diff = mean(diffs, 2);
std_diff = std(diffs, 0, 2);
composite = mean_diff + std_diff;
[~, sorted_idx] = sort(composite);

% Step 2: Read demographics
demographics = readtable('demographics.csv', 'ReadVariableNames', false);
observer_ids = demographics.Var1;  % First column = IDs
ages = demographics.Var2;          % Second column = Ages
genders = demographics.Var3;       % Third column = Genders

% Step 3: Create ranked output
ranked_ids = observer_ids(sorted_idx);
ranked_ages = ages(sorted_idx);
ranked_genders = genders(sorted_idx);

% Step 4: Save results
output_table = table((1:30)', ranked_ids, ranked_ages, ranked_genders, ...
                    'VariableNames', {'Rank', 'Observer_ID', 'Age', 'Gender'});
writetable(output_table, 'observer_rankings.csv');

%% Color Based for All Observer
time_data=total_obs_mistake; 
% Define color names and column indices
color_names = {'White', 'Red', 'Green', 'Blue', 'Yellow', 'Magenta', 'Cyan'};
color_pairs = [1,2; 3,4; 5,6; 7,8; 9,10; 11,12; 13,14];

% Initialize result matrices
intra_var = zeros(7,1);   % Intra-observer variance (between passes)
inter_var_pass1 = zeros(7,1); % Inter-observer variance (1st pass)
inter_var_pass2 = zeros(7,1); % Inter-observer variance (2nd pass)

% Process each color
for c_idx = 1:7
    % Get column indices
    col1 = color_pairs(c_idx,1);
    col2 = color_pairs(c_idx,2);
    
    % Extract data for current color
    pass1_data = time_data(:, col1);
    pass2_data = time_data(:, col2);
    
    % Intra-observer variance (between passes)
    diff = (pass1_data - pass2_data);
    intra_var(c_idx) = std(diff);
    
    % Inter-observer variance (within passes)
    inter_var_pass1(c_idx) = std(pass1_data);
    inter_var_pass2(c_idx) = std(pass2_data);
end

% Create figure
fig = figure('Position', [100 100 800 500]);

% First subplot: Intra-observer variance
subplot(2,1,1);
bar(intra_var); 
title('Intra-Observer');
ylabel('Std Dev');
ylim([0 20])
set(gca, 'XTick', 1:7, 'XTickLabel', color_names, 'FontSize', 10);
grid on;
box on;

% Second subplot: Inter-observer variance
subplot(2,1,2);
bar([inter_var_pass1, inter_var_pass2], 'FaceColor', 'flat');  % Default grouped bars
title('Inter-Observer');
ylabel('Std Dev');
set(gca, 'XTick', 1:7, 'XTickLabel', color_names, 'FontSize', 10);
legend({'1st Pass', '2nd Pass'}, 'Location', 'northeast', 'FontSize', 9);
ylim([0 20])
grid on;
box on;

% Add overall title
sgtitle('Total Mistake Variability', 'FontSize', 14, 'FontWeight', 'bold');

filename = 'Figures/Total_Mistake.png';
exportgraphics(fig, filename, 'Resolution', 300);