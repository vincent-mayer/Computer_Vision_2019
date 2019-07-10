function [Fx, Fy] = sobel_xy(input_image)
    % In dieser Funktion soll das Sobel-Filter implementiert werden, welches
    % ein Graustufenbild einliest und den Bildgradienten in x- sowie in
    % y-Richtung zurueckgibt.
    F = double(input_image);                    % Double Datentyp wichtig
    [row col] = size(F);
    Gx = [-1 0 1; -2 0 2; -1 0 1];            % Sobel Filter für x Werte
    Gy = Gx';                                   % Sobel Filter für y Werte
   
    for x=2:1:row-1
        for y=2:1:col-1
            Fx(x,y) =   Gx(1)*F(x-1,y-1) + Gx(2)*F(x-1,y) + Gx(3)*F(x-1,y+1) +... 
                        Gx(4)*F(x,y-1) + Gx(5)*F(x,y) + Gx(6)*F(x,y+1) +... 
                        Gx(7)*F(x+1,y-1) + Gx(8)*F(x+1,y) + Gx(9)*F(x+1,y+1); 
            Fy(x,y) =   Gy(1)*F(x-1,y-1) + Gy(2)*F(x-1,y) + Gy(3)*F(x-1,y+1) +... 
                        Gy(4)*F(x,y-1) + Gy(5)*F(x,y) + Gy(6)*F(x,y+1) +... 
                        Gy(7)*F(x+1,y-1) + Gy(8)*F(x+1,y) + Gy(9)*F(x+1,y+1); 
        end
    end
    Fx(row,col) = Fx(row-1,col-1);
    Fy(row,col) = Fy(row-1,col-1);
end