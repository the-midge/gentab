function [ peaks_out ] = OD_postTraitement( peaks, FsSFFT )
%OD_postTraitement.m
%   USAGE:
%       [ peaks_out ] = OD_postTraitement( peaks, Fs )
%
%   ATTRIBUTS:
%       peaks: vecteur dans le domaine du temps de la sfft à 1 pour un
%       onset (offset détecté) 0 sinon;
%       FsSFFT: Fréquence d'échantillonnage dans le domaine du temps de la sfft

%%  Vérification de l'écart minimal respecté
%Si deux onsets sont plus proche que ecart_minimal, alor on supprime le
%deuxième.
ecart_minimal= round(60/240*FsSFFT);   %ecart correspondant à 240 bpm



end

