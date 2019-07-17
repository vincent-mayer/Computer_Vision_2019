function DispMap=Disparity_blocks(right, left, BlockSize, halfTemplateSize, disparityRange, do_plot)

fprintf('   Performing basic block matching...\n');

%% Allocate Space
DispMap = zeros(size(left), 'single');
DispMap1 = DispMap;
diff_Block = zeros(ceil(disparityRange/2),1);

%% Get the image dimensions.
[imgHeight, imgWidth] = size(left);

%% Add zero frame depending on TemplateSize
TemplateSize = halfTemplateSize*2 + 1; % Size in blocks
right_frame = zeros(imgHeight+2*halfTemplateSize*BlockSize, imgWidth+2*halfTemplateSize*BlockSize);
left_frame = right_frame;

%% Coordinate Origin for picutre without frame
frame_size_pxl = BlockSize*halfTemplateSize;
x_no_frame = 1+frame_size_pxl;
y_no_frame = 1+frame_size_pxl;
right_frame(y_no_frame:y_no_frame+imgHeight-1,x_no_frame:x_no_frame+imgWidth-1) = double(right);
left_frame(y_no_frame:y_no_frame+imgHeight-1,x_no_frame:x_no_frame+imgWidth-1) = double(left);

for m = y_no_frame:BlockSize:ceil(imgHeight) % Run through half of the image rows
    
    for n = x_no_frame:BlockSize:imgWidth % Run through half of the image cols
        template = right_frame(m-frame_size_pxl:m+frame_size_pxl+1, n-frame_size_pxl:n+frame_size_pxl+1);
        index_diff_Block = 1;
        %% If not too far to the right
        if n < imgWidth-disparityRange
            for i = n:BlockSize:n+disparityRange
                compare_Block = left_frame(m-frame_size_pxl:m+frame_size_pxl+1,i-frame_size_pxl:i+frame_size_pxl+1);
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
                compare_Block = left_frame(m-frame_size_pxl:m+frame_size_pxl+1,i-frame_size_pxl:i+frame_size_pxl+1);
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
        DispMap(m-frame_size_pxl:m-frame_size_pxl+BlockSize,n-frame_size_pxl:n-frame_size_pxl+BlockSize)=d;
        if bestMatchIndex == 1 || bestMatchIndex+1 > size(diff_Block,1)
            DispMap1(m-frame_size_pxl:m-frame_size_pxl+BlockSize,n-frame_size_pxl:n-frame_size_pxl+BlockSize) = d;
        else
            C1 = diff_Block(bestMatchIndex - 1);
            C2 = diff_Block(bestMatchIndex);
            C3 = diff_Block(bestMatchIndex + 1);

            % Adjust the disparity by some fraction.
            % We're estimating the subpixel location of the true best match.
            DispMap1(m-frame_size_pxl:m-frame_size_pxl+BlockSize,n-frame_size_pxl:n-frame_size_pxl+BlockSize) = d - (0.5 * (C3 - C1) / (C1 - (2*C2) + C3));
        end 
    end
        
      fprintf('   Image row %d / %d (%.0f%%)\n', m, imgHeight, (m / imgHeight) * 100);
       
end
if do_plot
    figure
    imagesc(DispMap)
end
end