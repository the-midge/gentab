function [] = save2expectedTXT(filename, viIndexOnset, viNotes, viRythme, iTempo,dFsSTFT)
%   save2expectedTXT.m
%   USAGE: 
%       [] = save2expectedTXT(filename, viNotes, rythmen, iTempo)
%   ATTRIBUTS:
%       filename: nom du fichier à générer, incluant le chemin relatif
%       viIndexOnset: indices où les onsets (offsets) sont détectés dans la
%       base de temp FsSTFT.
%       viNotes: liste des viNotes effectivement jouée respectant le format A#3
%           (note, dièse/espace, octave). Une note par ligne.
%       viRythme: liste des durée de viNotes au format vecteur d'entier (ou double).
%           La valeur de durée de la note correspond à l'indice dans le
%           tableau tab_nom_duree_viNotes généré à l décomposition rythmique
%       iTempo: iTempo moyen à la noire pour tout le morceau.
%       dFsSTFT: Temps d'échantillonnage après transformation par STFT
%
%   BUT:
%       Écrire dans un fichier .txt les valeurs attendues à la fin des
%       calculs pour améliorer l'évaluation des tests. Complémentaire avec
%       loadExpectedTXT().

if(nargin~=6)
    error('Invalid input argument');
end

fileLength=length(viIndexOnset);

%Crée le ficheir s'il n'existe pas
FID=fopen(filename, 'a');
if(FID==-1)
    error('Le chemin ou le nom du fichier est incorrect');
end

% Vide le fichier
FID=fopen(filename, 'w');
fclose(FID);

% Ouvre le fichier en mode append
FID=fopen(filename, 'a');

% écriture du nombre de note en entête du fichier
fprintf(FID, '%d notes\n', fileLength);

% écriture du iTempo en entête du fichier
fprintf(FID, 'Tempo: %d bmp\n', int16(iTempo));

% écriture de la fréquence d'échantillonage en entête du fichier
fprintf(FID, 'FsSTFT: %s Hz\n', num2str(double(dFsSTFT)));

% retour_char = repmat('\n', size(viNotes, 1), 1)
% [viNotes retour_char];
for(i = 1:fileLength)
    fprintf(FID, '%s\t%d\t%d\n',int16(viNotes(i,:)), int16(viRythme(i)), viIndexOnset(i));
   % fprintf(FID, [rythme{i} '\n'], '*char');
end

fclose(FID);
end