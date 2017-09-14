clear all
close all
clc
%%%%%%%%%%%%%
RGB = imread('pon1.png');
I = rgb2gray(RGB);
%imshow(I);
%%%%%%%
%Add noise
J = imnoise(I,'gaussian',0.05);
%figure, imshow(J);
%%%%%%%%%%%%%
medfilt2(J, [7 7]);
tic
medfilt2(J, [7 7]);
toc
%imshow(F)

%%%%%%%
%I = imread('cameraman.tif');
h = ones(7,7) / 49;
%h
imfilter(J,h);
tic
imfilter(J,h);
%F=average(J);
toc
%%%%%%

G = fspecial('gaussian',[7 7],2);
tic
%%F = imfilter(J,G,'same');
imfilter(J,G);
%imshow(F) 
toc
%%%%%%
%(original, denoised)
%%MSE = myMSE(F,I);
%%PSNR = 10 * log10( 255^2 / MSE);
%%%%
%(original, noised)

%%MSE1 = myMSE(F,J);
%%PSNR1 = 10 * log10( 255^2 / MSE1);
