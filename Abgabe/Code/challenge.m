%% Computer Vision Challenge 2019
global group_number members mail R T elapsed_time D G p;

% Group number:
group_number = 59;

% Group members:
members = { 'Andreas Gaßner', 'Øivind Harket Bakke', 'Vincent Mayer','Robert Lefringhausen', 'Theophil Spiegeler Castaneda'};

% Email-Address (from Moodle!):
mail = {'andreas.gassner@tum.de','oivind.bakke@tum.de','vincent.mayer@tum.de','robert.lefringhausen@tum.de','ge82bab@mytum.de'};

%% Initialisierung
addpath(genpath(fileparts(which(mfilename))));

%% Start timer here
tic

%% Disparity Map
% Gegebenenfalls Pfad w�hlen.
if exist('directoryname', 'var')
    selpath = directoryname;
    path_existing = 1;
else
    selpath = uigetdir(path);
    path_existing = 0;
end   


[T ,R, D] = disparity_map(selpath);

%% Validation 
% Ground Truth laden.
G = read_pfm([selpath filesep 'disp0.pfm']);
 
% PSNR berechnen.
p = verify_dmap(D, G);

%% Stop timer here
elapsed_time = toc;


%% Print Results
% R, T, p und elapsed_time in Commandozeile ausgeben.
disp('R =');
disp(R);
disp('T =');
disp(T);
fprintf('p = %.2f dB\nElapsed time = %.2f s\n', p, elapsed_time);


%% Display Disparity
figure
imagesc(D);

