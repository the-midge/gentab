% GENE_TestOnsetDetection.m
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
% Degré de lissage
degre_lissage=10;
%Paramètres de la stft
N=2^11; h=441;   %fonctionne bien pour h=441

%% Nécéssite une étape de prétraitement
% getUsefulFreq

%% Début de l'algorithme
% Stft (Short-Time Fourier Transform)
[stft_res, t, f]=stft(x, Fs, 2^11, h, N); %Ces paramètres semblent ceux donnant les meilleurs résultats à ce jour
%figure(1), clf, mesh(f,t,20*log10(abs(stft_res))'); xlabel('Temps (s)'); ylabel('Fréquence (Hz)');

%%% 
% Spectral flux
sf=spectralflux(stft_res)';

%%
%   Phase Deviation (TODO)

sf=filtfilt(ones(degre_lissage,1)/degre_lissage, 1, sf);  % Lissage du spectral flux (pour éviter les faux pics de faible amplitude)

%% Paramètre détection de pics
% TODO: Rendre local (variable) ce seuil
FsSF=(length(sf)/(length(x)/Fs));   %Rapport entre le nombre d'échantillon du signal sftft (et sf) et ceux du signal "réel" x.
ecart_minimal= round(60/240*FsSF);   %ecart correspondant à 240 bpm
sensibilite=0.00*std(sf);    %Sensibilité de la détection du pic. Relative à l'amplitude de sf. Cf help findpeaks

%% Détermination du seuil - 2 options
% Option 1: moyenne locale
rapport_moyenne_locale=1e-3;
moyenne_locale = filtfilt(ones(round(Fs*rapport_moyenne_locale),1)/round(Fs*rapport_moyenne_locale),1, sf);
%Le seuil semble être un peu trop élevé mais bien suivre la courbe.
seuil=moyenne_locale   %Réduction par 10%
%seuil=moyenne_locale;
%sf=sf-moyenne_locale;

% Option 2: moyenne générale
%seuil=mean(sf);                     % Seuil minimal à atteindre pour détecter un pic.
%% Détection des peaks
% TODO: comment utiliser findpeaks avec un seuil variable
[pks, loc]=ovld_findpeaks(sf, 'MINPEAKHEIGHT', seuil, 'MINPEAKDISTANCE', floor(ecart_minimal/2), 'THRESHOLD',sensibilite);

% 2 autres fonction de détection de pics fonctionnant moins bien
% maxtab=peakdet(sf, seuil, (length(sf)/(length(x)/Fs)));
% [pks, loc, width, resid]=peakdet2(sf, length(sf), 3*ecartmin, 100*ecartmin, seuil);

visual_onsets=zeros(size(sf));
visual_onsets(round(sample_index_onsets))=1;

%% Détections des silences (offsets)
% TODO: proposer une solution valable pour cette partie.
%peaks=peaks+detection_silences(sf, 1);

%% Fin de l'algorithme
% Visualisation des résultats
if(length(seuil)==1)
    figure(2),plot(t, [sf max(sf)*peaks ones(size(sf))*seuil])  % à modifier légèrement pour un seuil variable
else
    figure(2),plot(t, [sf max(sf)*peaks seuil])  % à modifier légèrement pour un seuil variable
end
clear N h ecart_minimal sensibilite degre_lissage