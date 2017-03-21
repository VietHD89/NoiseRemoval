I = imread('lena.tif');
F = imshow(I);
%%%%%%%
I = imread('lena.tif');
F = median(I,7);
%%%%%%%
I = imread('lena.tif');
F=average(I);
%%%%%%
I = imread('lena.tif');
F = gaussian(I); 
%%%%%%
MSE = myMSE(F,I);

