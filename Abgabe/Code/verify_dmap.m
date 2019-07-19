function p = verify_dmap(D, G)
    % verify_dmap Peak Signal-To-Noise Ratio berechnen.
    %   p = verify_dmap(D, G)
    %   Diese Funktion berechnet die Peak Signal-To-Noise Ratio zwischen
    %   der gesch�tzten Disparity Map D und der Ground Truth G. 
    %   Die Peak Signal-To-Noise Ratio p wird hierbei in dB zur�ckgegeben.
    %
    % Erstellt: Juli 2019
    
    % Pr�fen, ob D ung G die gleiche Gr��e besitzen.
    if ~isequal(size(D),size(G))
        error('Die Matritzen D und G m�ssen die gleiche Gr��e besitzen!');
    end
    
    % Matritzen gegebenenfalls auf das Intervall [0,255] normieren.
    interval = [0 255];
    D = double(D);
    G = double(G);
    if (min(D,[],'all')<interval(1) || max(D,[],'all')>interval(2))
        D = (interval(2)-interval(1))/(max(D,[],'all')-min(D,[],'all'))*(D-min(D,[],'all'))+interval(1);
    end
    if (min(G,[],'all')<interval(1) || max(G,[],'all')>interval(2))
        G = ((interval(2)-interval(1))/(max(G,[],'all')-min(G,[],'all')))*(G-min(G,[],'all'))+interval(1);
    end
     
    % Peak Signal-To-Noise Ratio berechnen.
    mse = sum(((G-D).^2),'all')/(size(D,1)*size(D,2)*size(D,3));
    p = 20*log10(max(G,[],'all'))-10*log10(mse);

end