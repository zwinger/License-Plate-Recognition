function [detectedLicensePlates, numPlates] = detectLicensePlates(orgImg)
%Find the regions of the image that may be license plates and return the
%bounding boxes for the regions and how many there are

%Get the size of the input image
[imgHeight, imgWidth] = size(orgImg);

%Turn the input image into grayscale
bwImg = rgb2gray(orgImg);
%Filter out any impulse noise with a median filter
blurred = medfilt2(bwImg);
%Blur the image with a 20x20 averaging filter
blurred = imfilter(blurred, fspecial('average', 20));
%Display the blurred image
figure(); 
imshow(blurred, []);
%Subtract the blurred image from the original grayscale image
diff = bwImg - blurred;
%Display the difference image
figure(); 
imshow(diff, []);
%Threshold the difference image to create an edge map
edgeMap = diff > 8;
%Display the edge map
figure()
imshow(edgeMap, []);

%Label the edge map
label = bwlabel(edgeMap);
colorLabel = label2rgb(label);
%Display the colored label image
figure();
imshow(colorLabel);
%Find the bounding boxes for the connected components in the edge map
stats = regionprops(label, bwImg, 'BoundingBox');
numRegions = size(stats, 1);

%Search the connected components for the potential license plate regions
boxes = [];
numPlates = 0;
for i = 1 : numRegions
    %Get the bounding box for the current region to calculate the area as
    %aspect ratio
    bb = stats(i).BoundingBox;
    width = bb(3);
    height = bb(4);
    y = bb(2);
    aspectRatio = height / width;
    area = width * height;
    
    %Heuristics for determining a license plate
    %License plates are expected to be in the middle 50% of the image
    if (((area >= 100000 && area < 300000)) && aspectRatio >= 0.35 && ...
          aspectRatio <= 0.6 && y >= imgHeight*0.25 && y <= imgHeight*0.75)
        boxes = vertcat(boxes, stats(i).BoundingBox);
        numPlates = numPlates + 1;
    end
end

detectedLicensePlates = boxes;
end

