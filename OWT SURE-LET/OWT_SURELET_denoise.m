function output = OWT_SURELET_denoise(input,wtype,sigma)
%OWT_SURELET_DENOISE: Removes additive Gaussian white noise using the
%   inter-scale SURE-LET principle in the framework of an orthonormal
%   wavelet transform (OWT).
% 	
%   output = OWT_SURELET_DENOISE(input,wtype,sigma) performs an inter-scale
%   orthonormal wavelet thresholding based on the principle exposed in [1].
%
%   Input:
%   - input : noisy signal of size [nx,ny].
%   - (OPTIONAL) wtype : orthonormal wavelet filter (see the Matlab
%   function 'wfilters' to find all the available orthonormal filters).
%   Default is 'sym8'.
%   - (OPTIONAL) sigma : standard deviation of the additive Gaussian white
%   noise. By default 'sigma' is estimated using a robust median
%   estimator.
% 	
%   Output:
%   - output : denoised signal of the same size as 'input'.
%
%   See also fcn_min_sure, wfilters.


if(nargin<2)
    wtype = 'sym8';
end
[nx,ny] = size(input);

% Compute the Most Suitable Number of Iterations
%-----------------------------------------------
J = aux_num_of_iters([nx,ny]);
if(max(J)==0)
    disp('The size of the signal is too small to perform a reliable denoising based on statistics.');
    output = input;
    return;
end

% Orthonormal Wavelet Transform
%------------------------------
WT = fft_wavedec(input,wtype,J);
WTp = abs(fft_wavedec(input,wtype,J,1));
denoisedWT = WT;

% Estimation of the Noise Standard Deviation 
%-------------------------------------------
if(nargin<3)
    if(J(1)>0 && J(2)>0)
        HH = WT(nx/2+1:end,ny/2+1:end);
    elseif(J(1)==0)
        HH = WT(1:end,ny/2+1:end);        
    elseif(J(2)==0)
        HH = WT(nx/2+1:end,1:end);
    end
    sigma = median(abs(HH(:)))/0.6745;
    fprintf(['\nEstimated Noise Standard Deviation: ' num2str(sigma,'%.2f') '\n']);
end

% Denoising Part
%---------------
Nor = 3;
it = min(J);
IT = max(J);
N1 = nx/2^J(1);
N2 = ny/2^J(2);
for i=1:it
    N1 = nx/2^i;
    N2 = ny/2^i;       
    for o=1:Nor
        switch o
            case 1
                Y = WT(1:N1,N2+1:2*N2);
                Yp = WTp(1:N1,N2+1:2*N2); 
                Yp = aux_gaussian_smoothing(Yp,1);
                denoisedWT(1:N1,N2+1:2*N2) = fcn_min_sure(Y,Yp,sigma); 
            case 2
                Y = WT(N1+1:2*N1,1:N2);
                Yp = WTp(N1+1:2*N1,1:N2);
                Yp = aux_gaussian_smoothing(Yp,1);
                denoisedWT(N1+1:2*N1,1:N2) = fcn_min_sure(Y,Yp,sigma);
            case 3
                Y = WT(N1+1:2*N1,N2+1:2*N2);
                Yp = WTp(N1+1:2*N1,N2+1:2*N2);
                Yp = aux_gaussian_smoothing(Yp,1);
                denoisedWT(N1+1:2*N1,N2+1:2*N2) = fcn_min_sure(Y,Yp,sigma);
            otherwise
                error(['The number of orientations is usually three for the '... 
                '2D dyadic wavelet transform !']);    
        end 
    end
end
for i=it+1:IT
    if(IT==J(1))
        N1 = nx/2^i;     
        Y = WT(N1+1:2*N1,1:N2);
        Yp = WTp(N1+1:2*N1,1:N2);
        Yp = aux_gaussian_smoothing(Yp,1);
        denoisedWT(N1+1:2*N1,1:N2) = fcn_min_sure(Y,Yp,sigma);
    else
        N2 = ny/2^i;
        Y = WT(1:N1,N2+1:2*N2);
        Yp = WTp(1:N1,N2+1:2*N2);
        Yp = aux_gaussian_smoothing(Yp,1);
        denoisedWT(1:N1,N2+1:2*N2) = fcn_min_sure(Y,Yp,sigma);
    end
end
output = fft_waverec(denoisedWT,wtype,J);