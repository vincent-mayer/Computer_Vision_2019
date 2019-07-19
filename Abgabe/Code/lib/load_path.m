function [cam0, cam1, im0, im1, baseline,v_min,v_max] = load_path(path)
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

    calib_str = fileread([path filesep 'calib.txt']);

    pos_matstart = strfind(calib_str,'[');
    pos_matend = strfind(calib_str,']');
    
    pre_baseline = strfind(calib_str,'line=');
    post_baseline = strfind(calib_str,'w');
    
    pre_vmin = strfind(calib_str,'vmin=');
    post_vmin = strfind(calib_str,'vmax');
    pre_vmax = strfind(calib_str,'vmax=');
    post_vmax = strfind(calib_str,'dyavg');
    
    cam0 = str2num(calib_str(pos_matstart(1):pos_matend(1)));
    cam1 = str2num(calib_str(pos_matstart(2):pos_matend(2)));
    
    baseline = str2num(calib_str((pre_baseline+5):(post_baseline-1)));
    v_min = str2num(calib_str((pre_vmin+5):(post_vmin-1)));
    v_max = str2num(calib_str((pre_vmax+5):(post_vmax-1)));
        
    % Bilder laden
    
    im0 = imread([path filesep 'im0.png']);
    im1 = imread([path filesep 'im1.png']);
    
    disp('   Die Dateien aus dem Ordner wurden eingelesen.');
end

