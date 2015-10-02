function [ peaksOut ] = ODPostTraitement( peaks, FsSFFT )
%ODPostTraitement.m
%   USAGE:
%       [ peaksOut ] = ODPostTraitement( peaks, Fs )
%
%   ATTRIBUTS:
%       peaks: vecteur dans le domaine du temps de la sfft à 1 pour un
%       onset (offset détecté) 0 sinon;
%       FsSFFT: Fréquence d'échantillonnage dans le domaine du temps de la sfft
%   TODO:
%       À développer et terminer

%%  Vérification de l'écart minimal respecté
%Si deux onsets sont plus proche que ecartMinimal, alors on supprime le
%deuxième.
ecartMinimal= round(60/240*FsSFFT);   %ecart correspondant à 240 bpm



end

