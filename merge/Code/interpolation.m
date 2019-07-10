function [vq] = interpolation(x,y,z,row,colum,Image,string)
    z1=( z - min(min(z)) ) ./ ( max(max(z)) - min(min(z)))*255;     
    z = (-1*z1+max(z1));
    
    Matrix(1,:) = x;
    Matrix(2,:) = y;
    Matrix1 = ones(2,size(x,2));
    Matrix2 = ones(2,size(x,2));
    Matrix3 = ones(2,size(x,2));
    Matrix4 = ones(2,size(x,2));
    Matrix2(1,:) = row;
    Matrix2(2,:) = colum;
    Matrix3(1,:) = 1;
    Matrix3(2,:) = colum;
    Matrix4(1,:) = row;
    Matrix4(2,:) = 1;
    
    dist1 = (Matrix1-Matrix).^2;
    dist1 = sqrt(dist1(1,:) + dist1(2,:));
    dist2 = (Matrix2-Matrix).^2;
    dist2 = sqrt(dist2(1,:) + dist2(2,:));
    dist3 = (Matrix3-Matrix).^2;
    dist3 = sqrt(dist3(1,:) + dist3(2,:));
    dist4 = (Matrix4-Matrix).^2;
    dist4 = sqrt(dist4(1,:) + dist4(2,:));
    min_dis1 = min(dist1);
    min_dis2 = min(dist2);
    min_dis3 = min(dist3);
    min_dis4 = min(dist4);
    x_1 = find(dist1==min_dis1);
    x_2 = find(dist2==min_dis2);
    x_3 = find(dist3==min_dis3);
    x_4 = find(dist4==min_dis4);
    b = size(x,2);
    x_new = zeros(1,b+4);
    y_new = zeros(1,b+4);
    z_new = zeros(1,b+4);
    x_new(1) = 1;
    y_new(1) = 1;
    x_new(2) = colum;
    y_new(2) = row;
    x_new(3) = 1;
    y_new(3) = row;
    x_new(4) = colum;
    y_new(4) = 1;
    x_new(5:end) = x(1,:);
    y_new(5:end) = y(1,:);
    z_new(1:4) = [z(x_1) , z(x_2),z(x_3), z(x_4)];
    z_new(5:end) = z(:);
    
    [xq,yq] = meshgrid(1:1:colum, 1:1:row);
    vq = griddata(x_new,y_new,z_new,xq,yq,string);
    mesh(xq,yq,vq)
    hold on
    plot3(x_new,y_new,z_new,'o')
    imshow(Image);
    
    figure 
    imagesc(vq)
    colormap gray 
end

