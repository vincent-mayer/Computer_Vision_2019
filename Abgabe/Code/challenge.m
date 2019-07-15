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
%% Bilder laden
selpath = uigetdir(path);
[K K1 Image1 Image2] = load_path(selpath);

row = size(Image1,1);
colum =  size(Image1,2);

%  Image1=imresize(Image1,[row,colum]);
%  Image2=imresize(Image2,[row,colum]);

IGray1 = rgb_to_gray(Image1);
IGray2 = rgb_to_gray(Image2);

% Merkmale1 = MerkmaleBild1(IGray1,row,colum);
% Merkmale2 = MerkmaleBild1(IGray2,row,colum);
%% Block Matching
DisMap=Disparity_blocks(IGray1, IGray2, 2, 2, 250,'true');

%% Harris-Merkmale berechnen
% for i=5:2:15
Merkmale1 = harris_detektor(IGray1,'segment_length',3,'k',0.04,'min_dist',4,'N',40,'do_plot',false);
Merkmale2 = harris_detektor(IGray2,'segment_length',3,'k',0.04,'min_dist',4,'N',40,'do_plot',false);
Merkmale3 = harris_detektor(IGray1,'segment_length',3,'k',0.04,'min_dist',colum-4,'N',40,'do_plot',false);
Merkmale4 = harris_detektor(IGray2,'segment_length',3,'k',0.04,'min_dist',colum-4,'N',40,'do_plot',false);
%@Theo ToDo: check if features are already existing
Merkmale5 = zeros(2, size(Merkmale1, 2) + size(Merkmale3, 2));
Merkmale6 = zeros(2, size(Merkmale2, 2) + size(Merkmale4, 2));
Merkmale5(:, 1:size(Merkmale1, 2)) = Merkmale1(:, 1:end);
Merkmale5(:, size(Merkmale1, 2)+1:end) = Merkmale3(:, 1:end);
Merkmale6(:, 1:size(Merkmale2,2)) = Merkmale2(:, 1:end);
Merkmale6(:, size(Merkmale2,2)+1:end) = Merkmale4(:, 1:end);
%% Korrespondenzen and shit
Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale5,Merkmale6,'window_length',25,'min_corr', 0.9)
[Korrespondenzen_robust anzahl] = F_ransac(Korrespondenzen, 'tolerance', 0.04);
E = achtpunktalgorithmus(Korrespondenzen_robust, K);
[T1, R1, T2, R2] = TR_aus_E(E);
[T, R, lambda, P1] = rekonstruktion(T1, T2, R1, R2, Korrespondenzen_robust, K);
lambda = lambda(:,1);

%% Interpolation and stuff
vq = interpolation(Korrespondenzen_robust(1,:),Korrespondenzen_robust(2,:), lambda, row, colum, Image1,'natural');
vq(isnan(vq))=0;
%% Übereinander legen
for x=1:row
    for y=1:colum
        m_new(x,y) = (0.5*vq(x,y) + 0.5*DisMap(x,y)) / 2;
    end
end
%% Display
%@Theo ToDo: export to "Results" folder
figure
    imagesc(DisMap);
    colormap gray 
figure
    imagesc(vq);
    colormap gray 
figure
    imagesc(m_new);
    colormap gray 
%% Median Filter
N = 10;
im_pad = padarray(m_new, [floor(N/2) floor(N/2)]);
im_col = im2col(im_pad, [N N], 'sliding');
sorted_cols = sort(im_col, 1, 'ascend');
med_vector = sorted_cols(floor(N*N/2) + 1, :);
IGray1 = col2im(med_vector, [N N], size(im_pad), 'sliding');
%%
figure
    imagesc(IGray1)
    colormap gray 

% Calculate disparity map and Euclidean motion
% [D, R, T] = disparity_map(scene_path)
D=IGray1;
%% Validation
% Specify path to ground truth disparity map || Not really needed, because ground truth are in the same folder as im0,im1 and calib
 gt_path = selpath; 
%
% Load the ground truth
 G = read_pfm(gt_path+'/disp0.pfm');;
% 
% Estimate the quality of the calculated disparity map
 p = validate_dmap(D, G);

%% Stop timer here
elapsed_time = toc;


%% Print Results
fprintf( 'R = %.2f,  T= %.2f,  p= %.2f, Elapsed time= %.2f\n', R,T,p,elapsed_time);
% R, T, p, elapsed_time
save('challenge.mat'); %Für test.m notwendig
run(test); %ruft test.m auf.
delete('challenge.mat'); 

%% Display Disparity
figure
imagesc(D)

