%% Bilder laden
selpath = uigetdir(path);
[K K1 Image1 Image2,baseline] = load_path(selpath);

row = size(Image1,1);
colum =  size(Image1,2);

IGray1 = rgb_to_gray(Image1);
IGray2 = rgb_to_gray(Image2);

%% Block Matching
DisMap=Disparity_blocks(IGray1, IGray2, 2, 2, 250,'true');

[ T , R , DisMapFeature ] = DispfromFeatures_TR(IGray1 , IGray2, K, baseline);
%% Übereinander legen
for x=1:row
    for y=1:colum
        m_new(x,y) = (0.5*vq(x,y) + 0.5*DisMap(x,y)) / 2;
    end
end
%% Display
%@Theo ToDo: export to "Results" folder
figure
    imagesc(DisMap);
    colormap gray 
figure
    imagesc(vq);
    colormap gray 
figure
    imagesc(m_new);
    colormap gray 
%% Median Filter
N = 10;
im_pad = padarray(m_new, [floor(N/2) floor(N/2)]);
im_col = im2col(im_pad, [N N], 'sliding');
sorted_cols = sort(im_col, 1, 'ascend');
med_vector = sorted_cols(floor(N*N/2) + 1, :);
IGray1 = col2im(med_vector, [N N], size(im_pad), 'sliding');
%%
figure
    imagesc(IGray1)
    colormap gray 

