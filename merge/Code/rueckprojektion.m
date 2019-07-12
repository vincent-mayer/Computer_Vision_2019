function [repro_error, x2_repro] = rueckprojektion(Korrespondenzen, P1, Image2, T, R, K)
    % Diese Funktion berechnet den mittleren Rueckprojektionsfehler der 
    % Weltkooridnaten P1 aus Bild 1 im Cameraframe 2 und stellt die 
    % korrekten Merkmalskoordinaten sowie die rueckprojezierten grafisch dar.

    one_vec=ones(1,size(Korrespondenzen,2));
    x2=[Korrespondenzen(3:4,:);one_vec];
    P2=R*P1+T;
    x2_repro=K*(P2./P2(end,:));
    imshow(Image2);
    str_num=string(1:1:size(x2,2));
    hold on
    plot(x2_repro(1,:),x2_repro(2,:),'r*');
    text(x2_repro(1,:),x2_repro(2,:),str_num);
    plot(x2(1,:),x2(2,:),'g*');
    text(x2(1,:),x2(2,:),str_num);
    hold off
    repro_error=(1/size(x2,2))*sum(vecnorm((x2-x2_repro)));    

end