%% Bilder laden
clc
clear all
close all
Image1 =imread('im0.png');
Image2 =imread('im1.png');
IGray1 = rgb_to_gray(Image1);
IGray2 = rgb_to_gray(Image2);
plot_corr = 1;
%% Harris-Merkmale berechnen
Merkmale1 = harris_detektor(IGray1,'segment_length',9,'k',0.05,'min_dist',40,'N',50,'do_plot',false);
Merkmale2 = harris_detektor(IGray2,'segment_length',9,'k',0.05,'min_dist',40,'N',50,'do_plot',false);
tic
%% Korrespondenzsch�tzung
Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale1,Merkmale2,'window_length',25,'min_corr',0.9,'do_plot',false);

%%  Finde robuste Korrespondenzpunktpaare mit Hilfe des RANSAC-Algorithmus
Korrespondenzen_robust = F_ransac(Korrespondenzen, 'tolerance', 0.04);

%% Zeige die robusten Korrespondenzpunktpaare
%punkt_korrespondenzen(IGray1,IGray2,Korrespondenzen_robust(1:2,:),Korrespondenzen_robust(3:4,:),'window_length',25,'min_corr',0.9,'do_plot',true); %warum nicht einfach so?!
if plot_corr
figure(1);
imshow(Image1);
hold on;
imshow(Image2);
alpha(0.5);
for i=1:1:size(Korrespondenzen_robust,2)
    plot(Korrespondenzen_robust(1,i),Korrespondenzen_robust(2,i), 'r.');
    plot(Korrespondenzen_robust(3,i),Korrespondenzen_robust(4,i), 'g.');
    plot([Korrespondenzen_robust(1,i),Korrespondenzen_robust(3,i)],[Korrespondenzen_robust(2,i),Korrespondenzen_robust(4,i)],'k-');
end
hold off;
end
%% Disparity Map 
% Read in Calibration matrices
str=fileread('calib.txt');
parts = regexp(str, '\[|\]', 'split');
K1 = double(str2num(parts{2}));
K2 = double(str2num(parts{4}));

%% Berechne die Essentielle Matrix
E = achtpunktalgorithmus(Korrespondenzen_robust, K1);
disp(E);
%% Errechne Euklidische Bewegungen aus E
[T1, R1, T2, R2, U, V] = TR_aus_E(E);
%% Errechne die Tiefeninformation für robuste Korrespondenzen im ersten Frame
[T, R, lambda, P1] = rekonstruktion(T1, T2, R1, R2, Korrespondenzen_robust, K1);
lambda = lambda';
toc
%% Plotte die Tiefeninformationen für die Korrespondenzpunkte
lambda1 = lambda(1,:);
lambda2 = lambda(2,:);
lambda1(lambda1 > 10) = [];
lambda1(lambda1 < -10) = [];
lambda2(lambda2 > 10) = [];
lambda1_norm = normalize_var(lambda1(1,:),0, 1);
%lambda1_norm = round(lambda1_norm);
lambda2_norm = normalize_var(lambda2(1,:),0, 1);
%lambda2_norm = round(lambda2_norm);
blank_image = zeros(2100,3100);
a = 10;
Korrespondenzen_robust = Korrespondenzen_robust + 11;
figure
imshow(blank_image)

blankimage = blank_image;
for i = 1:size(lambda1_norm,2)
    blankimage((Korrespondenzen_robust(2,i)-a):(Korrespondenzen_robust(2,i)+a),(Korrespondenzen_robust(1,i)-a):(Korrespondenzen_robust(1,i)+a)) = lambda1_norm(1,i);

end
figure
imshow(blankimage);