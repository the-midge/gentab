function [notesExpected, rythmeExpected]=loadExpectedTXT(filename)
%   save2expectedTXT.m
%   USAGE: 
%       [notesExpected, rythmeExpected]=loadExpectedTXT(filename)
%   ATTRIBUTS:
%       filename: nom du fichier à lire, incluant le chemin relatif
%       notesExpected:
%           Liste des notes reconnues. Format 'note|#/(espace)|octave' sans
%           séparateur
%       rythmeExpected:
%           Liste des durées de note reconnues. Format: cell array
%           verticale contenant le "nom" des durées de note.
%   BUT:
%       Lire dans un fichier .txt les valeurs attendues à la fin des
%       calculs pour améliorer l'évaluation des tests. Complémentaire avec
%       save2expectedTXT().


FID=fopen(filename, 'r');
if(FID==-1)
    error('Impossible d''ouvrir le fichier');
end

fileLength=fread(FID, 1, '*double');
notesExpected=fread(FID, fileLength*3, '*char');
notesExpected=reshape(notesExpected, [], 3);

rythmeExp=fread(FID, inf, '*char');

rythmeExpected={};
curChar='';
mot='';
for (i=1:length(rythmeExp))
    curChar=rythmeExp(i);
    if(curChar=='\')
        rythmeExpected={rythmeExpected{:} mot}'; 
        mot='';
    else
        mot=[mot curChar];
    end
end

fclose(FID);
end