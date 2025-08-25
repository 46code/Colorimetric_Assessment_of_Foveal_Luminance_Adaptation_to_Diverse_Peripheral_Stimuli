clc; clear; close all;

%% XYZ Calcualtion 

% Load the data
white = readmatrix('ramps_TSR/white ramp 17Jan24.csv');
red = readmatrix('ramps_TSR/red ramp 16Jan24.csv');
blue = readmatrix('ramps_TSR/blue ramp 13Jan24.csv');
green = readmatrix('ramps_TSR/green ramp 13Jan24.csv');
green = green(1018:end, :); % ask Tanzima

% SPD extraction (range 390-780 nm)
white_spd = white(:,20:410);
red_spd = red(:,20:410);
green_spd = green(:,20:410);
blue_spd = blue(:,20:410);
cyan_spd = green_spd + blue_spd;
magenta_spd = red_spd + blue_spd;
yellow_spd = red_spd + green_spd;

% SPD to CIE XYZ conversion
%cmf = readmatrix('CIE_xyz_1931_2deg.csv'); % CMF 1931 2 degree
cmf=readmatrix('lin2012xyz2e_1_7sf.csv');
cmf = cmf(1:391,2:end); % range 390-780 nm

white_xyz = spd2XYZE(white_spd,cmf);
red_xyz = spd2XYZE(red_spd,cmf);
green_xyz = spd2XYZE(green_spd,cmf);
blue_xyz = spd2XYZE(blue_spd,cmf);
cyan_xyz = spd2XYZE(cyan_spd,cmf);
magenta_xyz = spd2XYZE(magenta_spd,cmf);
yellow_xyz = spd2XYZE(yellow_spd,cmf);

% Compute xy chromaticity
white_xy   = compute_xy(white_xyz);
red_xy     = compute_xy(red_xyz);
green_xy   = compute_xy(green_xyz);
blue_xy    = compute_xy(blue_xyz);
cyan_xy    = compute_xy(cyan_xyz);
magenta_xy = compute_xy(magenta_xyz);
yellow_xy  = compute_xy(yellow_xyz);

% compute the mean of xy
white_xy_mean=mean(white_xy);
red_xy_mean=mean(red_xy);
green_xy_mean=mean(green_xy);
blue_xy_mean=mean(blue_xy);
cyan_xy_mean=mean(cyan_xy);
magenta_xy_mean=mean(magenta_xy);
yellow_xy_mean=mean(yellow_xy);

%% Plot xy chromaticity diagram
figure;
plotChromaticity();
hold on;

% Plot sample points with black-edged circles
scatter(white_xy(:,1), white_xy(:,2), 50, 'w', 'filled', 'MarkerEdgeColor', 'k');
scatter(red_xy(:,1), red_xy(:,2), 50, [1 0 0], 'filled', 'MarkerEdgeColor', 'k');
scatter(green_xy(:,1), green_xy(:,2), 50, [0 1 0], 'filled', 'MarkerEdgeColor', 'k');
scatter(blue_xy(:,1), blue_xy(:,2), 50, [0 0 1], 'filled', 'MarkerEdgeColor', 'k');
scatter(cyan_xy(:,1), cyan_xy(:,2), 50, [0 1 1], 'filled', 'MarkerEdgeColor', 'k');
scatter(magenta_xy(:,1), magenta_xy(:,2), 50, [1 0 1], 'filled', 'MarkerEdgeColor', 'k');
scatter(yellow_xy(:,1), yellow_xy(:,2), 50, [1 1 0], 'filled', 'MarkerEdgeColor', 'k');

