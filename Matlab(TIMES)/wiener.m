clear all
close all
clc

%subplot(1,3,1);
RGB = imread('pon1.png');
I = rgb2gray(RGB);
%imshow(I)
%title('Original Image');
%Add noise
%subplot(1,3,2);
J = imnoise(I,'gaussian',0.05);
%imshow(J);
%title('Added Gaussian Noise');
%Remove noise
%subplot(1,3,3);
K = wiener2(J,[7 7]);
tic
K = wiener2(J,[7 7]);
toc
%imshow(K);
%title('Denoise by Wiener Filter');

%MSE & PSNR
%MSE = myMSE(K,I);
%PSNR = 10 * log10( 255^2 / MSE);
%%%%
%MSE1 = myMSE(K,J);
%PSNR1 = 10 * log10( 255^2 / MSE1);