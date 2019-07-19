function [cam0, cam1, im0, im1, baseline] = load_path(path)
    % load_path Lade Pfad.
    %   [cam0, cam1, im0, im1, baseline] = load_path(path)
    %   Diese Funktion l�dt die beiden Bilder im Pfad path und liest die K-
    %   Matritzen der beiden Kameras sowie die Baseline aus der calib.txt Datei aus. Der
    %   Eingabeparameter der Funktion ist der absolute Dateipfad als String
    %   und die R�ckgabeparameter sind die beiden K-Matritzen, die Baseline und die beiden
    %   Bilder.
    %
    % Robert Lefringhausen <robert.lefringhausen@tum.de>
    % Erstellt: Juli 2019
if contains(path,'/')
    calib_str = fileread([path '/calib.txt']);
else
    calib_str = fileread([path '\calib.txt']);
end
    pos_matstart = strfind(calib_str,'[');
    pos_matend = strfind(calib_str,']');
    
    pre_baseline = strfind(calib_str,'line=');
    post_baseline = strfind(calib_str,'w');
    
    cam0 = str2num(calib_str(pos_matstart(1):pos_matend(1)));
    cam1 = str2num(calib_str(pos_matstart(2):pos_matend(2)));
    
    baseline = str2num(calib_str((pre_baseline+5):(post_baseline-1)));
    % Bilder laden
if contains(path,'/')
    im0 = imread([path '/im0.png']);
    im1 = imread([path '/im1.png']);
else
    im0 = imread([path '\im0.png']);
    im1 = imread([path '\im1.png']);
end
    
    disp('   Die Dateien aus dem Ordner wurden eingelesen.');
end

