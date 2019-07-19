function [T,R,DispRangeMax, DispRangeMin] = DispfromFeatures_TR(IGray1,IGray2, K, baseline)
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


Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale1,Merkmale2,'window_length',25,'min_corr', 0.9);
[Korrespondenzen_robust anzahl] = F_ransac(Korrespondenzen, 'tolerance', 0.04);
E = achtpunktalgorithmus(Korrespondenzen_robust, K);
[T1, R1, T2, R2] = TR_aus_E(E);
[T, R, lambda, P1] = rekonstruktion(T1, T2, R1, R2, Korrespondenzen_robust, K);

T = (T - min(min(T)) ./ ( max(max(T)) - min(min(T)))*(baseline*10^-3));     

% Berechne die minimale und maximale Disparity Range anhand der Entfernung
% der jeweiligen Korrespondenzpunkpaaren
    Matrix(1,:) = Korrespondenzen_robust(1,:);
    Matrix(2,:) = Korrespondenzen_robust(2,:);
    Matrix1(1,:) = Korrespondenzen_robust(3,:);
    Matrix1(2,:) = Korrespondenzen_robust(4,:);
    dist = (Matrix-Matrix1).^2;
    dist = sqrt(dist(1,:) + dist(2,:));
    DispRangeMin = min(dist);
    DispRangeMax = max(dist);
%lambda = lambda(:,1);

%DispMapFeature = interpolation(Korrespondenzen_robust(1,:),Korrespondenzen_robust(2,:), lambda, row, colum, IGray1,'natural');
%DispMapFeature(isnan(DispMapFeature))=0;


end

