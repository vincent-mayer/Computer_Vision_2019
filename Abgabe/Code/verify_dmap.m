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
     
    % Peak Signal-To-Noise Ratio berechnen.
    mse = sum(((G-D).^2),'all')/(size(D,1)*size(D,2)*size(D,3));
    p = 20*log10(max(G,[],'all'))-10*log10(mse);

end