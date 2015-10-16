function [stft, t, f] = stft(x, fs, wlen, h, nfft)

% function: [stft, t, f] = mystftfun(x, fs, wlen, h, nfft)
% x - signal in the time domain
% wlen - length of the hamming window
% h - hop size
% nfft - number of FFT points
% fs - sampling frequency, Hz
% f - frequency vector, Hz
% t - time vector, s
% stft - STFT matrix (time across columns, freq across rows)

% represent x as column-vector if it is not
if size(x,2) > 1
    x = x';
end

% length of the signal
xlen = length(x);

% form a periodic hamming window
win = hamming(wlen, 'periodic');

% form the stft matrix
rown = ceil((1+nfft)/2);            % calculate the total number of rows
coln = 1+fix((xlen-wlen)/h);        % calculate the total number of columns
stft = zeros(rown, coln);           % form the stft matrix

% initialize the indexes
indx = 0;
col = 1;

% perform STFT
while indx + wlen <= xlen
    % windowing
    xw = x(indx+1:indx+wlen).*win;
    
    % FFT
    X = fft(xw, nfft);
    
    % update the stft matrix
    stft(:,col) = X(1:(rown));
    
    % update the indexes
    indx = indx + h;
    col = col + 1;
end

% calculate the time and frequency vectors
 sizeY=size(stft);
 t=(0:1/(sizeY(2)-1):1)'*(length(x))/fs;
 f=(0:nfft/2)'/nfft*fs;

end