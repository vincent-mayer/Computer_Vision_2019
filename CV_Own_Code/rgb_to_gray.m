function gray_image = rgb_to_gray(input_image)
    % Diese Funktion soll ein RGB-Bild in ein Graustufenbild umwandeln. Falls
    % das Bild bereits in Graustufen vorliegt, soll es direkt zurueckgegeben werden.
    a=size(input_image);
    if ndims(input_image)==3
        gray_image=zeros(a(1),a(2),'uint8');
        gray_image=uint8(double(input_image(:,:,1))*0.299+double(input_image(:,:,2))*0.587+double(input_image(:,:,3))*0.114);
    else
        gray_image=input_image;
    end
end