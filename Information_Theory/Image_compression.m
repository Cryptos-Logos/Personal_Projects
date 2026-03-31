clear; clc; close all;

img_rgb = imread('itc_image_test.jpg'); 
[orig_rows, orig_cols, ~] = size(img_rgb);
img_ycbcr = rgb2ycbcr(img_rgb);
Y_orig = double(img_ycbcr(:,:,1));
Cb_orig = double(img_ycbcr(:,:,2));
Cr_orig = double(img_ycbcr(:,:,3));

Cb_sub_orig = imresize(Cb_orig, 0.5, 'bilinear');
Cr_sub_orig = imresize(Cr_orig, 0.5, 'bilinear');

% Block sizes to test
block_sizes = [4, 8, 16];
Q_base = [17 18 24 47 99 99 99 99;
          18 21 26 66 99 99 99 99;
          24 26 56 99 99 99 99 99;
          47 66 99 99 99 99 99 99; 
          99 99 99 99 99 99 99 99;
          99 99 99 99 99 99 99 99;
          99 99 99 99 99 99 99 99;
          99 99 99 99 99 99 99 99];

figure('Name', 'Reconstruction Comparison');

for b = 1:length(block_sizes)
    N = block_sizes(b);
    
    % Resize Quantization matrix for current N
    Qc = imresize(Q_base, [N, N], 'bilinear');
    Qc(Qc < 1) = 1; 

    % Pad dimensions to be multiples of N
    rows = ceil(orig_rows/N)*N;
    cols = ceil(orig_cols/N)*N;
    rows_c = ceil((orig_rows/2)/N)*N;
    cols_c = ceil((orig_cols/2)/N)*N;
    
    Y = padarray(Y_orig, [rows-orig_rows, cols-orig_cols], 'post');
    Cb_sub = padarray(Cb_sub_orig, [rows_c-size(Cb_sub_orig,1), cols_c-size(Cb_sub_orig,2)], 'post');
    Cr_sub = padarray(Cr_sub_orig, [rows_c-size(Cr_sub_orig,1), cols_c-size(Cr_sub_orig,2)], 'post');

    num_blocks_y = (rows/N) * (cols/N);
    num_blocks_c = (rows_c/N) * (cols_c/N);
    total_elements = (num_blocks_y + 2*num_blocks_c) * N^2;
    bitstream_int16 = zeros(1, total_elements, 'int16');
    write_idx = 1;
    
    zz_ind = zigzag_indices(N);

    % Process Y 
    for r = 1 : N : rows - N + 1
        for c = 1 : N : cols - N + 1
            block = Y(r:r+N-1, c:c+N-1);
            q_block = round(dct2(block) ./ Qc);
            bitstream_int16(write_idx:write_idx+(N^2-1)) = int16(q_block(zz_ind));
            write_idx = write_idx + N^2;
        end
    end

    % Process Cb and Cr
    for r = 1 : N : rows_c - N + 1
        for c = 1 : N : cols_c - N + 1
            q_cb = round(dct2(Cb_sub(r:r+N-1, c:c+N-1)) ./ Qc);
            bitstream_int16(write_idx:write_idx+(N^2-1)) = int16(q_cb(zz_ind));
            write_idx = write_idx + N^2;
            
            q_cr = round(dct2(Cr_sub(r:r+N-1, c:c+N-1)) ./ Qc);
            bitstream_int16(write_idx:write_idx+(N^2-1)) = int16(q_cr(zz_ind));
            write_idx = write_idx + N^2;
        end
    end

    save('lunar_data.mat', 'bitstream_int16');
    gzip('lunar_data.mat');
    zipped_info = dir('lunar_data.mat.gz');
    final_cr = (numel(img_rgb)) / zipped_info.bytes;
    
    fprintf('N=%d | Ratio: %.2f:1 | Size: %.2f KB\n', N, final_cr, zipped_info.bytes/1024);

    % Decoding
    gunzip('lunar_data.mat.gz');
    received_data = load('lunar_data.mat');
    bitstream_in = double(received_data.bitstream_int16); 
    read_idx = 1;
    
    Y_rec = zeros(rows, cols);
    Cb_rec = zeros(rows_c, cols_c);
    Cr_rec = zeros(rows_c, cols_c);

    for r = 1 : N : rows - N + 1
        for c = 1 : N : cols - N + 1
            vec = bitstream_in(read_idx:read_idx+(N^2-1));
            temp_block = zeros(N,N);
            temp_block(zz_ind) = vec;
            Y_rec(r:r+N-1, c:c+N-1) = idct2(temp_block' .* Qc);
            read_idx = read_idx + N^2;
        end
    end

    for r = 1 : N : rows_c - N + 1
        for c = 1 : N : cols_c - N + 1
            vec_cb = bitstream_in(read_idx:read_idx+(N^2-1));
            t_cb = zeros(N,N); t_cb(zz_ind) = vec_cb;
            Cb_rec(r:r+N-1, c:c+N-1) = idct2(t_cb' .* Qc);
            read_idx = read_idx + N^2;
            
            vec_cr = bitstream_in(read_idx:read_idx+(N^2-1));
            t_cr = zeros(N,N); t_cr(zz_ind) = vec_cr;
            Cr_rec(r:r+N-1, c:c+N-1) = idct2(t_cr' .* Qc);
            read_idx = read_idx + N^2;
        end
    end

    % Remove padding and restore
    Y_rec = Y_rec(1:orig_rows, 1:orig_cols);
    Cb_up = imresize(Cb_rec(1:rows_c, 1:cols_c), [orig_rows, orig_cols], 'bilinear');
    Cr_up = imresize(Cr_rec(1:rows_c, 1:cols_c), [orig_rows, orig_cols], 'bilinear');
    
    img_final_rgb = ycbcr2rgb(uint8(cat(3, Y_rec, Cb_up, Cr_up)));
    
    subplot(1, length(block_sizes), b);
    imshow(img_final_rgb);
    title(['N = ', num2str(N), ' (CR ', num2str(final_cr, '%.1f'), ')']);
end

function ind = zigzag_indices(N)
    [row, col] = meshgrid(1:N, 1:N);
    row = row'; col = col';
    s = row + col;
    [~, ind] = sortrows([s(:), mod(s(:), 2) .* row(:) + mod(s(:)+1, 2) .* col(:)]);
end
