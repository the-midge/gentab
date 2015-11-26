function [sf] = spectralflux(stft)
% spectralflux.m
% 
%   USAGE: 
%       [sf] = spectralflux (stft)
%   ATTRIBUTS:
%       stft:   Sortie de la stft (doubles complexes) de la forme stft(f,t) ou f est le domaine spectral, t le domaine temporel
%       sf:     Résultat de l'algorithme de flux spectral
% 
%   Description:
%       Cette fonction construit la liste des différentes notes jouées et 
%       repérées par l'algorithme d'Onset Detection. Ces notes se 
%       présentent sous la formes de vecteurs de taille variable 
%       correspondant à des extrait du son d'origine (sans traitement).

% Coefficients d'un filtre de dérivée.
 a=1;b=[1 -1];
 
 %Premier algo possible, fonctionne bien mais pas sf
 %Meilleur pour Day Tripper
stft=log10(abs(stft)+1); % Passage en échelle logarithmique pour minimiser les écarts
%  sfLogSum=sum(sfLog);    % Somme de toutes les valeurs à un instant t. Donne un vecteur en fonction du temps.

%Algo de sf
sf=filter(b, a, abs(stft)); % dérivée
%sf=diff(abs(stft));
% sf=(sf+abs(sf))/2;  % Passage des pics négatifs en pics positifs
%  semble pas utile car on a que des valeurs positives
sf=sum(sf)';

%sf=zscore(sf); % Normalisation des valeurs

end
