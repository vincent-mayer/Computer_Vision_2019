function [IGray_filtered] = med_filter(IGray, N1, N2)
    % med_filter Wende Median Filter an.
    %   [Image] = med_filter(IGray)
    %   Diese Funktion wendet einen Median Filter der Filterlänge [N1 N2] auf das
    %   Grauwertbild IGray an und liefert das Ergebnis zurück.
    %
    % Erstellt: Juli 2019
    N1_h = floor(N1/2);
    N2_h = floor(N2/2);
    IGray_padded = zeros(2*N1_h+size(IGray,1),2*N2_h+size(IGray,2));
    IGray_padded((N1_h+1):(end-N1_h),(N2_h+1):(end-N2_h)) = IGray;
    IGray_filtered = zeros(size(IGray_padded,1), size(IGray_padded,2));
    for i=(N1_h+1):(size(IGray_padded,1)-(N1_h+1))
        for j=(N2_h+1):(size(IGray_padded,2)-(N2_h+1))
            values = IGray_padded((i-N1_h):(i+N1_h),(j-N2_h):(j+N2_h));
            values = sort(values(:));
            IGray_filtered(i,j) = values(ceil(length(values)/2));
        end
    end
    IGray_filtered = IGray_filtered((N1_h+1):(end-N1_h),(N2_h+1):(end-N2_h));
    IGray_filtered = cast(IGray_filtered, class(IGray));
end