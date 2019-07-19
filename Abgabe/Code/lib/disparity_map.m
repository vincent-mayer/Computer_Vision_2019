	%% Function that returns disparity Disparity Maps
% Output :  DispMap (Disparity without sub pixel estimation)
%           DispMap1 (Disparity with sub pixel estimation)
%           DispMap_norm ( Disparity normalized to 0-255).
% Input:    left : left image
%           right : right image
%           BlockSize : Size of the blocks image is partitioned in
%           halfTemplateSize : 2*halfTemplateSize+1 is the number of blocks
%           in the template used for matching
%           disparity Range : search space to the right in number of pixels
%           SAD : if 1, use SAD, if 0 use NCC

function [DispMap, DispMap1, DispMap_norm]=disparity_map(left, right, BlockSize, halfTemplateSize, disparityRange, d_min, do_plot,SAD)
    %% Compute left disparity map

    fprintf('Disparity map calculation started\n');
    %% Allocate Space
    DispMap = zeros(size(left), 'single');
    DispMap1 = DispMap;
    diff_Block = zeros(ceil(disparityRange/BlockSize),1);
    %% Get the image dimensions.
    [imgHeight, imgWidth] = size(left);
    %% Add zero frame depending on TemplateSize
    right_frame = zeros(imgHeight+2*halfTemplateSize*BlockSize, imgWidth+2*halfTemplateSize*BlockSize);
    left_frame = right_frame;
    %% Coordinate Origin for picutre without frame
    frame_size_pxl = BlockSize*halfTemplateSize;
    x_no_frame = 1+frame_size_pxl;
    y_no_frame = 1+frame_size_pxl;
    %% Convert to double and insert original pics in the array with zero frame
    right_frame(y_no_frame:y_no_frame+imgHeight-1,x_no_frame:x_no_frame+imgWidth-1) = double(right);
    left_frame(y_no_frame:y_no_frame+imgHeight-1,x_no_frame:x_no_frame+imgWidth-1) = double(left);
    %% Compute N for NCC
    N = BlockSize*((2*halfTemplateSize+1))^2;
    for m = y_no_frame:BlockSize:ceil(y_no_frame+imgHeight-1) % Run through imgHeights/Blocksize rows

        for n = x_no_frame:BlockSize:x_no_frame+(imgWidth-BlockSize) % Run through imgWidth/Blocksize cols
            template = right_frame(m-frame_size_pxl:m+frame_size_pxl+BlockSize-1, n-frame_size_pxl:n+frame_size_pxl+BlockSize-1);
            index_diff_Block = 1;
            %% If SAD selected
            if SAD
                %% If not too far to the right
                if n < imgWidth-disparityRange
                    for i = n:BlockSize:n+disparityRange
                        compare_Block = left_frame(m-frame_size_pxl:m+frame_size_pxl+BlockSize-1,i-frame_size_pxl:i+frame_size_pxl+BlockSize-1);
                        if sum(compare_Block(:,1)) == 0
                            diff_Block(index_diff_Block,1) = inf;
                        else
                            diff_Block(index_diff_Block,1) = sum(sum(abs(template-compare_Block)));
                        end
                        index_diff_Block = index_diff_Block+1;
                    end
                else
                %% If too far to the right, make search space smaller
                    for i = n:BlockSize:imgWidth
                        compare_Block = left_frame(m-frame_size_pxl:m+frame_size_pxl+BlockSize-1,i-frame_size_pxl:i+frame_size_pxl+BlockSize-1);
                        if sum(compare_Block(:,1)) == 0
                            diff_Block(index_diff_Block,1) = inf;
                        else
                            diff_Block(index_diff_Block,1) = sum(sum(abs(template-compare_Block)));
                        end
                        index_diff_Block = index_diff_Block+1;
                    end
                end
                [~,sortedIndexes] = sort(diff_Block);
                bestMatchIndex = sortedIndexes(1,1);
                d = bestMatchIndex*BlockSize -1;
                DispMap(m-frame_size_pxl:m-frame_size_pxl+BlockSize-1,n-frame_size_pxl:n-frame_size_pxl+BlockSize-1)=d;
                if bestMatchIndex == 1 || bestMatchIndex+1 > size(diff_Block,1)
                    DispMap1(m-frame_size_pxl:m-frame_size_pxl+BlockSize-1,n-frame_size_pxl:n-frame_size_pxl+BlockSize-1) = d;
                else
                    C1 = diff_Block(bestMatchIndex - 1);
                    C2 = diff_Block(bestMatchIndex);
                    C3 = diff_Block(bestMatchIndex + 1);
                    %% Subpixel Estimation from Matlab Example
                    DispMap1(m-frame_size_pxl:m-frame_size_pxl+BlockSize,n-frame_size_pxl:n-frame_size_pxl+BlockSize) = d - (0.5 * (C3 - C1) / (C1 - (2*C2) + C3));
                end 
            %% If NCC selected
            else
                 if n < imgWidth-disparityRange
                    for i = n:BlockSize:n+disparityRange
                        compare_Block = left_frame(m-frame_size_pxl:m+frame_size_pxl+BlockSize-1,i-frame_size_pxl:i+frame_size_pxl+BlockSize-1);
                        %% Generate Matrices for W and V
                        W = (template - mean(template,'all'))/std(template,0,'all');
                        V = (compare_Block - mean(compare_Block,'all'))/std(compare_Block,0,'all');
                        %% If compare block still too far to the left
                        if sum(compare_Block(:,1)) == 0
                            diff_Block(index_diff_Block,1) = 0;
                        else
                            diff_Block(index_diff_Block,1) = 1/(N-1) * trace(W'*V);
                        end
                        index_diff_Block = index_diff_Block+1;
                    end
                else
                %% If n bigger than imgwidth-disparity(too far to the right), make search space smaller, max disparity can only be img_width - n
                    for i = n:BlockSize:imgWidth
                        compare_Block = left_frame(m-frame_size_pxl:m+frame_size_pxl+BlockSize-1,i-frame_size_pxl:i+frame_size_pxl+BlockSize-1);
                        %% Generate Matrices for W and V
                        W = (template - mean(template,'all'))/std(template,0,'all');
                        V = (compare_Block - mean(compare_Block,'all'))/std(compare_Block,0,'all');
                        %% If compare block still too far to the left
                        if sum(compare_Block(:,1)) == 0
                            diff_Block(index_diff_Block,1) = 0;
                        else
                            diff_Block(index_diff_Block,1) = 1/(N-1) * trace(W'*V);
                        end
                        index_diff_Block = index_diff_Block+1;
                    end
                end
                
                [~,sortedIndexes] = sort(diff_Block,'descend');
                bestMatchIndex = sortedIndexes(1,1);
                d = (bestMatchIndex-1)*BlockSize;
                if d > d_min
                    DispMap(m-frame_size_pxl:m-frame_size_pxl+BlockSize-1,n-frame_size_pxl:n-frame_size_pxl+BlockSize-1)=d;
                else
                    second_best_disp = sortedIndexes(sortedIndexes > d_min);
                    DispMap(m-frame_size_pxl:m-frame_size_pxl+BlockSize-1,n-frame_size_pxl:n-frame_size_pxl+BlockSize-1)=second_best_disp(1);
                end
                if bestMatchIndex == 1 || bestMatchIndex+1 > size(diff_Block,1)
                    DispMap1(m-frame_size_pxl:m-frame_size_pxl+BlockSize-1,n-frame_size_pxl:n-frame_size_pxl+BlockSize-1) = d;
                else
%                     C1 = diff_Block(bestMatchIndex - 1);
%                     C2 = diff_Block(bestMatchIndex);
%                     C3 = diff_Block(bestMatchIndex + 1);

                    C1 = sortedIndexes(sortedIndexes<d);
                    C3 = sortedIndexes(sortedIndexes>d);                   
                    if size(C1,1) > 0 && size(C3,1) > 0
                        C1 = C1(1);
                        C2 = d;
                        C3 = C3(1);
                        %DispMap1(m-frame_size_pxl:m-frame_size_pxl+BlockSize-1,n-frame_size_pxl:n-frame_size_pxl+BlockSize-1) = d - (0.5 * (C3 - C1) / (C1 - (2*C2) + C3));
                        DispMap1(m-frame_size_pxl:m-frame_size_pxl+BlockSize-1,n-frame_size_pxl:n-frame_size_pxl+BlockSize-1) = (C1+C2+C3)/3;
                    else
                        DispMap1(m-frame_size_pxl:m-frame_size_pxl+BlockSize-1,n-frame_size_pxl:n-frame_size_pxl+BlockSize-1) = d;
                    end
                    %% Subpixel Estimation from Matlab Example
                    
                    
                end
            end
        end

          fprintf('  Image row %d / %d (%.0f%%)\n', m-y_no_frame, imgHeight, ((m-y_no_frame) / imgHeight) * 100);

    end
    if do_plot
        figure
        imagesc(DispMap)
        DispMap_filt = medfilt2(DispMap,[20 30]);
        figure
        imagesc(DispMap1)
        figure
        imagesc(DispMap_filt)
        DispMap_norm = normalize_var(DispMap,0,255);
        figure
        imagesc(DispMap_norm)
    end

end
