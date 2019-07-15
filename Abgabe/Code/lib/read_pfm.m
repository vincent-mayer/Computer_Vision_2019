function data = read_pfm(filepath)
    % read_pfm .pfm Datei auslesen.
    %   data = read_pfm(path)
    %   Diese Funktion liest die .pfm Datei unter dem Pfad path aus und 
    %   gibt die enthaltenen Daten als uint8 Matrix (data) zurück. 
    %   Handelt es sich bei der .pfm Datei um ein Farbbild, werden alle
    %   drei Farbkanäle zurückgegeben.
    %   Eine Dokumentation über das .pfm Format findet sich auf folgender
    %   Website: http://netpbm.sourceforge.net/doc/pfm.html.
    %
    % Erstellt: Juli 2019
    
    %% Bildinformationen auslesen   
    % Die Datei wird geöffnet 
    fileID = fopen(filepath);
    
    % Farbbild/Grauwertbild wird bestimmt (siehe Website in der
    % Funktionsbeschreibung).
    line1 = fgetl(fileID);
    if strcmp(line1,'PF')
        channels = 3;
    elseif strcmp(line1,'Pf')
        channels = 1;
    else
        error(['Die Ground Truth konnte nicht ausgelesen werden.' ...
        ' Überprüfe ob diese im übergeben Ordner als .pfm Datei vorliegt!']);
    end
    
    % Breite und Höhe werden bestimmt (siehe Website).
    line2 = fgetl(fileID);
    width = str2num(line2(1:(strfind(line2,' ')-1)));
    height = str2num(line2((strfind(line2,' ')+1):end));
    
    % Byte Reihenfolge wird bestimmt (siehe Website).
    line3 = fgetl(fileID);
    if (str2num(line3)>=0)
        endian = 'b';
    else
        endian = 'l';
    end
    
    %% Bilddaten auslesen
    % Grauwertbild aus binary file auslesen.
    if (channels == 1)
        pfm_data = fread(fileID, Inf, 'single', 0 ,endian);
        data = rot90(reshape(pfm_data(1:end)',[width, height]));
    end
    
    % Farbbild aus binary file auslesen.
    if (channels == 3)
        data = zeros(width,height,3);
        pfm_data = fread(fileID, Inf, 'single', 0 ,endian);
        data(:,:,1) = rot90(reshape(pfm_data(1:3:end),[width, height]));
        data(:,:,2) = rot90(reshape(pfm_data(2:3:end),[width, height]));
        data(:,:,3) = rot90(reshape(pfm_data(3:3:end),[width, height]));
    end
    
    % Bilddaten in uint8 umwandeln.
    interval = [0 255];
    data = ((interval(2)-interval(1))/(max(data(data~=Inf),[],'all')-min(data(data~=Inf),[],'all')))*(data-min(data(data~=Inf),[],'all'))+interval(1);
    data(data==Inf) = 0;
    data = uint8(data);
    
    fclose(fileID);
end