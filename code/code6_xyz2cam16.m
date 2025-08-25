clc; clear; close all;
addpath('CAIM16_main/');

% Load and preprocess data
demo = readtable('demographics.csv');
demo = sortrows(demo, 1);  % Sort by ID, then Age
demo{:,1} = demo{:,1} + 1;

% Observer ID for male and female groups
maleIDs = demo.ID(strcmp(demo.Gender, 'M'));
femaleIDs = demo.ID(strcmp(demo.Gender, 'F'));
genderGroups = {maleIDs; femaleIDs};
groupNames = {'Male'; 'Female'};

% Observer Id for 3 age group
ageGroups = {
    demo.ID(demo.Age >= 20 & demo.Age < 30);   % 20-30
    demo.ID(demo.Age >= 30 & demo.Age < 40);   % 30-40
    demo.ID(demo.Age >= 40)                    % 40+
};
ageGroupNames = {'20-30'; '30-40'; '40+'};

% set the parameters
%XYZ= [0.07238; 0.0760; 0.08662]; % Tanzima
XYZ_C= [0.06641;	0.0700; 0.07793];
XYZ_background=[0.02846; 0.03000; 0.03340];
Y_b = 0.01;         % Background luminance factor (%)
surround = 'dark';  % Surround condition

% calculate the jab 
% Gender based jab
jab_male=group2jab(maleIDs, XYZ_C, Y_b, surround, XYZ_background);
jab_female=group2jab(femaleIDs, XYZ_C, Y_b, surround, XYZ_background);

% Age based jab
jab_20_30=group2jab(ageGroups{1}, XYZ_C, Y_b, surround, XYZ_background);
jab_30_40=group2jab(ageGroups{2}, XYZ_C, Y_b, surround, XYZ_background);
jab_40=group2jab(ageGroups{3}, XYZ_C, Y_b, surround, XYZ_background);

% All observer
jab_all=group2jab(1:30, XYZ_C, Y_b, surround, XYZ_background);

% plotting 4 figure 
jabplot(jab_male, jab_female, jab_20_30, jab_30_40, jab_40, jab_all)
