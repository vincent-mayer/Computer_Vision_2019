function gray_image = rgb_to_gray(input_image)
    % Diese Funktion soll ein RGB-Bild in ein Graustufenbild umwandeln. Falls
    % das Bild bereits in Graustufen vorliegt, soll es direkt zurueckgegeben werden.
    dim = ndims(input_image);
    if dim == 2
        gray_image = input_image;
        return ;
    end
        input_image = double(input_image);
        R = input_image(:,:,1);
        G = input_image(:,:,2);
        B = input_image(:,:,3);
        gray_image = (0.2999 * R) + (0.587 * G) + (0.114 * B);
        gray_image = uint8(gray_image);
end