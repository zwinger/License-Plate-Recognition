function normalizedImg = normalizedRGBImg(img)
%Return the img in normalized RGB color space
[height, width] = size(img(:, :, 1));
normalizedImg = double(img);

%Separate the RGB planes
img_r = double(img(:, :, 1));
img_g = double(img(:, :, 2));
img_b = double(img(:, :, 3));

%Convert each pixel to normalized RGB
for row = 1 : height
    for col = 1 : width
        %Get the RGB colors of the current img pixel
        r = img_r(row, col);
        g = img_g(row, col);
        b = img_b(row, col);
        sum = r + g + b;
        if sum == 0
            img_r(row, col) = 0;
            img_g(row, col) = 0;
            img_b(row, col) = 0;
        else
            img_r(row, col) = r / sum;
            img_g(row, col) = g / sum;
            img_b(row, col) = b / sum;
        end
    end
end

%Recombine the 3 color channels
normalizedImg(:, :, 1) = img_r;  
normalizedImg(:, :, 2) = img_g;
normalizedImg(:, :, 3) = img_b;
end

