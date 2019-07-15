function sd = sampson_dist(F, x1_pixel, x2_pixel)
    % Diese Funktion berechnet die Sampson Distanz basierend auf der
    % Fundamentalmatrix F
    
    e3_dach = [0 -1 0; 1 0 0; 0 0 0];
    sd = diag((x2_pixel'*F*x1_pixel))'.^2./(vecnorm(e3_dach*F*x1_pixel).^2+vecnorm(x2_pixel'*F*e3_dach,2,2)'.^2);
end