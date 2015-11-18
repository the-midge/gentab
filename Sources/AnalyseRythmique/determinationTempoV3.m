%déterminationTempoV3.m
%
%   Ce script tente de déterminer le tempo du morceau à partir de la sortie
%   de l'algorithme d'OD.
%   Il fait appel au fenêtrage et à l'autocorrélation comme décrit dans
%   Percival14-streamlined-tempo-estimation.pdf

clear fenetres;
%% B.1 Fenêtrage du OSS
largeur = 2048;
overlap = 128;
M = floor((length(oss)-largeur)/overlap)+1;
if M <0  % Si le morceau est très court (<6s)
    M = 1;    
    fenetres=oss;
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
EAC(1:round(length(A)/2),:) = A(1:2:end,:);
EAC(1:round(length(A)/4),:) = A(1:4:end,:);

%% B.4 Sélection des pics
Pacc = zeros(10,M);
maxBPM = 180; minBPM = 50;
min_lag = floor(60*FsOSS/maxBPM);
max_lag = floor(60*FsOSS/minBPM);
nPeaksMax = 10;
for m=1:M
    [pks, P]=findpeaks(EAC(min_lag:max_lag,m), 'NPEAKS', nPeaksMax, 'SORTSTR', 'descend');
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
Lm=60*FsOSS./(Pacc(Lm+(0:10:length(Lm)*10-1)')-1);
%% C. Accumulation et estimation générale
%   1) Gaussiennes
x=(1:maxBPM);
sigma=8;
abscisseTempo= bsxfun(@minus, x, Lm);
Gm=exp(-abscisseTempo.^2/(2*sigma^2))/(sigma*sqrt(2*pi));
indicesMinima= findClosest(x, Lm+2.33*sigma);
Gm=bsxfun(@minus, Gm, diag(Gm(:,indicesMinima)));
Gm(Gm<0)=0;
%   2) Accumulator
if M>1
    C=sum(Gm)'; 
else
    C=Gm;
end
C=C/sum(C);
%   3)  Séléctionner les 3 meilleurs pics
% [str, bpm]=findpeaks(C, 'NPEAKS', 3, 'SORTSTR', 'descend');
% bpm=bpm-1;
% L=bpm(1);
% if length(bpm)<2
%     bpm(2)=0;
%     bpm(3)=0;
% elseif length(bpm)<3
%     bpm(3)=0;
% end
%bpm=60*FsOSS./bpm;

%%   4)  Octave decider
%%%   4.1) Calcul des features
% energy_total=sum(C);
% features = [sumInRange(C,1,L-10)/energy_total; 
%             sumInRange(C,L+10,length(C))/energy_total];
% features=[features;1-sum(features)];
% features=[features;sumInRange(C,L/2-10,L/2+10)/energy_total];
% features=[features;sumInRange(C, 1*L-10, 1*L+10)/energy_total;sumInRange(C,2*L-10,2*L+10)/energy_total]; %Pb: on srt de C
% features=[features;1-sum(features(4:6));...
%             bpm(2)/bpm(1);...
%             bpm(3)/bpm(1);
%             length(find(C>0));
%             bpm(1)];

% %%   4.2) Prise de décision
% mult=1;
% % Valeurs déterminés par apprentissage (Cf Percival...pdf)
% mins = [ 0.0, 0.0, 0.0507398, 0.0, 0.0670043, 0.0, -4.44089e-16, 0.0, 0.0, min_lag-1, 41.0, 0];
% maxs = [ 0.875346, 0.932996, 1.0, 0.535128, 1.0, 0.738602, 0.919375, 3.93182, 4.02439, 93.0, 178.0, 0];
% svm_weights = [ 1.1071, -0.8404, -0.1949, -0.2892, -0.2094, 2.1781, -1.369, -0.4589, -0.8486, -0.3786, 0, 0 ];
% svm_sum = 2.1748+1.95;
% 
% features_normalized = zeros(size(features));
% for i = 1:length(features)
%     if mins(i) ~= maxs(i)
%         features_normalized(i) = ((features(i) - mins(i)) / (maxs(i) - mins(i)));
%     end
% end
% 
% for i = 1:length(features_normalized)
%     svm_sum = svm_sum + (features_normalized(i) * svm_weights(i));
% end
% 
% if svm_sum > 1.6
%     if svm_sum > 1.73
%         mult = 0.5;
%         disp('Tempo doit être divisé par 2');
%     else
%         mult = 2;
%         disp('Tempo doit être multiplié par 2');
%     end
% end
% if svm_sum <0.8
%     mult = 2;
%     disp('Tempo doit être multiplié par 2');
% end
% 
% tempo = 2*round(mult*bpm(1)/2); % Arrondi au nombre pair le plus proche