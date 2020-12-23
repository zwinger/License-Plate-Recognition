for img = 1 : 11
    actualPlates = [];
    %Read in the image
    orgImg = imread(strcat('TestImages/myTestImage', int2str(img), '.jpg'));

    %Find the potential license plate regions
    [potentialPlates, numPlates] = detectLicensePlates(orgImg);

    %Crop out each region and predict the license plate number, if there is
    %one, the region is most likely a license plate
    realPlates = 0;
    for i = 1 : numPlates
        %Crop out the potential license plate region
        plate = imcrop(orgImg, potentialPlates(i, :));
        %Display the region
        figure();
        imshow(plate);
        
        %Predict the license plate number in the region
        plateNumber = determinePlateNumber(plate);
        fprintf("Plate Number is %s\n", plateNumber);

        %Check if the potential license plate region is actually a license 
        %plate, real license plates will return a non-empty plate number with
        %with a length of at least 5 characters
        if (strcmp(plateNumber, '') ~= 1 && strlength(plateNumber) >= 5)
            actualPlates = vertcat(actualPlates, potentialPlates(i, :));
            realPlates = realPlates + 1;
        end
    end

    %Display the true license plate regions by drawing a bounding box
    %around them
    figure();
    imshow(orgImg);
    title("Detected License plate(s)");
    hold on;
    for b = 1 : realPlates
        %Get the bounding box
        bb = actualPlates(b, :);
        rectangle('Position', bb, 'EdgeColor', 'w', 'LineWidth', 4.25);
    end
end