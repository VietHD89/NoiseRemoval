function w = fft_wavedec(im,wtype,J,parent)
%FFT_WAVEDEC: FFT-based implementation of the wavelet transform.
%
%   w = fft_wavedec(im,wtype,J,parent) computes the wavelet transform of 
%   the image 'im' using a Fourier method. It uses periodic boundary
%   conditions. The 2D size of the input signal can be arbitrary (at least
%   one dimension of the signal has to be even).
% 	
%   Input:
%   - im : input signal of size [Nx,Ny].
%   - (OPTIONAL) wtype : wavelet filter (see the Matlab function 'wfilters'
%   to find all the available filters). Default is 'sym8'.
%   - (OPTIONAL) J = [Jx Jy] : levels of decomposition. Default is the
%   maximum levels of decomposition.
%   - (OPTIONAL) parent : if parent is equal to 1, then the wavelet filters
%   used for the decomposition are the Group Delay Compensation (GDC)
%   filters associated to the filters 'wtype'. It only works when 'wtype'
%   are orthonormal filters. Default is 0.
% 	
%   Output:
%   - w : image of the same size as 'im' in the usual representation, i.e.
%   after one iteration in both dimension, 'w' is made of four quadrants
%   [LowLow HighLow; LowHigh HighHigh], the top left being the low-pass
%   filtered image on which further iterations may be applied.
% 	
%   See also fft_waverec, fft_wavefilters, wfilters, fft_gdc_filter.


[Nx,Ny] = size(im);
Jmax = aux_dyadic_max_scales([Nx,Ny]);
if(nargin<2)
    wtype = 'sym8';
end
if(nargin<3)
    J = Jmax;
end
if(nargin<4)
    parent = 0;
end

% Check that the maximum number of iterations is not exceeded
%------------------------------------------------------------
J(1) = min(Jmax(1),J(1));
J(2) = min(Jmax(2),J(2));

% Wavelet filters
%----------------
if(J(1)>0)
    FaX = fft_wavefilters(Nx,wtype);
else
    FaX = ones(2,Nx);
end
if(J(2)>0)
    FaY = fft_wavefilters(Ny,wtype);
else
    FaY = ones(2,Ny);
end
if(parent)
    if(J(1)>0)
        Wx = fft_gdc_filter(FaX(2,:),wtype);
        Wx2 = conj([Wx Wx]);
        FaX(2,:) = FaX(1,:).*Wx2;
    end  
    if(J(2)>0)
        Wy = fft_gdc_filter(FaY(2,:),wtype);
        Wy2 = conj([Wy Wy]);
        FaY(2,:) = FaY(1,:).*Wy2; 
    end
end
Gx = conj(FaX(1,:));
Hx = conj(FaX(2,:));
Gy = conj(FaY(1,:));
Hy = conj(FaY(2,:));

% Perform the 2D wavelet transform
%---------------------------------
w = im;
L = sort(J);
for j=1:L(1)
	for i=1:Nx,
		X = fft(im(i,:));
		Y = Gy.*X;
		Z = Hy.*X;
		Y = 1/2*(Y(1:Ny/2)+Y(Ny/2+(1:Ny/2)));
		Z = 1/2*(Z(1:Ny/2)+Z(Ny/2+(1:Ny/2)));
		im(i,:) = [ifft(Y) ifft(Z)];
	end;
	for i=1:Ny,
		X = fft(im(:,i).');
		Y = Gx.*X;
		Z = Hx.*X;
		Y = 1/2*(Y(1:Nx/2)+Y(Nx/2+(1:Nx/2)));
		Z = 1/2*(Z(1:Nx/2)+Z(Nx/2+(1:Nx/2)));
		im(:,i) = [ifft(Y) ifft(Z)].';		
	end;
	w(1:Nx,1:Ny) = im;

	Nx = Nx/2;
    Ny = Ny/2;
    
	im = w(1:Nx,1:Ny);
	Gx = Gx(1:2:end);
	Hx = Hx(1:2:end);
	Gy = Gy(1:2:end);
	Hy = Hy(1:2:end);    
end

% Perform the 2D wavelet transform for the remaining iteration(s) (if any)
%--------------------------------------------------------------------------
for j=1:(L(2)-L(1))
    if(L(2)==J(1))
        for i=1:Ny,
            X = fft(im(:,i).');
            Y = Gx.*X;
            Z = Hx.*X;
            Y = 1/2*(Y(1:Nx/2)+Y(Nx/2+(1:Nx/2)));
            Z = 1/2*(Z(1:Nx/2)+Z(Nx/2+(1:Nx/2)));
            im(:,i) = [ifft(Y) ifft(Z)].';
        end;
        w(1:Nx,1:Ny) = im;
        Nx = Nx/2;
        Gx = Gx(1:2:end);
        Hx = Hx(1:2:end);       
    else
        for i=1:Nx,
            X = fft(im(i,:));
            Y = Gy.*X;
            Z = Hy.*X;
            Y = 1/2*(Y(1:Ny/2)+Y(Ny/2+(1:Ny/2)));
            Z = 1/2*(Z(1:Ny/2)+Z(Ny/2+(1:Ny/2)));
            im(i,:) = [ifft(Y) ifft(Z)];
        end;
        w(1:Nx,1:Ny) = im;
        Ny = Ny/2;        
        Gy = Gy(1:2:end);
        Hy = Hy(1:2:end);          
    end    
	im = w(1:Nx,1:Ny);   
end
w = real(w);