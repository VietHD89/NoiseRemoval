%Add noise
subplot(2,2,1);
I = imread('lena.tif');
J = imnoise(I,'gaussian',0,0);
imshow(J(100:256,1:256));
title('Added Gaussian Noise');

%Remove noise
subplot(2,2,2);
K = wiener2(J,[5 5]);
D = imshow(K(100:256,1:256));
title('Noise Removed by Wiener Filter');

%MSE
MSE = myMSE(D,I);