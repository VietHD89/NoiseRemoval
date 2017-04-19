%DENOISING_DEMO: Denoising demonstration based on the SURE-LET principle
%   applied to interscale orthonormal wavelet thresholding.
%
%   See also OWT_SURELET_denoise.
%
clear all;
close all;

% Load the original noise-free image
%-----------------------------------
filename = './Images/lena.tif';
original = double(imread(filename));

sigma = 2;             % Noise standard deviation
wtype = 'sym8';         % Orthonormal Wavelet filter
PLOT  = 'on';           % If PLOT='on', the results are plotted
     
% Create input noisy image
%-------------------------
randn('state',0);
noise = randn(size(original));
noise = noise/std(noise(:));
input = original+sigma*noise;        

% Denoise
%--------
start  = clock;
output = OWT_SURELET_denoise(input,wtype,sigma);
time   = etime(clock,start);       

% PSNR computation
%-----------------
MSE_0  = mean((input(:)-original(:)).^2);
MSE_D  = mean((output(:)-original(:)).^2);
PSNR_0 = 10*log10(255^2/MSE_0);
PSNR_D = 10*log10(255^2/MSE_D);

% Display results
%----------------
fprintf(['\nInput PSNR   : ' num2str(PSNR_0,'%.2f') '[dB]']);
fprintf(['\nOutput PSNR  : ' num2str(PSNR_D,'%.2f') '[dB]']);
fprintf(['\nInput MSE   : ' num2str(MSE_0,'%.2f') '']);
fprintf(['\nOutput MSE  : ' num2str(MSE_D,'%.2f') '']);
fprintf(['\nElapsed time : ' num2str(time,'%.2f') '[s]\n\n']);

% Plot results
%-------------
if(strcmp(PLOT,'on'))
    h = figure('Units','normalized','Position',[0 0.5 1 0.5]);
    set(h,'name','OWT SURE-LET');
    subplot(1,3,1);imagesc(original,[0 255]);axis image;colormap gray(256);
    title('Original','fontsize',16,'fontweight','bold');drawnow;
    subplot(1,3,2);imagesc(input,[0 255]);axis image;colormap gray(256);
    title(['Noisy: PSNR = ' num2str(PSNR_0,'%.2f') ' dB'],'fontsize',16,...
   'fontweight','bold');drawnow;
    subplot(1,3,3);imagesc(output,[0 255]);axis image;colormap gray(256);
    title(['Denoised: PSNR = ' num2str(PSNR_D,'%.2f') ' dB'],'fontsize',...
    16,'fontweight','bold');drawnow;
end