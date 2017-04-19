function xhat = fcn_min_sure(y,yp,sigma)
%FCN_MIN_SURE: Removes additive Gaussian white noise using the
%   inter-scale SURE-LET principle.
%
%   xhat = fcn_min_sure(y,yp,sigma) denoises the wavelet coefficients of a
%   given subband 'y' using ites corresponding inter-scale predictor 'yp',
%   as presented in [1]. 
% 	
%   Input:
%   - y : wavelet coefficients of the noisy signal.
%   - yp : wavelet coefficients of the inter-scale predictor (parent)
%   associated to 'y'.
%   - sigma : standard deviation of the additive Gaussian white noise.
% 	
%   Output:
%   - xhat : denoised wavelet coefficients.
%
%   See also OWT_SURELET_denoise.


[nx,ny] = size(y);
N = nx*ny;
numOfTerms = 2;
sigma2 = sigma^2;
T2 = 6*sigma2;

y = y(:);
y2 = y.^2;
yp2 = yp(:).^2;
maskParent = exp(-yp2/(2*T2));

theta = zeros(N,2*numOfTerms);
thetap = theta;

for n=1:numOfTerms
    gT = exp(-(n-1)*y2/(2*T2));
    gTp = -(n-1)/T2*y.*gT;
    theta(:,n) = maskParent.*y.*gT;
    theta(:,n+numOfTerms) = (1-maskParent).*y.*gT;
    
    thetap(:,n) = maskParent.*(gT+y.*gTp);
    thetap(:,n+numOfTerms) = (1-maskParent).*(gT+y.*gTp);        
end

K = size(theta,2);
Y = y(:)*ones(1,K);
C = mean(Y.*theta-sigma2*thetap).';
M = (theta.'*theta)/N;
A = pinv(M)*C;

xhat = reshape(theta*A,nx,ny);