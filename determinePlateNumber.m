function plateNumber = determinePlateNumber(orgPlate)
%Find the characters of the license plate number and
%return the plate number

%Resize the cropped license plate to be a standard size
orgPlate = imresize(orgPlate, [300, 623]);

%Smooth the cropped license plate image
smoothedPlate = imfilter(orgPlate, fspecial('gaussian'));
%Convert the smoothed image into normalize RGB color space
plate = normalizedRGBImg(smoothedPlate);
%Display the normalized RGB license plate image
figure();
imshow(plate, []);

%Use 4 clusters for K-Means
k = 4;
[m,n]=size(plate(:,:,1));
%Reshape the input and run k-means, then reshape the output
X=reshape(plate, m*n, 3);
%Run kmeans
X_clustered = kmeans(double(X), k);
img_segmented = reshape(X_clustered, m, n);
%Display the segmented image
figure();
imshow(img_segmented, []);
%Convert the license plate image to grayscale
bwPlate = rgb2gray(plate);

numChar = 0;
c = [];
positions = [];
plateNumber = '';
%Search each cluster for connected components resembling a character
for j = 1 : k
    %Create the mask for the cluster pixels
    mask = (img_segmented == j);
    %Get the stats for the color planes of the image
    labeledImg = bwlabel(mask, 8);
    stats = regionprops(labeledImg, 'BoundingBox');

    %Determine which regions are most likely characters
    numRegions = size(stats, 1);
    for n = 1 : numRegions
        %Get the bounding box for the current region and compute its area
        %and aspect ratio
        bb = stats(n).BoundingBox;
        width = bb(3);
        height = bb(4);
        aspectRatio = width / height;
        area = width * height;

        %Heuristics for determining if the current region is a
        %character or not
        if (aspectRatio > 0.38 && aspectRatio < 0.7 && area > 4500 ...
            && area < 13000)
            %Find the best matching character in the set of templates
            char = matchCharacter(imcrop(mask, bb(1, :)));
            %Check if the potential character is an actual character
            if (strcmp(char, '') ~= 1)
                numChar = numChar + 1;
                %Save the predicted character
                c = vertcat(c, stats(n).BoundingBox);
                plateNumber = strcat(plateNumber, char);
                positions = vertcat(positions, [bb(1), bb(2) - 55]);
            end
            fprintf("Predicted Character: %s\n", char);
        end
    end
end

%Display the predicted license plate number
plateGuess = plate;
plateGuess = orgPlate;
if numChar > 0
    text_str = cell(numChar,1);
    for i= 1 : numChar
       text_str{i} = plateNumber(i);
    end
    plateGuess = insertText(orgPlate, positions, text_str, 'FontSize', 35, ...
        'BoxOpacity', 0, 'TextColor', 'white');
end

%Display the bounding boxes over the detected characters
figure();
imshow(plateGuess);
title("Found characters");
hold on;
for b = 1 : numChar
    %Get the bounding box
    bb = c(b, :);
    rectangle('Position', bb, 'EdgeColor', 'w', 'LineWidth', 1.25);
end
end

