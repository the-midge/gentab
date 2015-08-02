function [segments, bornes]=segmentation(x, sf, ind_onsets, Fs)
% segmentation.m
% 
%   USAGE: 
%       [segments, bornes]=segmentation(x, sf, ind_onsets, Fs)
%   ATTRIBUTS:
%       segments:      Liste des extraits du signal d'origine correspondant chacun 
%               à un segment (ou note jouée).
%       bornes: indices dans le domaine temporel d'origine correspondant
%               aux bornes de chaque segment.
%
%       x:      signal audio d'origine
%       sf:     résultat de l'algorithme de flux spectral
%       ind_onsets: indices dans le domaine du flux spectral des onsets 
%               récupérés après l'Onset Detection
%       Fs:     Fréquence d'échantillonnage
% 
%   Description:
%       Cette fonction construit la liste des différentes notes jouées et 
%       repérées par l'algorithme d'Onset Detection. Ces notes se 
%       présentent sous la formes de vecteurs de taille variable 
%       correspondant à des extrait du son d'origine (sans traitement).

%% Début du script
disp('Début de la segmentation');
FsSF=(length(sf)/(length(x)/Fs));   %Calcul le rapport de réduction entre 
%le son d'origine et la sortie de l'algo de "spectral flux".
t_x=(0:1/Fs:(length(x)-1)/Fs)'; %Vecteur temps du signal d'origine


for i=[1:length(ind_onsets)]    %Pour chaque attaque détectée,
    [val bornes(i, 1)]=min(abs(t_x-ind_onsets(i)/FsSF)); %On ajoute la valeur la plus proche de celle reconstituée via FsSF
end %a priori pas de vectorisation de cet algorithme possible


% La première note se situe entre les bornes 1 et 2 car le premier segment 
% est nécéssairement un silence (entre le début et la première attaque).
segment1=[x(bornes(1):bornes(2))]; 

segments={segment1};   % On initialise la liste de sortie avec la première note

for i=[2:length(bornes)-1]
    segments=cat(1,segments,[x(bornes(i):bornes(i+1))]);    % On ajoute les segments à la liste.
end

%%%
% Cette boucle peut être exécutée pour tester le bon fonctionnement de
% l'algorithme.
% Tous les segments sont joués les uns après les autres.
% On doit retrouvé le morceau d'origine entrecoupé de petits silence entre
% chaque segment.

% for i=[1:length(segments)]
% sound(segments{i},Fs);
% end
disp('Fin de la segmentation');

end
%% Fin de la fonction