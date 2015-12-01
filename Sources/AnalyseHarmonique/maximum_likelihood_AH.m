% maximum_likelihood_AH.m
%   Ce script impléménte la méthode décrite dans la publication
%   "Mximum likelihood Pitch Estimation Using Sinusoidal Modeling", de V.
%   Mahadevan.


segment=segments{index};

%% Calcul de la fft sur le segment
if(length(segment)<2^19)
    segFftWin=fft(segment.*blackman(length(segment)), 2^15);  %Permet d'assurer une précision suffisante
    %   TODO: rendre ce paamètre de fft dépendant de la longueur du segment
    %   (mais toujours une puissance de 2).
else
    segFftWin=fft(segment.*blackman(length(segment)));
end

% Manipulation de la fft pour l'avoir sous la bonne forme
y=length(segFftWin);
% axe_freq = (10:y/2-1-15380)*Fs/y;
% segFftWin=abs(segFftWin(11:(length(segFftWin)/2-15380)));
axe_freq = (0:y/2-1)*Fs/y;
segFftWin=(segFftWin(1:(length(segFftWin)/2)));
figure(1),plot(axe_freq,abs(segFftWin))

M=7;    %Nombre maximum d'harmoniques qui nous intéresse.
N=2^5;
f0=130.81; %Cas pour f0 = C3
indicesforF0=findClosest(axe_freq, [1:M]*f0);
gamma=segFftWin(indicesforF0);
A_f0=exp((1i*2*pi*f0)*(0:1/Fs:(N-1)/Fs)'*(1:M));
Aplus_f0 = ((A_f0'*A_f0)\A_f0');

gamma_chap = Aplus_f0*segment(1:N);
sigma_carr_chap = (segment(1:N)-A_f0*gamma_chap)*(segment(1:N)-A_f0*gamma_chap)/N;
% plot((A_f0*gamma))