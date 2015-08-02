% -*- texinfo -*- 
% @deftypefn {specgram3D} {@var{y}, @var{t}, @var{f} =} specgram3D (@var{x}, @var{N}, @var{h}, @var{FS})
%
% @seealso{specgram, stft}
% @end deftypefn

% Author: Martin LAURENT
% Created: 2015-01-02


% À mettre au propre!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function [y, t, f] = specgram3D (x, N, h, Fs)

[y,t,f]=stft(x, Fs, N, h, N); 
%y=20*log10(stft(x, N, h, N, 2));  #Attention pourquoi 2 fois N?

y=20*log10(abs(y));
%t=t/Fs;
%f=f*Fs/N/2;

figure(1),clf; mesh(f, t, y);

end
