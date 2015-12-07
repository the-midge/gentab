function [ note ] = determinationNoteSegmentOctave_MultiPitch(x, Fs)
%% Joint Multi-pitch Detection using Harmonic
%     Envelope Estimation for Polyphonic Music
%     Transcription  
%     I. Pre-traitement
%%     a) Transformée en constante Q
%       i) Paramètres
fmin = 55;  % Plus basse note est le A 1 à 55Hz
B = 120;    % Nombre de valeurs par octave
gamma = 20; % Offset de la constante Q (améliore les résultats en basse fréquence (<500Hz)
fmax = 7040; % 2ème harmonique de A8

%%%
%   ii) Calcul de la transformée
Xcq = cqt(x, B, Fs, fmin, fmax, 'rasterize', 'full', 'gamma', gamma);
X = Xcq.c;

hop = length(x)/size(X,2);
t=0:length(x)/(size(X,2)-1)/Fs:length(x)/Fs;
f=Xcq.fbas;
%%% 
%   Visualisation
% figure(1), clf, mesh(f,t,20*log10(abs(X))'); ylabel('Temps (s)'); xlabel('Fréquence (Hz)');

%%     b) Applatissement spectral (spectral whitening)
%       i) Paramètres
K= B/3; % Largeur "d'applatissement" (1/3 d'octave)
nu= 0.33;   % Coefficient d'applatissement

%%%
%   ii) Calcul
Whann= hanning(K);
sigma = sqrt(xcorr2(X.^2, Whann)./K);   % Puissance (racine) dans un tiers d'octave
sigma = sigma(K/2:size(sigma,1)-K/2,:);
Y = sigma.^(nu-1).*X;

%%     c) Suppression de bruit rose
%       1) pseudo moyenne locale N

% /!\ Trop compliqué à faire pour l'instant
% mat1=eye(length(f), length(f)+K/2);
% mat2 = mat1';
% mat=mat1(:,K/2+1:end)+mat2(K/2+1:end,:);
% 
% for k=1:length(f)
%     indices=find(mat(k,:)'==1);
%     nPts=length(find(Nprim(k,:)>Y(k,:)))
%     somme= sum(Nprim(find(Nprim(k,:)>Y(k,:)))
%     Nsecond= 
% end
% 
% %     2) cepstral coeficients
% Kprim = length(f); 
% KSI=50; %Nombre de coeddicient cepstral
% C=KSI; % Nombre de coefficients qui seront utilisé
% ksi=(0:KSI-1)';
% cKsi=Y'*cos(ksi*((1:length(f))-0.5)*pi/Kprim)'; % t x ksi

%% Multiple f0 estimation

Z=abs(Y);
H=13; h=(1:H)';
indiceMinFreq=log2(fmin/440)*12; % Indice en demi ton de fmin par rapport au A4 440Hz
indiceMaxFreq=log2(fmax/440)*12; % Indice en demi ton de fmaxpar rapport au A4 440Hz

fp=440*2.^((indiceMinFreq:indiceMaxFreq)/12);
kpo= findClosest(f, fp);    % indices des fréquences p dans f
fph=h*fp;      % fréquence du pitch à l'harmonique h

% Calcul de la fonction de salience s(p, deltap, betap)

for p=1:length(fp)
    s=zeros(length(t), 5, 6);  
    for delta=0;  % tuning deviation (en élément du domaine fréquentiel (120/oct)
        for beta=0;   % Inharmonicités possibles
            s(:, delta+5, round(beta*6/5.e-4 +1))=salience(p, delta, beta, B, kpo, Z); %1 valeur par instant
        end
    end
%     delta=[-4:4];
%     beta=0:5.e-4/6:5.e-4*5/6;
    delta = 0;
    beta = 0;
    
%     for T=1:length(t)
%     [maxima, indDelta]=max(s(T,:,:), [], 2);    % Maximisation selon delta
%     indDelta=indDelta(:);
%     [~, indBeta]=max(maxima);    % Maximisation selon delta
%     indBeta;
%     deltaP(T, p)=delta(indDelta(indBeta));
%     betaP(T,p)=beta(indBeta);
%     end
%     sprim(:,p)=salience(p, deltaP(T, p), betaP(T,p), B, kpo, Z);
    sprim(p)=salience(p, 0, 0, B, kpo, Z);

end

%% Détection de pics
locMean = filter(ones(8,1), 1, sprim);
sprim=sprim(8:end);             % On ne s'intérèsse qu'à ce qui suit le E 2
sprim=zscore(sprim./locMean(8:end));
sprim(sprim<max(sprim)*0.9)=0;  % Seulement la 2ème reglèe est appliquée (<0.1*max =0)
[pks, C]=findpeaks(sprim, 'Npeaks', 10);  % A maximum of 10 peaks is kept
Cmod12=mod(C-1,12)+1;
Coct = floor((C-9)/12)+3;

tonsPresents = unique(Cmod12);
if length(tonsPresents)>1 % Cas où plusieurs notes sont présentes
	Noccurences=hist(Cmod12, tonsPresents);   %Nombre de pics pour chaque ton
    [nHarmoniquesMax, demiTon]=max(Noccurences);
    if max(Noccurences) == 1
        tonsPresents=demiTon;
    else
        tonsPresents=tonsPresents(Noccurences>1);
    end
end
tabNomNotes=['E '; 'F '; 'F#'; 'G '; 'G#'; 'A '; 'A#'; 'B '; 'C '; 'C#'; 'D '; 'D#'];
if length(C)<1
    note = 'R  ';
else
    note=[tabNomNotes(Cmod12(1), :) ' '];
end


end
% figure(1), clf, plot(sprim); xlabel('Fréquence (pitch)');
