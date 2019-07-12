function [EF] = achtpunktalgorithmus(Korrespondenzen, K)
    % Diese Funktion berechnet die Essentielle Matrix oder Fundamentalmatrix
    % mittels 8-Punkt-Algorithmus, je nachdem, ob die Kalibrierungsmatrix 'K'
    % vorliegt oder nicht
    
    % Homogene Koordinaten erzeugen
    x1 = Korrespondenzen(1:2,:);
    x1(3,:)=1;
    x2 = Korrespondenzen(3:4,:);
    x2(3,:)=1;
    
    % Kalibrierung mit Kalibrierungsmatrix
    if nargin==2
        x1 = inv(K)*x1;
        x2 = inv(K)*x2;
    end
    
    % A bestimmen
    A = zeros(size(x1,2),9);
    
    for i=1:size(x1,2)
        A(i,:) = kron(x1(:,i),x2(:,i));
    end
    
    % Singulärwertzerlegung
    [U,S,V] = svd(A);
    
    %% Schaetzung der Matrizen
    % G bestimmen
    G = reshape(V(:,9),3,3);
    
    % Singulärwertzerlegung
    [U_G,S_G,V_G] = svd(G);
    
    if nargin==2
        % Essentielle Matrix
        % Essentielle Matrix
        EF = U_G*[1 0 0; 0 1 0; 0 0 0]*V_G';   
    else
        % Fundamentalmatrix
        S_G(3,3) = 0;
        EF = U_G*S_G*V_G'; 
    end
    
end