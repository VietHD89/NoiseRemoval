I = imread('car.png');
F = median(I,7);

I = imread('lena.tif');
F=average(I);

I = imread('lena.tif');
F = gaussian(I) 