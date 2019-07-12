%% Bilder einlesen
clc
clear all
close all
Image1 =imread('Pictures/motorcycle/im0.png');
Image2 =imread('Pictures/motorcycle/im1.png');
%% Fundamentalmatrix berechnen
% Umwandeln in Grauwertbild
IGray1 = rgb_to_gray(Image1);
IGray2 = rgb_to_gray(Image2);
% Merkmale Harrisdetektor
Merkmale1 = harris_detektor(IGray1,'segment_length',9,'k',0.05,'min_dist',40,'N',50,'do_plot',false);
Merkmale2 = harris_detektor(IGray2,'segment_length',9,'k',0.05,'min_dist',40,'N',50,'do_plot',false);
% Korrespondenzschaetzung
Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale1,Merkmale2,'window_length',25,'min_corr',0.9,'do_plot',false);
% Finde robuste Korrespondenzpunktpaare mit Hilfe des RANSAC-Algorithmus
Korrespondenzen_robust = F_ransac(Korrespondenzen, 'tolerance', 0.04);
[K1,K2] = read_K('Pictures/motorcycle/calib.txt');
E = achtpunktalgorithmus(Korrespondenzen_robust, K1);
% F berechnen
F = achtpunktalgorithmus(Korrespondenzen_robust);

%% Block Matching
k=5;
DisMap = stereoDisparityoriginal(IGray2, IGray1, k, 250, 'true');
%DispMap = stereoDisparity_blocks
%% Disparity Map Ausgabe
% Normalize Disparity Map
DispMap_norm = normalize_var(DisMap,0,1);
figure
imshow(DispMap_norm)
title(num2str(k))
save('DisMap_2.mat')