function [T ,R, D] = disparity_map(selpath)
% Bilder laden und in Grauwertbild konvertieren.
[K, K1, Image1, Image2, baseline, v_min, v_max] = load_path(selpath);

IGray1 = rgb_to_gray(Image1);
IGray2 = rgb_to_gray(Image2);

% Bild Größe bestimmen
[img_height img_width] = size(IGray1);

%Parameter für Algo bestimmen
if img_height>1000
    BlockSize = 2;
    Template=6;
else
    BlockSize = 1;
    Template=4;
end
if ~exist('NCC_on', 'var')
    NCC_on = 1;
end
if ~exist('median_filter_on', 'var')
    median_filter_on = 0;
end

% Disparity Map ï¿½ber Block Matching Algorithmus berechnen.

[T ,R, D] = main(IGray1 , IGray2, K, BlockSize, Template, baseline, median_filter_on, ~NCC_on, v_min, v_max);

end

