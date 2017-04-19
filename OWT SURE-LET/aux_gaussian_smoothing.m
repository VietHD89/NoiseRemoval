function y = aux_gaussian_smoothing(x,sigma)
%AUX_GAUSSIAN_SMOOTHING: Applies a normalized 2D Gaussian kernel on a 2D
%   signal.
%
%   y = aux_gaussian_smoothing(x,sigma) applies a normalized 2D Gaussian
%   kernel with standard deviation 'sigma' on the the 2D signal 'x'.
% 	
%   Input:
%   - x : input 2D signal.
%   - sigma : standard deviation of the normalized 2D Gaussian kernel.
% 	
%   Output:
%   - y : smoothed 2D signal of the same size as 'x'.


sigma2 = sigma^2;
[nx,ny] = size(x);
M = ceil(3*sigma);
if(nx==1 || ny==1)
    X = -M:M;
    kernel = 1.0/(sqrt(2*pi)*sigma)*exp(-X.^2/(2*sigma2));
    y = convn(padarray(x(:),M,'circular'),kernel(:),'valid');
    y = reshape(y,nx,ny);
else
    [X,Y] = meshgrid(-M:M);
    kernel = 1.0/(sqrt(2*pi)*sigma)^2*exp(-(X.^2+Y.^2)/(2*sigma2));
    y = conv2(padarray(x,[M,M],'circular'),kernel,'valid');
end