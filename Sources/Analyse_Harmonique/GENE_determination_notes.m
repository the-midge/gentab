% GENE_determination_notes.m
%   DESCRIPTION:
%       Script d'exécution de tous les algos en rapport avec la détection
%       des notes. Doit fournir en sortie, la liste des notes jouées,
%       segment par segment, incluant l'octave de la note.
disp('Début identification des notes');
for segment= [1:length(L)]
    notes_jouee(segment,:)=determination_note_segment_octave(L{segment} , Fs);
end
disp('Fin identification des notes');
notes_jouee     % Affichage des notes jouées (détectées)

%% Pour le morceau Echantillon....wav on reconnait:
% Le segment 2 (B), 3 (D), 4 (F) noires
% Le segment 5 (A), 6 (B), 7 (A), etc... croches
% Pas le segment 13 (B au lieu de E)
% Le segment 14 (G)*, 15 (A) , 16 (C), 17 (D), 18 (E)




%*(avec padded 2^15)
