clear all
close all
clc
%%%%%%%%%%%%%
RGB = imread('pon4.png');
I = rgb2gray(RGB);
imshow(I)
%%%%%%%
%Add noise
J = imnoise(I,'gaussian',0.05);
figure, imshow(J)
%%%%%%%%%%%%%
F = medfilt2(J, [7 7]);
imshow(F)
%%%%%%%
%I = imread('cameraman.tif');
F=average(J);
%%%%%%
G = fspecial('gaussian',[7 7],2);
F = imfilter(J,G,'same');
imshow(F) 
%%%%%%
%(original, denoised)
MSE = myMSE(F,I);
PSNR = 10 * log10( 255^2 / MSE);
%%%%
%(original, noised)
MSE1 = myMSE(F,J);
PSNR1 = 10 * log10( 255^2 / MSE1);
