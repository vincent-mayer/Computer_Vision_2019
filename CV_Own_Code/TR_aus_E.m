function [T1, R1, T2, R2, U, V]=TR_aus_E(E)
    % Diese Funktion berechnet die moeglichen Werte fuer T und R
    % aus der Essentiellen Matrix
    [U, S, V] = svd(E);
    R_Z1 = [0, -1, 0; 1, 0, 0; 0, 0, 1];
    R_Z2 = [0, 1, 0; -1, 0, 0; 0, 0, 1];
    % Determinante von U und V ändern
    U = U*[1, 0, 0; 0, 1, 0; 0, 0, -1];
    V = V*[1, 0, 0; 0, 1, 0; 0, 0, -1];
    R1 = U*R_Z1'*V';
    T1_dach = U*R_Z1*S*U';
    T1 = [T1_dach(3,2); T1_dach(1,3); T1_dach(2,1)];
    R2 = U*R_Z2'*V';
    T2_dach = U*R_Z2*S*U';
    T2 = [T2_dach(3,2); T2_dach(1,3); T2_dach(2,1)];
end

