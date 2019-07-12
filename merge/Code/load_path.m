function [cam0, cam1, im0, im1] = load_path(path)
    % load_path Lade Pfad.
    %   [cam0, cam1, im0, im1] = load_path(path)
    %   Diese Funktion lädt die beiden Bilder im Pfad path und liest die K-
    %   Matritzen der beiden Kameras aus der calib.txt Datei aus. Der
    %   Eingabeparameter der Funktion ist der absolute Dateipfad als String
    %   und die Rückgabeparameter sind die beiden K-Matritzen und die beiden
    %   Bilder.
    %
    % Robert Lefringhausen <robert.lefringhausen@tum.de>
    % Erstellt: Juli 2019
    
    calib_str = fileread([path '\calib.txt']);
    pos_matstart = strfind(calib_str,'[');
    pos_matend = strfind(calib_str,']');

    cam0 = str2num(calib_str(pos_matstart(1):pos_matend(1)));
    cam1 = str2num(calib_str(pos_matstart(2):pos_matend(2)));
    
    % Bilder laden
    im0 = imread([path '\im0.png']);
    im1 = imread([path '\im1.png']);
    
    disp('   Die Dateien aus dem Ordner wurden eingelesen.');
end

