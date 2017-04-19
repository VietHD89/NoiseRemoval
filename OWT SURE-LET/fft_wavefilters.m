function [Fa,Fs] = fft_wavefilters(M,wtype)
%FFT_WAVEFILTERS: Frequency response of the wavelet filters. 
% 	
%   [Fa,Fs] = fft_wavefilters(M,wtype) computes the 1D frequency response
%   of the scaling/wavelet filters for the analysis/synthesis filterbank. 
%
%   Input:
%   - M : length of the filters.
%   - wtype : wavelet filter (see the Matlab function 'wfilters'
%   to find all the available filters).
% 	
%   Output:
%   - Fa : frequency response of the analysis scaling filter (Fa(1,:)) and
%   the analysis wavelet filter (Fa(2,:)).
%   - Fs : frequency response of the synthesis scaling filter (Fs(1,:)) and
%   the synthesis wavelet filter (Fs(2,:)). 	
%
%   See also fft_wavedec, fft_waverec, wfilters.


if(strcmp(wtype(1:3),'bio') || strcmp(wtype(1:3),'rbi'))
    ortho = 0;
else
    ortho = 1;
end

[LO_D,HI_D,LO_R,HI_R] = wfilters(wtype);
nu = 0:1/M:(1-1/M);
z = exp(-2*i*pi*nu);
if(ortho)
    lowa = polyval(LO_D,z);
    higha = z.^(-1).*lowa;
    higha = conj([higha(M/2+(1:M/2)) higha(1:M/2)]);
    Fa = [lowa;higha];
    Fs = Fa;
else
    lowa = polyval(LO_D,z);
    higha = polyval(HI_D,z);
    lows = polyval(LO_R(end:-1:1),z);
    highs = polyval(HI_R(end:-1:1),z);
    Fa = [lowa;higha];
    Fs = [lows;highs];
end