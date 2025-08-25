clc;clear;close all;

% load luminace 2008 ramp
ramps = readmatrix('LuminanceTanzima_HDR_Ramps2008.txt');

% Load the data
red = readmatrix('ramps_TSR/red ramp 16Jan24.csv');
blue = readmatrix('ramps_TSR/blue ramp 13Jan24.csv');
green = readmatrix('ramps_TSR/green ramp 13Jan24.csv');
green = green(1018:end, :); % ask Tanzima
white = readmatrix('ramps_TSR/white ramp 17Jan24.csv');

% calculate the luminace of yellow, magenta and cyan
yellow_luminance=ramps(:,2)+ramps(:,3);
magenta_luminance=ramps(:,2)+ramps(:,4);
cyan_luminance=ramps(:,3)+ramps(:,4);

% SPD to CIE XYZ conversion
cmf = readmatrix('CIE_xyz_1931_2deg.csv');
cmf = cmf(21:421,2:end);

% SPD extraction

red_spd = red(:,10:410);
green_spd = green(:,10:410);
blue_spd = blue(:,10:410);
white_spd = white(:,10:410);

red_xyz = spd2XYZE(red_spd,cmf);
green_xyz = spd2XYZE(green_spd,cmf);
blue_xyz = spd2XYZE(blue_spd,cmf);
white_xyz = spd2XYZE(white_spd,cmf);

cyan_spd = green_spd + blue_spd;
magenta_spd = red_spd + blue_spd;
yellow_spd = red_spd + green_spd;

cyan_xyz = spd2XYZE(cyan_spd,cmf);
magenta_xyz = spd2XYZE(magenta_spd,cmf);
yellow_xyz = spd2XYZE(yellow_spd,cmf);

% Compute xy chromaticity coordinates for each set
red_xy     = compute_xy(red_xyz);
green_xy   = compute_xy(green_xyz);
blue_xy    = compute_xy(blue_xyz);
white_xy   = compute_xy(white_xyz);
cyan_xy    = compute_xy(cyan_xyz);
magenta_xy = compute_xy(magenta_xyz);
yellow_xy  = compute_xy(yellow_xyz);

% Plot chromaticity diagram
figure;
plotChromaticity();
hold on;

% Scatter all points per color
scatter(red_xy(:,1),     red_xy(:,2));
scatter(green_xy(:,1),   green_xy(:,2));
scatter(blue_xy(:,1),    blue_xy(:,2));
scatter(white_xy(:,1),   white_xy(:,2));
scatter(cyan_xy(:,1),    cyan_xy(:,2));
scatter(magenta_xy(:,1), magenta_xy(:,2));
scatter(yellow_xy(:,1),  yellow_xy(:,2));

% Axis settings
xlim([0 0.8])
ylim([0 0.9])
xlabel('x')
ylabel('y')
title('CIE 1931 Chromaticity Diagram with All Samples')
grid on
hold off;


% yellow 5 calculation
yellow_xy_mean=mean(yellow_xy);
xyz_yellow_5=compute_XYZ(yellow_xy_mean,5);

% black  background and landolt C XYZ calculation from luminance
white_xy_mean=mean(white_xy);
xyz_c=compute_XYZ(white_xy_mean,0.07);
xyz_bakground=compute_XYZ(white_xy_mean,0.03);
