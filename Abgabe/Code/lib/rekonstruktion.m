function [T, R, lambda, P1] = rekonstruktion(T1, T2, R1, R2, Korrespondenzen, K)
    % Diese Funktion schaetzt die Tiefeninformationen und bestimmt somit die korrekte
    % euklidische Bewegung R und T. Zusaetzlich gibt sie die Weltkoordinaten der Bildpunkte
    % bezueglich Bild 1 zurueck und deren Tiefeninformationen.
    
    %% Vorbereitung aus Aufgabe 4.2
    T_cell = {T1, T2, T1, T2};
    R_cell = {R1, R1, R2, R2};
    x1 = Korrespondenzen(1:2,:);
    x1(3,:) = 1;
    x2 = Korrespondenzen(3:4,:);
    x2(3,:) = 1;
    x1 = inv(K) * x1;
    x2 = inv(K) * x2;
    matrix = zeros(size(x1,2),2);
    %% R, T und lambda aus Aufgabe 4.3
    
    for i=1:4
       M1 = zeros(size(x1,2)*3,size(x1,2)+1);
       M2 = zeros(size(x1,2)*3,size(x1,2)+1);
       for j=1:size(x1,2)
           M1(3*j-2:3*j,j) = dach(x2(:,j))*R_cell{i}*x1(:,j);
           M1(3*j-2:3*j,end) = dach(x2(:,j))*T_cell{i};
           M2(3*j-2:3*j,j) = dach(x1(:,j))*R_cell{i}'*x2(:,j);
           M2(3*j-2:3*j,end) = -dach(x1(:,j))*R_cell{i}'*T_cell{i};
       end
       [U1, S1, V1] = svd(M1);
       [U2, S2, V2] = svd(M2);
       d1 = V1(:,end);
       d2 = V2(:,end);
       d1 = d1/d1(end);
       d2 = d2/d2(end);
       d_cell{i} = [d1(1:end-1),d2(1:end-1)];
    end
    sum_d(1) = sum(sum(d_cell{1}));
    sum_d(2) = sum(sum(d_cell{2}));
    sum_d(3) = sum(sum(d_cell{3}));
    sum_d(4) = sum(sum(d_cell{4}));
    maximum = max(sum_d);
    index_max = find(sum_d==maximum);
    T = T_cell{index_max};
    R = R_cell{index_max};
    lambda = d_cell{index_max};
    %%
    P1=zeros(size(x1));
    for i=1:1:size(x1,2)
        P1(:,i)=lambda(i,1)*x1(:,i);
    end

end