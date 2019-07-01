function [Fx, Fy] = sobel_xy(input_image)
    % In dieser Funktion soll das Sobel-Filter implementiert werden, welches
    % ein Graustufenbild einliest und den Bildgradienten in x- sowie in
    % y-Richtung zurueckgibt.
    if ndims(input_image)==2 
        a=size(input_image);
        Fx=zeros(a(1),a(2),'double');
        Fy=zeros(a(1),a(2),'double');
        horFltr=[1,0,-1;2,0,-2;1,0,-1];
        verFltr=[1,2,1;0,0,0;-1,-2,-1];
        Fx=conv2(input_image,horFltr,'same');
        Fy=conv2(input_image,verFltr,'same');
    else
        error('Das uebergebene Bild muss in Graustufen vorliegen');
    end
end