%% Computer Vision Challenge 2019
clc
clear all
close all

% Group number:
group_number = 59;

% Group members:
members = { 'Andreas Gaßner', 'Øivind Harket Bakke', 'Vincent Mayer','Robert Lefringhausen', 'Theophil Spiegeler Castaneda'};

% Email-Address (from Moodle!):
mail = {'andreas.gassner@tum.de','oivind.bakke@tum.de','vincent.mayer@tum.de','robert.lefringhausen@tum.de','ge82bab@mytum.de'};

%% Start timer here
tic

%% Disparity Map
% Specify path to scene folder containing img0 img1 and calib
%Requires to be in the right directory in MATLAB to work, due to the use of currentFolder
wanted_picture=motorcycle;
scene_path = currentFolder + '/Pictures/' + char(wanted_picture);
[cam0, cam1, im0, im1]=load_path(scene_path); 
% Calculate disparity map and Euclidean motion
% [D, R, T] = disparity_map(scene_path)

%% Validation
% Specify path to ground truth disparity map || No need, because ground truth are in the same folder as im0,im1 and calib
% gt_path = scene_path + '/ground_truth.jpg';
%
% Load the ground truth
 G = scene_path + '/ground_truth.jpg';
% 
% Estimate the quality of the calculated disparity map
% p = validate_dmap(D, G)

%% Stop timer here
elapsed_time = toc;


%% Print Results
fprintf( 'R = %.2f,  T= %.2f,  p= %.2f, Elapsed time= %d\n', R,T,p,elapsed_time);
% R, T, p, elapsed_time
save('challenge.mat'); %Für test.m notwendig
run(test); %ruft test.m auf.
delete('challenge.mat'); %Ist es notwendig? 

%% Display Disparity
figure
imagesc(D)

