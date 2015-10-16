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

%% Définition des paramètres de prétraitement

%Paramètres de la stft
Nfft=2^12; h=190;   %fonctionne bien pour h=441

% Degré de lissage
degreLissage=round(Fs/h/10); %Fs/h correspond à la sensibilité temporelle de la stft
%% Nécéssite une étape de prétraitement
% getUsefulFreq

%% Début de l'algorithme
% Stft (Short-Time Fourier Transform)
[stftRes, t, f]=stft(x, Fs, Nfft, h, Nfft); %Ces paramètres semblent ceux donnant les meilleurs résultats à ce jour
%figure(1), clf, mesh(f(1:findClosest(f, 1e4)),t,20*log10(abs(stftRes((1:findClosest(f, 1e4)), :)))'); ylabel('Temps (s)'); xlabel('Fréquence (Hz)');


%%
%   complex spectral difference method
sf=getOnsets(stftRes,20,20000, Fs, Nfft);
sf=filtfilt(ones(degreLissage,1)/degreLissage, 1, sf);  % Lissage du spectral flux (pour éviter les faux pics de faible amplitude)

%% Paramètre détection de pics
FsSF=(length(sf)/(length(x)/Fs));   %Rapport entre le nombre d'échantillon du signal sftft (et sf) et ceux du signal "réel" x.
ecartMinimal= round(60/240*FsSF);   %ecart correspondant à 240 bpm
sensibilite=0.00*std(sf);    %Sensibilité de la détection du pic. Relative à l'amplitude de sf. Cf help findpeaks

%% Détermination du seuil - 2 options
% Option 1: moyenne locale
rapportMoyenneLocale=40e-4; % regarde la moyenne locale sur plus d'échantillons
nbSampleMoyenneLocale = round(Fs*rapportMoyenneLocale);
moyenneLocale = filtfilt(ones(nbSampleMoyenneLocale,1)/nbSampleMoyenneLocale,1, sf);
 
%Le seuil semble être un peu trop élevé mais bien suivre la courbe.
seuil=moyenneLocale;   %Réduction par 10%
%seuil=moyenneLocale;
%sf=sf-moyenneLocale;

% Option 2: moyenne générale
%seuil=mean(sf);                     % Seuil minimal à atteindre pour détecter un pic.
%% Détection des peaks
% TODO: comment utiliser findpeaks avec un seuil variable
[amplitudeOnsets, sampleIndexOnsets]=ovldFindpeaks(sf, 'MINPEAKHEIGHT', seuil, 'MINPEAKDISTANCE', floor(ecartMinimal/2), 'THRESHOLD',sensibilite);

% 2 autres fonction de détection de pics fonctionnant moins bien
% maxtab=peakdet(sf, seuil, (length(sf)/(length(x)/Fs)));
% [pks, loc, width, resid]=peakdet2(sf, length(sf), 3*ecartmin, 100*ecartmin, seuil);

% suppression des premiers pics jusqu'au premier pic à dépasser la moitiée de la moyenne
% globale (à terme moyenne locale long terme)
indexPremierPic=1;
while(amplitudeOnsets(indexPremierPic)<mean(sf)/2)
    indexPremierPic=indexPremierPic+1;
end
% suppression des derniers pics jusqu'au premier pic à dépasser la moitiée de la moyenne
% globale (à terme moyenne locale long terme)
indexDernierPic=length(amplitudeOnsets);
while(amplitudeOnsets(indexDernierPic)<mean(sf)/2)
    indexDernierPic=indexDernierPic-1;
end

sampleIndexOnsets=sampleIndexOnsets(indexPremierPic:indexDernierPic);
visualOnsets=zeros(size(sf));
visualOnsets(round(sampleIndexOnsets))=1;

%% Détections des silences (offsets)
% TODO: proposer une solution valable pour cette partie.
%peaks=peaks+detectionSilences(sf, 1);

%% Fin de l'algorithme
% Visualisation des résultats
if(length(seuil)==1)
    figure(1),clf, plot(t, [sf max(sf)*visualOnsets ones(size(sf))*seuil])
else
    figure(2),plot(t, [sf max(sf)*visualOnsets seuil])  
end

clear N h degreLissage indexPremierPic indexDernierPic amplitudeOnsets moyenneLocale rapportMoyenneLocale nbSampleMoyenneLocale ecartMinimal sensibilite;
