clear all
clc

% OnsetDetection.m
%   DESCRIPTION: Script de haut niveau (wrapper), rassemblant les différentes fonctions ordonnées
%   pour la détection des onsets.
%       La détection des onsets correspond à la détection du début d'une
%       note jouée. La fin d'une note jouée est un offset. On ne cherche
%       pas à identifier ces derniers car souvent une note est
%       immédiatement suivie d'une autre (donc un onset). Cependant, quand
%       le son qui suit une note est silence, il faut alors déterminer
%       l'offset.
%   BUT: indiquer dans un vecteur les échantillons pour lesquelles une note
%   commence (ou fini). Un silence doit être considéré comme une note. Il
%   ne peut y avoir qu'un onset (offset) entre deux notes.

%%Chargement fichier son
audioFilename='BlueOrchidGP2.wav';
[x,Fs] = wavread(audioFilename);
tailleSequence = 12; % en secondes
x=x(1:Fs*tailleSequence, 1);

%% Définition des paramètres de prétraitement
% Degré de lissage
degreLissage=10;
%Paramètres de la stft
% pas de reelles augmentations de performance pour N < 2^11 
% N = 2^11 semble etre un juste milieu pour le ratio perf/tempsExec
N=2^11; 

% test : h doit-il etre adapte en fonction du morceau ?
h=190;   %fonctionne bien pour h=190 sur BlueOrchidGP2

%% Début de l'algorithme
%% Prétraitement
% Stft (Short-Time Fourier Transform)
[stftRes, t, f]=stft(x, Fs, 2^11, h, N); %Ces paramètres semblent ceux donnant les meilleurs résultats à ce jour

% On elimine les fréquences superieures a la note Mi6 (1300 Hz) + 200 Hz de
% tolerance pour eviter les parasites dus aux frequences harmoniques
Mi6 = 1300; % Hz
% 
% % on cherche les frequences utiles
indexFreqOpti = find(f < (Mi6 + 200));
% 
% % On les cale sur la matrice stftRes pour en reduire la taille
stftRes = stftRes(1:indexFreqOpti(end), 1:length(t));

% Spectral flux
sf=spectralflux(stftRes)';

sf=filtfilt(ones(degreLissage,1)/degreLissage, 1, sf);  % Lissage du spectral flux (pour éviter les faux pics de faible amplitude)

% normalisation 0 < sf < 100
facteurNorm = 100/max(sf);
sf = sf.*facteurNorm;

%% Paramètre détection de pics
FsSF=(length(sf)/(length(x)/Fs));   %Rapport entre le nombre d'échantillon du signal sftft (et sf) et ceux du signal "réel" x.
ecartMinimal= round(60/240*FsSF);   %ecart correspondant à 240 bpm
sensibilite=0.00*std(sf);    %Sensibilité de la détection du pic. Relative à l'amplitude de sf. Cf help findpeaks

%% Détermination du seuil - 2 options
% Option 1: moyenne locale
rapportMoyenneLocale=9e-4;
nbSampleMoyenneLocale = round(Fs*rapportMoyenneLocale);
moyenneLocale = filtfilt(ones(nbSampleMoyenneLocale,1)/nbSampleMoyenneLocale,1, sf);
 
%Le seuil semble être un peu trop élevé mais bien suivre la courbe.
seuil=moyenneLocale;   %Réduction par 10%
%seuil=moyenneLocale;
%sf=sf-moyenneLocale;

% Option 2: moyenne générale afin d'eviter les faux positifs
moyenneGlobale = mean(sf);

% Seuil minimal à atteindre pour détecter un pic.
% un seuil global fixe a 50% de la moyenne donne de bons resultats
PourcentSeuilGlogal = 50;
seuilGlobal(1:size(sf), 1) = moyenneGlobale*PourcentSeuilGlogal/100;

%seuilGlobal(1:size(Fs)) = moyenneGlobale;
%% Détection des peaks
% TODO: comment utiliser findpeaks avec un seuil variable
[amplitudeOnsets, sampleIndexOnsets]=ovldFindpeaks(sf, 'MINPEAKHEIGHT', seuil, 'MINPEAKDISTANCE', floor(ecartMinimal/2), 'THRESHOLD',sensibilite);

% 2 autres fonction de détection de pics fonctionnant moins bien
% maxtab=peakdet(sf, seuil, (length(sf)/(length(x)/Fs)));
% [pks, loc, width, resid]=peakdet2(sf, length(sf), 3*ecartmin, 100*ecartmin, seuil);

% suppression des premiers pics jusqu'au premier pic à dépasser la moitiée de la moyenne
% globale (à terme moyenne locale long terme)
indexPremierPic=1;
while(amplitudeOnsets(indexPremierPic) < mean(sf)/2)
    indexPremierPic=indexPremierPic+1;
end
% suppression des derniers pics jusqu'au premier pic à dépasser la moitiée de la moyenne
% globale (à terme moyenne locale long terme)
indexDernierPic=length(amplitudeOnsets);
while(amplitudeOnsets(indexDernierPic)<mean(sf)/2)
    indexDernierPic=indexDernierPic-1;
end

sampleIndexOnsets=sampleIndexOnsets(indexPremierPic:indexDernierPic);
sampleIndexOnsets(find(seuil(sampleIndexOnsets) < seuilGlobal(sampleIndexOnsets))) = [];
visualOnsets=zeros(size(sf));
visualOnsets(round(sampleIndexOnsets))=1;

%% Détections des silences (offsets)
silence = zeros(size(sf));
detectionSilence = zeros(size(sf));
silence(find(seuil < seuilGlobal)) = 1;

for i = 2:length(silence)
    if(silence(i) > silence(i-1))
        detectionSilence(i) = 1;
    else
        detectionSilence(i) = 0;
    end
end

indexSilence = find(detectionSilence == 1); % indices utiles pour la suite dans l'algorithme AR


%% Fin de l'algorithme
% Visualisation des résultats
if(length(seuil)==1)
    figure(2),plot(t, [sf max(sf)*visualOnsets ones(size(sf))*seuil max(sf)*detectionSilence]), axis([0 tailleSequence 0 110])
else
    figure(2),plot(t, [sf max(sf)*visualOnsets seuil seuilGlobal max(sf)*detectionSilence]), axis([0 tailleSequence 0 110]) 
end
%clear N h degreLissage indexPremierPic indexDernierPic amplitudeOnsets moyenneLocale rapportMoyenneLocale nbSampleMoyenneLocale ecartMinimal sensibilite;
