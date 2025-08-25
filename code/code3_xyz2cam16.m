clc; clear; close all;
addpath('CAM16_main/');

% Load and preprocess data
T = readtable('resultsAni/obs_30.csv');
T{299,3:5} = ones(1,3);
T{315,3:5} = ones(1,3);

% Fixed XYZ value for test stimulus 
XYZ_test = [0.07238; 0.0760; 0.08662]; 

% Set fixed CAM16 parameters
Y_b = 0.01;           % Background luminance factor (%)
surround = 'dark';  % Surround condition

% Calculate J'a'b' for all data
T.J_prime = zeros(height(T), 1);
T.a_prime = zeros(height(T), 1);
T.b_prime = zeros(height(T), 1);

for row_idx = 1:height(T)
    % Extract XYZ_w from columns (scale to [0,100])
    XYZ_w = [T.X(row_idx); T.Y(row_idx); T.Z(row_idx)];
    
    % Extract L_A from luminance column
    L_A = T.luminance(row_idx);
    
    % Calculate CAM16 appearance correlates
    [J, Q, M, s, h, C, H, Hc] = CAM16Forward(XYZ_test, XYZ_w, L_A, Y_b, surround);
    [J_ucs, a_ucs, b_ucs, h_ucs] = CAM16_UCS(J, M, h);

    T.J_prime(row_idx) = J_ucs;
    T.a_prime(row_idx) = a_ucs;
    T.b_prime(row_idx) = b_ucs;
end

% Create color_data AFTER J_prime/a_prime/b_prime are added to T
colors = {'W1','W2','R1','R2','G1','G2','B1','B2','Y1','Y2','M1','M2','C1','C2'};
color_data = struct();

for k = 1:length(colors)
    color = colors{k};
    mask = strcmp(T.color, color);
    color_data.(color) = T(mask, :);
end

% Plot settings
marker_size = 50;
label_offset = 0.5;
font_size = 9;
color_pairs = {'W1','W2'; 'R1','R2'; 'G1','G2'; 'B1','B2'; 
               'Y1','Y2'; 'M1','M2'; 'C1','C2'};
color_names = {'White', 'Red', 'Green', 'Blue', 'Yellow', 'Magenta', 'Cyan'};
marker_types = {'o', 's'}; % Circle for condition 1, square for condition 2
line_styles = {'-', '--'};
colors_rgb = [0 0 0; 0.5 0.5 0.5]; % Black for condition 1, gray for condition 2

% Create figures for each color pair
for pair_idx = 1:size(color_pairs, 1)
    fig = figure('Position', [100, 100, 1200, 400], 'Name', color_names{pair_idx});
    sgtitle(color_names{pair_idx}, 'FontSize', 14, 'FontWeight', 'bold');
    
    for cond = 1:2
        color = color_pairs{pair_idx, cond};
        data = color_data.(color);
        N = height(data);
        
        % Extract J'a'b' values
        J = data.J_prime;
        a = data.a_prime;
        b = data.b_prime;
        indices = 1:N;  % Create indices for plotting
        
        % 1D Plot: J' vs Index
        subplot(1, 3, 1);
        hold on;
        plot(indices, J, 'Color', colors_rgb(cond,:), 'LineStyle', line_styles{cond}, ...
             'Marker', marker_types{cond}, 'MarkerFaceColor', colors_rgb(cond,:), ...
             'MarkerSize', 6, 'LineWidth', 1.5);
        
        % Add text labels slightly above points
        for k = 1:N
            text(indices(k), J(k)+label_offset, sprintf('%d', k), ...
                'FontSize', font_size, 'HorizontalAlignment', 'center', ...
                'Color', colors_rgb(cond,:));
        end
        title('Lightness (J'')');
        xlabel('Sample Index');
        ylabel('J''');
        ylim([0, 100]);
        grid on;
        xticks(indices);
        
        % 2D Plot: a' vs b'
        subplot(1, 3, 2);
        hold on;
        scatter(a, b, marker_size, 'Marker', marker_types{cond}, ...
                'MarkerFaceColor', colors_rgb(cond,:), 'MarkerEdgeColor', colors_rgb(cond,:));
        
        % Add text labels slightly offset
        for k = 1:N
            text(a(k)+label_offset, b(k)+label_offset, sprintf('%d', k), ...
                'FontSize', font_size, 'Color', colors_rgb(cond,:));
        end
        title('Chroma Plane');
        xlabel('a''');
        ylabel('b''');
        axis square;
        grid on;
        
        % 3D Plot: a' vs b' vs J'
        subplot(1, 3, 3);
        hold on;
        scatter3(a, b, J, marker_size, 'Marker', marker_types{cond}, ...
                 'MarkerFaceColor', colors_rgb(cond,:), 'MarkerEdgeColor', colors_rgb(cond,:));
        
        % Add text labels slightly offset
        for k = 1:N
            text(a(k)+label_offset, b(k)+label_offset, J(k)+label_offset, ...
                sprintf('%d', k), 'FontSize', font_size, 'Color', colors_rgb(cond,:));
        end
        title('3D Color Space');
        xlabel('a''');
        ylabel('b''');
        zlabel('J''');
        zlim([0, 100]);
        grid on;
        view(3);
    end
    
    % Add legends and adjust limits
    subplot(1, 3, 1);
    legend(color_pairs(pair_idx, :), 'Location', 'best', 'Box', 'off');
    
    subplot(1, 3, 2);
    % Get max absolute value for symmetric limits
    all_ab = [color_data.(color_pairs{pair_idx,1}).a_prime; 
              color_data.(color_pairs{pair_idx,2}).a_prime;
              color_data.(color_pairs{pair_idx,1}).b_prime; 
              color_data.(color_pairs{pair_idx,2}).b_prime];
    max_ab = max(abs(all_ab)) * 1.2;
    xlim([-max_ab, max_ab]);
    ylim([-max_ab, max_ab]);
    legend(color_pairs(pair_idx, :), 'Location', 'best', 'Box', 'off');
    
    subplot(1, 3, 3);
    xlim([-max_ab, max_ab]);
    ylim([-max_ab, max_ab]);
    legend(color_pairs(pair_idx, :), 'Location', 'best', 'Box', 'off');
    
end

data = color_data.W1{:,9:11};  % Extract columns 9–11 as numeric matrix


figure;
plot(data(:,1), 'k.-', 'LineWidth', 1.2);
xlabel('Sample Index');
ylabel('J* value');
title('J* Component across Samples');
grid on;

% Add sample index as label
for i = 1:size(data,1)
    text(i, data(i,1), sprintf('%d', i), 'FontSize', 8, 'VerticalAlignment','bottom');
end


figure;
plot(data(:,2), data(:,3), 'bo');
xlabel('a* value');
ylabel('b* value');
title('a* vs b*');
grid on;
axis equal;

% Add index labels
for i = 1:size(data,1)
    text(data(i,2), data(i,3), sprintf('%d', i), 'FontSize', 8, 'VerticalAlignment','bottom');
end


