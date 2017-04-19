function im = fft_waverec(w,wtype,J)
%FFT_WAVEREC: FFT-based implementation of the inverse wavelet transform.
%
%   im = fft_waverec(w,wtype,J) computes the inverse wavelet transform of 
%   an arbitrary 2D signal 'w' using a Fourier method. It uses periodic 
%   boundary conditions. 
% 	
%   Input:
%   - w : 2D signal of size [Nx,Ny] in the usual representation, i.e. in
%   the case of one iteration in both dimensions (J=[1,1]), w is made of
%   four quadrants [LowLow HighLow ; LowHigh HighHigh], the top left being
%   the low-pass filtered image.
%   - (OPTIONAL) wtype : wavelet filter (see the Matlab function 'wfilters'
%   to find all the available filters). Default is 'sym8'.
%   - (OPTIONAL) J = [Jx Jy] : levels of decomposition. Default is the
%   maximum levels of decomposition.
% 	
%   Output:
%   - im : signal of the same size as 'w', such that:
%   fft_wavedec(im,wtype,J) = w
% 	
%   See also fft_wavedec, fft_wavefilters, wfilters.

[Nx,Ny] = size(w);
Jmax = aux_dyadic_max_scales([Nx,Ny]);
if(nargin<2)
    wtype = 'sym8';
end
if(nargin<3)
    J = Jmax;
end

% Check that the maximum number of iterations is not exceeded
%------------------------------------------------------------
J(1) = min(Jmax(1),J(1));
J(2) = min(Jmax(2),J(2));

% Wavelet filters
%----------------
if(J(1)>0)
    [aux,FsX] = fft_wavefilters(Nx,wtype);
else
    FsX = ones(2,Nx);
end
if(J(2)>0)
    [aux,FsY] = fft_wavefilters(Ny,wtype);
else
    FsY = ones(2,Ny);
end
Gx = FsX(1,:);
Hx = FsX(2,:);
Gy = FsY(1,:);
Hy = FsY(2,:);

% Perform the 2D inverse wavelet transform
%-----------------------------------------
Nx = Nx/2^J(1);
Ny = Ny/2^J(2);
L = sort(J);
for j=L(2):-1:(L(1)+1)
    if(L(2)==J(1))
        Hx1 = Hx(1:2^(j-1):end);
        Gx1 = Gx(1:2^(j-1):end);
        im = w(1:2*Nx,1:Ny);
        for i=1:Ny
            Y = fft(im(1:Nx,i)).';
            Z = fft(im((Nx+1):2*Nx,i)).';            
            Y0 = Gx1(1:Nx).*Y+Hx1(1:Nx).*Z;
            Y1 = Gx1(Nx+(1:Nx)).*Y+Hx1(Nx+(1:Nx)).*Z;
            Y = [Y0 Y1];
            im(:,i) = ifft(Y).';            
        end;
        Nx = 2*Nx;
        w(1:Nx,1:Ny) = im;
    else
        Hy1 = Hy(1:2^(j-1):end);
        Gy1 = Gy(1:2^(j-1):end);
        im = w(1:Nx,1:2*Ny);
        for i=1:Nx
            Y = fft(im(i,1:Ny));
            Z = fft(im(i,(Ny+1):2*Ny));
            Y0 = Gy1(1:Ny).*Y+Hy1(1:Ny).*Z;
            Y1 = Gy1(Ny+(1:Ny)).*Y+Hy1(Ny+(1:Ny)).*Z;
            Y = [Y0 Y1];
            im(i,:) = ifft(Y);
        end;
        Ny = 2*Ny;
        w(1:Nx,1:Ny) = im;
    end
end

% Perform the 2D inverse wavelet transform for the remaining iteration(s)
% (if any)
%------------------------------------------------------------------------
for j=L(1):-1:1
        Hx1 = Hx(1:2^(j-1):end);
        Gx1 = Gx(1:2^(j-1):end);
        im = w(1:2*Nx,1:2*Ny);
        for i=1:2*Ny
            Y = fft(im(1:Nx,i)).';
            Z = fft(im((Nx+1):2*Nx,i)).'; 
            Y0 = Gx1(1:Nx).*Y+Hx1(1:Nx).*Z;
            Y1 = Gx1(Nx+(1:Nx)).*Y+Hx1(Nx+(1:Nx)).*Z;
            Y = [Y0 Y1];
            im(:,i) = ifft(Y).';
        end        
        Hy1 = Hy(1:2^(j-1):end);
        Gy1 = Gy(1:2^(j-1):end);
        for i=1:2*Nx
            Y = fft(im(i,1:Ny));
            Z = fft(im(i,Ny+(1:Ny)));
            Y0 = Gy1(1:Ny).*Y+Hy1(1:Ny).*Z;
            Y1 = Gy1(Ny+(1:Ny)).*Y+Hy1(Ny+(1:Ny)).*Z;
            Y = [Y0 Y1];
            im(i,:) = ifft(Y);
        end
        Nx = 2*Nx;
        Ny = 2*Ny;
        w(1:Nx,1:Ny) = im;
end
im = real(w);