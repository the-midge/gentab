function [ notesNormeesModifiees ] = correctionDoubleCrochePointee( notesNormees, classeDoubleCroche, tempo, ecarts, Fs )
% correctionDoubleCrochePointee.m
%   USAGE:
%       [ notesNormeesModifiees ] = correctionDoubleCrochePointee( notesNormees, classeDoubleCroche, tempo, ecarts )
%   ATTRIBUTS:
%       notesNormeesModifiees: ce vecteur doit remplacer 'notesNormees'
%       
%       notesNormees: Ce vecteur contient les notes sous forme de "tempos
%       normalisés" par octave dans le domaines 4:0.5:9
%
%       classeDoubleCroche: classe des double-croches calculée a priori
%       dans le domaine 4:0.5:9
%
%       tempo: tempo final arrondi au nombre pair le plus proche
%
%       ecarts: vecteurs des écarts entre les bornes des segments (en nb
%       d'échantillons).
%
%       Fs: fréquence d'échantillonnage
%
%   BUT:
%       Les doubles croches pointées sont rares... On considère donc que 
%       pour une mesure intérmédiaire entre une double croche et une 
%       double croche pointée, il y a une plus grande probabilité qu'il 
%       s'agisse d'une double croche. On revoit donc l'estimation de la 
%       classe imédiatement inférieure à celle des doubles croches.
%    
%   RÉSULTATS:
%       N'a pas prouvé son efficacité...


    indNotesSuspectes=find(notesNormees==classeDoubleCroche-0.5);
    
    tempoDoubleCroche=4*tempo;
    tempoDoubleCrochePointee=tempo*2^classeDoubleCroche/2^(classeDoubleCroche-1.5);
    
    %On refait le calcul des tempos, ça ne coute pas cher
    tempos=(ecarts./Fs);
    tempos=((60)./tempos);
    notesNormeesModifiees=notesNormees;
    notesNormeesModifiees(indNotesSuspectes(find(tempos(indNotesSuspectes)>(tempoDoubleCroche/2+tempoDoubleCrochePointee/2))))=classeDoubleCroche;

end

