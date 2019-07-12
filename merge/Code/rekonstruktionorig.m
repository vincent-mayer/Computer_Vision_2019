function [T, R, d_cell, x1, x2, P1] = rekonstruktion(T1, T2, R1, R2, Korrespondenzen, K)
    %% Preparation
    T_cell={T1,T2,T1,T2};
    R_cell={R1,R1,R2,R2};
    vones = ones(1,size(Korrespondenzen,2));
    x1_ = [Korrespondenzen(1,:); Korrespondenzen(2,:);vones];
    x2_ = [Korrespondenzen(3,:); Korrespondenzen(4,:);vones];
    x1 = K^-1*x1_;
    x2 = K^-1*x2_;
    d_cell = {zeros(size(Korrespondenzen,2),2),zeros(size(Korrespondenzen,2),2),zeros(size(Korrespondenzen,2),2),zeros(size(Korrespondenzen,2),2)};
        %% Rekonstruktion
    for j=1:4
        M1=zeros(size(Korrespondenzen,2)*3,size(Korrespondenzen,2)+1);
        M2=zeros(size(Korrespondenzen,2)*3,size(Korrespondenzen,2)+1);
        R = R_cell{j};
        T = T_cell{j};
        for i=1:size(Korrespondenzen,2)
            M1((3*i-2):3*i,i) = dach(x2(:,i)) *R*x1(:,i);
            M1((3*i-2):3*i,end) = dach(x2(:,i)) *T; 
            M2((3*i-2):3*i,i) = dach(x1(:,i)) * R' * x2(:,i);
            M2((3*i-2):3*i,end) = -dach(x1(:,i))*R' * T; 
        end
        [u,s,v]=svd(M1);
        d1=v(:,end);
        [u,s,v]=svd(M2);
        d2=v(:,end);
        d1=d1/d1(end,end);
        d2=d2/d2(end,end);
        d_cell{j}=[d1(1:end-1),d2(1:end-1)];       
    end
    
    a=zeros(4,1);
    a(1)=size(d_cell{1}(d_cell{1}>=0),1);
    a(2)=size(d_cell{2}(d_cell{2}>=0),1);
    a(3)=size(d_cell{3}(d_cell{3}>=0),1);
    a(4)=size(d_cell{4}(d_cell{4}>=0),1);
    [~,index]=max(a(:));
    T=T_cell{index};
    R=R_cell{index};
    lambda=d_cell{index};
  
    for i=1:1:size(x1,2)
        P1(:,i)=lambda(i,1)*x1(:,i);
    end
end