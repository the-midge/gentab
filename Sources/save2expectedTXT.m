function [] = save2expectedTXT(filename, notes, rythme)
%   save2expectedTXT.m
%   USAGE: 
%       [] = save2expectedTXT(filename, notes, rythme)
%   ATTRIBUTS:
%       filename: nom du fichier à générer, incluant le chemin relatif
%       notes: liste des notes effectivement jouée respectant le format A#3
%           (note, dièse/espace, octave). Une note par ligne.
%       rythme: liste des durée de notes au format celle array. Sous forme
%           de colonne. Le nom de durée de note sont les mêmes que dans
%           tabNomDureeNotes généré à l décomposition rythmique
%   BUT:
%       Écrire dans un fichier .txt les valeurs attendues à la fin des
%       calculs pour améliorer l'évaluation des tests. Complémentaire avec
%       loadExpectedTXT().

if(nargin~=3)
    error('Invalid input argument');
end

if(length(notes)~=length(rythme))
    error('notes et rythme doivent avoir le même nombre d''entrées');
end

fileLength=length(notes);

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
fwrite(FID, fileLength, '*double');
fwrite(FID, notes, '*char');

for(i = 1:fileLength)
    fwrite(FID, [rythme{i} '\'], '*char');
end

fclose(FID);
end