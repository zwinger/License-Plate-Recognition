%Read in the fonts image
img = imread('License_Plate_Font_Templates.png');

%convert the image to grayscale
img = rgb2gray(img);
%Create a binary image of the templates and display it
bwImg = img < 200;
figure();
imshow(bwImg);

%Find the bounding boxes for each of the characters
stats = regionprops(bwImg, 'BoundingBox');
numTemplates = size(stats, 1);

%The characters the templats with be split up into
templates = 'ATBUCVDWEXFYGZH0I1J2K3L4M5N6O7P8Q9RS';

figure();
%Crop out each template and save it
for i = 1 : numTemplates
    bb = stats(i).BoundingBox;
    template = imcrop(bwImg, bb(1, :));
    imshow(template);
    imwrite(template, strcat('Templates/', templates(i), '.bmp'));
end