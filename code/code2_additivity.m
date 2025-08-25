clc; clear; close all;

% Load SPD data
red   = readmatrix('ramps_TSR/red ramp 16Jan24.csv');
blue  = readmatrix('ramps_TSR/blue ramp 13Jan24.csv');
green = readmatrix('ramps_TSR/green ramp 13Jan24.csv');
green = green(1018:end, :);  % Trim to align
white = readmatrix('ramps_TSR/white ramp 17Jan24.csv');

% Extract SPD values (columns 10 to 410)
red_spd   = red(:, 10:410);
green_spd = green(:, 10:410);
blue_spd  = blue(:, 10:410);
white_spd = white(:, 10:410);

% Compute error matrix (white - (R+G+B))
error_matrix = abs(white_spd - (red_spd + green_spd + blue_spd));

% Compute statistics
mean_err = mean(error_matrix, 1);     % mean across rows for each wavelength
std_err  = std(error_matrix, 0, 1);   % std across rows for each wavelength

% Wavelength axis
wavelengths = linspace(380, 780, size(error_matrix, 2)); 
num_points = length(wavelengths);

% Create enhanced visualization
figure;
set(gcf, 'Position', [100 100 900 700], 'Color', 'w');
main_ax = axes('Position', [0.13 0.18 0.775 0.72]); % Leave space at bottom

% Plot mean error with shaded standard deviation band
mean_plot = plot(wavelengths, mean_err, 'b-', 'LineWidth', 1.8);
hold on;
band_plot = fill([wavelengths, fliplr(wavelengths)], ...
                 [mean_err - std_err, fliplr(mean_err + std_err)], ...
                 [0.7 0.7 1], 'EdgeColor', 'none', 'FaceAlpha', 0.4);

% Reference line and grid
ref_line = yline(0, 'k-', 'LineWidth', 1.2);
grid on;

% Highlight regions where |error| > 0.01
above_threshold = abs(mean_err) > 0.01;
if any(above_threshold)
    highlight_plot = plot(wavelengths(above_threshold), mean_err(above_threshold), ...
                         'r.', 'MarkerSize', 12);
end

% Labels and styling
xlabel('Wavelength (nm)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Absolute Error', 'FontSize', 14, 'FontWeight', 'bold');
title('Additivity Error Spectrum', ...
      'FontSize', 16, 'FontWeight', 'bold');

% Axis settings
xlim([380 780]);
ylim([-.0005 0.022]);
set(gca, 'FontSize', 12, 'Layer', 'top', ...
         'XTick', 380:50:780, 'Box', 'on');

% =====================
% Add visible spectrum gradient along x-axis (fixed)
% =====================

% Create RGB gradient for visible spectrum
wl_full = linspace(380, 780, 300); % Higher resolution for smooth gradient
rgb_spectrum = zeros(length(wl_full), 3);

% Define color bands
violet = [0.56, 0.00, 0.56];
blue   = [0.00, 0.00, 1.00];
cyan   = [0.00, 1.00, 1.00];
green  = [0.00, 1.00, 0.00];
yellow = [1.00, 1.00, 0.00];
red    = [1.00, 0.00, 0.00];

% Create smooth color transitions
bands = [380, 420, 460, 500, 560, 600, 780];
colors = [
    violet; 
    (violet+blue)/2;
    blue;
    cyan;
    green;
    yellow;
    red
];

% Generate gradient
for i = 1:length(wl_full)
    wl = wl_full(i);
    band_idx = find(bands >= wl, 1);
    
    if band_idx == 1
        rgb_spectrum(i,:) = colors(1,:);
    elseif band_idx > length(bands)
        rgb_spectrum(i,:) = colors(end,:);
    else
        low_band = bands(band_idx-1);
        high_band = bands(band_idx);
        t = (wl - low_band) / (high_band - low_band);
        rgb_spectrum(i,:) = (1-t)*colors(band_idx-1,:) + t*colors(band_idx,:);
    end
end

% Add color gradient to x-axis
x_limits = xlim;
y_limits = ylim;
gradient_height = 0.02 * diff(y_limits); % Height of color gradient

% Create patch for each color segment (FIXED LOOP SYNTAX)
for i = 1:(length(wl_full)-1)
    x1 = wl_full(i);
    x2 = wl_full(i+1);
    color = rgb_spectrum(i,:);
    
    patch([x1, x2, x2, x1], ...
          [y_limits(1), y_limits(1), y_limits(1)-gradient_height, y_limits(1)-gradient_height], ...
          color, 'EdgeColor', color);
end

% Adjust y-axis limits to accommodate color gradient
ylim([y_limits(1)-gradient_height*2.5, y_limits(2)]);

% Add legend at top-right (northeast)
legend([mean_plot, band_plot], {'Mean Absolute Error', 'Standard Deviation'}, ...
       'Location', 'northeast', 'FontSize', 12);

% Final figure polish
set(gcf, 'Color', 'w');
grid on;

exportgraphics(gca, 'Figures/Additivity_err.png', 'Resolution', 300)