%%# Read an image
I = imread('lena.tif');
%# Create the gaussian filter with hsize = [3 3] and sigma = 2
G = fspecial('gaussian',[7 7],2);
%# Filter it
F = imfilter(I,G,'same');
%# Display
imshow(F)