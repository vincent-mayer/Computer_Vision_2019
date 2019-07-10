function [T1, R1, T2, R2, U, V]=TR_aus_E(E)
    % Diese Funktion berechnet die moeglichen Werte fuer T und R
    % aus der Essentiellen Matrix
    [U,S,V]=svd(E);
    d = [ 1, 0, 0; 0, 1, 0; 0, 0, -1];
    if round(det(U)) == -1
        U = U*d;
    end
    if round(det(V)) == -1
        V = V*d;
    end
    r_z1 = [0, 1, 0; -1 , 0, 0;0 , 0 , 1]; 
    r_z2 = [0, -1, 0; +1 , 0, 0;0 , 0 , 1]; 
    %if round(det(U))==double(1) && det(V)==double(1)
        R1 = U * r_z1' * V';
        R2 = U * r_z2' * V';
        T1d = U * r_z1 * S * U';
        T2d = U * r_z2 * S * U';
        T1=[T1d(3,2);T1d(1,3);T1d(2,1)];
        T2=[T2d(3,2);T2d(1,3);T2d(2,1)];
    %end
    
    
end