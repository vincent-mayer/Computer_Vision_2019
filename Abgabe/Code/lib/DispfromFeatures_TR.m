function [T,R,DispMapFeature] = DispfromFeatures_TR(IGray1,IGray2, K, baseline)
% Calculate T ,R and Disparity Map from features
%   Input Parameters: left, right picture from one scene, K matrix, baseline.
%   Output Parameters: Disparity Map from features, T (normalized to
%   baseline), R
row = size(IGray1,1);
colum =  size(IGray1,2);

%  IGray1=imresize(IGray1,[row/8,colum/8]);
%  IGray2=imresize(IGray2,[row/8,colum/8]);

Merkmale1 = harris_detektor(IGray1,'segment_length',3,'k',0.04,'min_dist',4,'N',40,'do_plot',false);
Merkmale2 = harris_detektor(IGray2,'segment_length',3,'k',0.04,'min_dist',4,'N',40,'do_plot',false);
Merkmale3 = harris_detektor(IGray1,'segment_length',3,'k',0.04,'min_dist',colum-4,'N',40,'do_plot',false);
Merkmale4 = harris_detektor(IGray2,'segment_length',3,'k',0.04,'min_dist',colum-4,'N',40,'do_plot',false);

Merkmale5 = zeros(2, size(Merkmale1, 2) + size(Merkmale3, 2));
Merkmale6 = zeros(2, size(Merkmale2, 2) + size(Merkmale4, 2));
Merkmale5(:, 1:size(Merkmale1, 2)) = Merkmale1(:, 1:end);
Merkmale5(:, size(Merkmale1, 2)+1:end) = Merkmale3(:, 1:end);
Merkmale6(:, 1:size(Merkmale2,2)) = Merkmale2(:, 1:end);
Merkmale6(:, size(Merkmale2,2)+1:end) = Merkmale4(:, 1:end);

Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale5,Merkmale6,'window_length',25,'min_corr', 0.9)
[Korrespondenzen_robust anzahl] = F_ransac(Korrespondenzen, 'tolerance', 0.04);
E = achtpunktalgorithmus(Korrespondenzen_robust, K);
[T1, R1, T2, R2] = TR_aus_E(E);
[T, R, lambda, P1] = rekonstruktion(T1, T2, R1, R2, Korrespondenzen_robust, K);

T = (T - min(min(T)) ./ ( max(max(T)) - min(min(T)))*(baseline*10^-3));     

lambda = lambda(:,1);

DispMapFeature = interpolation(Korrespondenzen_robust(1,:),Korrespondenzen_robust(2,:), lambda, row, colum, IGray1,'natural');
DispMapFeature(isnan(DispMapFeature))=0;


end

