%déterminationTempoV3.m
%
%   Ce script tente de déterminer le tempo du morceau à partir de la sortie
%   de l'algorithme d'OD.
%   Il fait appel au fenêtrage et à l'autocorrélation comme décrit dans
%   Percival14-streamlined-tempo-estimation.pdf

%% B.1 Fenêtrage du OSS
largeur = 2048;
overlap = 128;
M = floor((length(oss)-largeur)/overlap)+1;
if M <0  % Si le morceau est très court (<6s)
    M = 1;    
else
    fenetres=zeros(largeur,M);
    
    idx = 1; m=1;
    while idx<(length(oss)-largeur);
        fenetres(:,m) = oss(idx:idx+largeur-1);       
        idx = m*overlap+1;
        m=m+1;
    end
end

%% B.2 Autocorrélation "généralisée"
%   1) zero-padding to double the length
fenetres = [fenetres;zeros(largeur, M)];

%   2) Transformée de Fourier
dft_oss = fft(fenetres);
argument = angle(dft_oss);
%   3) Compression de la magnitude du spectre
c=0.5; % Donné dans la publication
mag = real(abs(dft_oss).^c);
dft_oss = complex(mag.*cos(argument), mag.*sin(argument));
%   4) Transformées de Fourier inverse
A = real(ifft(dft_oss));

%% B.3 Enhance Harmonics
EAC = A;
EAC(1:floor(length(A)/2),:) = A(1:2:end,:);
EAC(1:floor(length(A)/4),:) = A(1:4:end,:);

%% B.4 Sélection des pics
Pacc = zeros(10,M);
for m=1:M
    maxBPM = 210; minBPM = 50;
    min_lag = floor(60*FsOSS/maxBPM);
    max_lag = floor(60*FsOSS/minBPM);
    nPeaksMax = 10;
    [pks, P]=findpeaks(EAC(min_lag:max_lag,m), 'NPEAKS', npeaksMax, 'SORTSTR', 'descend');
    P=P+min_lag;
    %% B.5 Train d'impulsion
    indices1 = bsxfun(@times,P, 0:3)+1;
    indices15 = floor(bsxfun(@times,P, 0:1.5:4.5)+1);
    indices2 = bsxfun(@times,P, 0:2:6)+1;

    IPphi = zeros(max_lag*6+1, nPeaksMax);    % Matrice qui contient tous les trains d'impulsions combinés

    for p=1:length(P)
        IPphi(indices1(p,:),p) = IPphi(indices1(p,:),p)+1;
        IPphi(indices15(p,:),p) = IPphi(indices15(p,:),p)+0.5;
        IPphi(indices2(p,:),p) = IPphi(indices2(p,:),p)+0.5;
        rohP = xcorr(fenetres(:,m), IPphi(:,p), P(p)-1);
        SCv(p,m)=var(rohP);
        SCx(p,m)=max(rohP);
    end
    Pacc(:,m)=P;    %Enregistre les tempos candidats de cette fenêtre
end
SC=SCv/sum(sum(SCv)) + SCx/sum(sum(SCx));
[~, Lm]=max(SC); Lm=Lm';
Lm=Pacc(Lm+(0:10:320)');
%% C. Accumulation et estimation générale
%   1) Gaussiennes
x=(min_lag:max_lag);
sigma=10; mu=Lm(1);
abscisse= bsxfun(@minus, x, Lm);
Gm=exp(-abscisse.^2/(2*sigma^2))/(sigma*sqrt(2*pi));
%   2) Accumulator
C=sum(Gm)';
%   3)  Pick a peak
[~, L]=max(C);
%   4)  Octave decider
F1 = sum(C(1:L-10));    F2 = sum(C(round(L/2)-10:round(L/2)+10));
