function p = verify_dmap(D, G)
    % verify_dmap Peak Signal-To-Noise Ratio berechnen.
    %   p = verify_dmap(D, G)
    %   Diese Funktion berechnet die Peak Signal-To-Noise Ratio zwischen
    %   der geschätzten Disparity Map D und der Ground Truth G. 
    %   Die Peak Signal-To-Noise Ratio p wird hierbei in dB zurückgegeben.
    %
    % Erstellt: Juli 2019
    
    % Prüfen, ob D ung G die gleiche Größe besitzen.
    if ~isequal(size(D),size(G))
        error('Die Matritzen D und G müssen die gleiche Größe besitzen!');
    end
    
    % Matritzen auf das Intervall [0,255] normieren.
    interval = [0 255];
    D = double(D);
    G = double(G);
    D = (interval(2)-interval(1))/(max(D,[],'all')-min(D,[],'all'))*(D-min(D,[],'all'))+interval(1);
    G = ((interval(2)-interval(1))/(max(G,[],'all')-min(G,[],'all')))*(G-min(G,[],'all'))+interval(1);
     
    % Peak Signal-To-Noise Ratio berechnen.
    mse = sum(((G-D).^2),'all')/(size(D,1)*size(D,2)*size(D,3));
    p = 10*log10((max(G,[],'all')^2)/mse);

end