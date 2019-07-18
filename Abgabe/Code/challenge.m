%% Computer Vision Challenge 2019

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

% Bilder laden und in Grauwertbild konvertieren.
[K K1 Image1 Image2 baseline] = load_path(selpath);
IGray1 = rgb_to_gray(Image1);
IGray2 = rgb_to_gray(Image2);

% Disparity Map �ber Block Matching Algorithmus berechnen.
DisMap = Disparity_blocks(IGray1, IGray2, 2, 2, 250,'true');

% Disparity Map �ber Achtpunktalgorithmus berechnen.
[T ,R , DisMapFeature] = DispfromFeatures_TR(IGray1 , IGray2, K, baseline);


D = IGray1;

%% Validation 
% Ground Truth laden.
G = read_pfm([selpath '/disp0.pfm']);
 
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

 save('challenge.mat');
% run(test);

%% Display Disparity
figure
imagesc(D)

