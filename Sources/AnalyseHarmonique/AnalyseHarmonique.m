% GENEDeterminationNotes.m
%   DESCRIPTION:
%       Script d'exécution de tous les algos en rapport avec la détection
%       des notes. Doit fournir en sortie, la liste des notes jouées,
%       segment par segment, incluant l'octave de la note.

% % %Inutile pour l'instant
% [b(2,:), a(2,:)]=butter(2, [tableNotes(9,1,2)/2/(Fs/2) tableNotes(9,1,2)/(Fs/2)]);
% [b(3,:), a(3,:)]=butter(2, [tableNotes(9,1,2)/(Fs/2) tableNotes(9,2,2)/(Fs/2)]);
% [b(4,:), a(4,:)]=butter(2, [tableNotes(9,2,2)/(Fs/2) tableNotes(9,3,2)/(Fs/2)]);
% [b(5,:), a(5,:)]=butter(2, [tableNotes(9,3,2)/(Fs/2) tableNotes(9,4,2)/(Fs/2)]);
% [b(6,:), a(6,:)]=butter(2, [tableNotes(9,4,2)/(Fs/2) tableNotes(9,4,2)*2/(Fs/2)]);

clear notesJouees;
for index= [1:length(segments)]
    segment=segments{index};
    notesJouees{index} = determinationNoteSegmentOctave_convolution(segment, Fs);
%     notesJouees(index,:) = determinationNoteSegmentOctave_MultiPitch(segment ,Fs);
    aux =determinationNoteSegmentOctave_Harmonic_Product_Spectrum(segment , Fs);
    notesJouees{index}(3)=[aux(3)];
end