function [out] = determinationDurees(durresBrutes, peigneGaussienne, abscisse)
%%
% Cette fonction determine les deux meilleures durees normalisées (une 
% inférieure et une supérieure) suivant leur probabilités a partir de 
% durees mesurées.
% 
% input  : 
%        dureesMesurees   : durees mesurees en sortie de l'onset detection
%        peigneGaussienne : probabilités d'apparition de chaque duree 
%                           normalisée suivante la duree mesuree
%        abscisse         : abscisses faisant le lien entre les indices des
%                           durees mesurees et leur probabilités (Peigne)
%
% output :
%        out : matrice de sortie se presentant de la maniere suivante 
%
%   out(:, 1) = durees mesurees
%   out(:, 2) = durees inferieures (DI)
%   out(:, 1) = probabilités des DI
%   out(:, 1) = durees superieures (DS)
%   out(:, 1) = proba des DS
%
out = zeros(length(durresBrutes), 5);

out(:, 1) = durresBrutes;

indice = findClosest(abscisse, durresBrutes);
proba = peigneGaussienne(indice, :);
[out(:, 3), out(:, 2)] = max(proba');

indice = findClosest(abscisse, durresBrutes);
proba = peigneGaussienne(indice, :);
[probaDS DS] = sort(proba, 2, 'descend');

out(:, 4) = DS(:, 2);
out(:, 5) = probaDS(:, 2);

% memes operations que dans la premiere boucle for mais pour gerer cette 
% fois-ci les DSN 

end