% Plot bold mean crosses
plot(white_xy_mean(1),   white_xy_mean(2),   'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(red_xy_mean(1),     red_xy_mean(2),     'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(green_xy_mean(1),   green_xy_mean(2),   'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(blue_xy_mean(1),    blue_xy_mean(2),    'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(cyan_xy_mean(1),    cyan_xy_mean(2),    'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(magenta_xy_mean(1), magenta_xy_mean(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(yellow_xy_mean(1),  yellow_xy_mean(2),  'kx', 'MarkerSize', 12, 'LineWidth', 2.5);

% Add large, bold text labels near each mean
offset = 0.015;
fontsize = 12;
text(white_xy_mean(1)+offset,   white_xy_mean(2),   'White',   'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(red_xy_mean(1)+offset,     red_xy_mean(2),     'Red',     'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(green_xy_mean(1)+offset,   green_xy_mean(2),   'Green',   'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(blue_xy_mean(1)+offset,    blue_xy_mean(2),    'Blue',    'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(cyan_xy_mean(1)+offset,    cyan_xy_mean(2),    'Cyan',    'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(magenta_xy_mean(1)+offset, magenta_xy_mean(2), 'Magenta', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(yellow_xy_mean(1)+offset,  yellow_xy_mean(2),  'Yellow',  'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);

% Axes and layout
xlim([0 0.8])
ylim([0 0.9])
xlabel('x')
ylabel('y')
title('CIE xy Chromaticity Diagram')
grid on
axis square
hold off;

%% Plot uv Chromaticity

% Compute CIE 1976 uv chromaticity
white_uv = compute_uv(white_xyz);
red_uv = compute_uv(red_xyz);
green_uv = compute_uv(green_xyz);
blue_uv = compute_uv(blue_xyz);
cyan_uv = compute_uv(cyan_xyz);
magenta_uv = compute_uv(magenta_xyz);
yellow_uv = compute_uv(yellow_xyz);

% Compute mean uv values
white_uv_mean = mean(white_uv);
red_uv_mean = mean(red_uv);
green_uv_mean = mean(green_uv);
blue_uv_mean = mean(blue_uv);
cyan_uv_mean = mean(cyan_uv);
magenta_uv_mean = mean(magenta_uv);
yellow_uv_mean = mean(yellow_uv);

% plot the figure
% Create u'v' chromaticity diagram
figure;
plotChromaticity("ColorSpace","uv")  % Custom function to plot CIE 1976 diagram
hold on;

% Plot sample points with black-edged circles
scatter(white_uv(:,1), white_uv(:,2), 50, 'w', 'filled', 'MarkerEdgeColor', 'k');
scatter(red_uv(:,1), red_uv(:,2), 50, [1 0 0], 'filled', 'MarkerEdgeColor', 'k');
scatter(green_uv(:,1), green_uv(:,2), 50, [0 1 0], 'filled', 'MarkerEdgeColor', 'k');
scatter(blue_uv(:,1), blue_uv(:,2), 50, [0 0 1], 'filled', 'MarkerEdgeColor', 'k');
scatter(cyan_uv(:,1), cyan_uv(:,2), 50, [0 1 1], 'filled', 'MarkerEdgeColor', 'k');
scatter(magenta_uv(:,1), magenta_uv(:,2), 50, [1 0 1], 'filled', 'MarkerEdgeColor', 'k');
scatter(yellow_uv(:,1), yellow_uv(:,2), 50, [1 1 0], 'filled', 'MarkerEdgeColor', 'k');

% Plot bold mean crosses
plot(white_uv_mean(1), white_uv_mean(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(red_uv_mean(1), red_uv_mean(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(green_uv_mean(1), green_uv_mean(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(blue_uv_mean(1), blue_uv_mean(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(cyan_uv_mean(1), cyan_uv_mean(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(magenta_uv_mean(1), magenta_uv_mean(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2.5);
plot(yellow_uv_mean(1), yellow_uv_mean(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2.5);

% Add large, bold text labels near each mean
offset = 0.015;
fontsize = 8;
text(white_uv_mean(1)+offset, white_uv_mean(2), 'White', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(red_uv_mean(1)+offset, red_uv_mean(2), 'Red', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(green_uv_mean(1)+offset, green_uv_mean(2), 'Green', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(blue_uv_mean(1)+offset, blue_uv_mean(2), 'Blue', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(cyan_uv_mean(1)+offset, cyan_uv_mean(2), 'Cyan', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(magenta_uv_mean(1)+offset, magenta_uv_mean(2), 'Magenta', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);
text(yellow_uv_mean(1)+offset, yellow_uv_mean(2), 'Yellow', 'Color', 'k', 'FontWeight', 'bold', 'FontSize', fontsize);

% Axes and layout
xlim([0 0.7])
ylim([0 0.7])
xlabel('u''')
ylabel('v''')
title('CIE 1976 u''v'' Chromaticity Diagram')
grid on
axis square
hold off;

exportgraphics(gca, 'Figures/CIE1976uv.png', 'Resolution', 300)

%% yellow 5 XYZ calculations
yellow_5=compute_XYZ(yellow_xy_mean,5);

% Prepend 6 zero rows to each XYZ matrix
white_xyz = [zeros(6,3); white_xyz];
red_xyz = [zeros(6,3); red_xyz];
green_xyz = [zeros(6,3); green_xyz];
blue_xyz = [zeros(6,3); blue_xyz];
cyan_xyz = [zeros(6,3); cyan_xyz];
magenta_xyz = [zeros(6,3); magenta_xyz];
yellow_xyz = [zeros(6,3); yellow_xyz];
yellow_xyz(5,:) = yellow_5;

save('xyz_data.mat', ...
     'white_xyz', 'red_xyz', 'green_xyz', 'blue_xyz', ...
     'cyan_xyz', 'magenta_xyz', 'yellow_xyz');

%% Luminance 2008 Calcualtion

% load luminance ramps 2008
ramps = readmatrix('LuminanceTanzima_HDR_Ramps2008.txt');

% calculate the luminace of yellow, magenta and cyan
yellow_luminance=ramps(:,2)+ramps(:,3);
magenta_luminance=ramps(:,2)+ramps(:,4);
cyan_luminance=ramps(:,3)+ramps(:,4);

% add the CMY luminance to ramps
% order-> W,R,G,B,Y,M,C
ramps=[ramps,yellow_luminance,magenta_luminance,cyan_luminance];

% add 6 rows at top
ramps=[zeros(6,7);ramps];

% add the yellow 5 luminance as 5 
ramps(5,5)=5;

% save the ramps as csv file
writematrix(ramps, 'ramps7.csv');

% plot of the ramps
% Assumes ramps is an N×7 matrix
figure;

% Plot each color channel
plot(ramps(:,1), 'k', 'DisplayName', 'White',   'LineWidth', 1.5); hold on;
plot(ramps(:,2), 'r', 'DisplayName', 'Red',     'LineWidth', 1.5);
plot(ramps(:,3), 'g', 'DisplayName', 'Green',   'LineWidth', 1.5);
plot(ramps(:,4), 'b', 'DisplayName', 'Blue',    'LineWidth', 1.5);
plot(ramps(:,5), 'y', 'DisplayName', 'Yellow',  'LineWidth', 1.5);
plot(ramps(:,6), 'm', 'DisplayName', 'Magenta', 'LineWidth', 1.5);
plot(ramps(:,7), 'c', 'DisplayName', 'Cyan',    'LineWidth', 1.5);

% Axes settings
xlim([0 1023])
xlabel('Pixel Value', 'FontWeight', 'bold', 'FontSize', 12)
ylabel('Luminance (cd/m²)', 'FontWeight', 'bold', 'FontSize', 12)
title('Luminance Ramps 2008', 'FontWeight', 'bold', 'FontSize', 14)

legend('Location', 'northwest');
set(gca, 'FontSize', 11)
exportgraphics(gca, 'Figures/Luma_ramps2008.png', 'Resolution', 300)

%% Calculate the landolt-C XYZ and Black background XYZ
landolt_C_xyz=compute_XYZ(white_xy_mean,0.07);
bakground_xyz=compute_XYZ(white_xy_mean,0.03);



