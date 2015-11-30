% GENEDeterminationNotes.m
%   DESCRIPTION:
%       Script d'exécution de tous les algos en rapport avec la détection
%       des notes. Doit fournir en sortie, la liste des notes jouées,
%       segment par segment, incluant l'octave de la note.
tabNomNotes=['E '; 'F '; 'F#'; 'G '; 'G#'; 'A '; 'A#'; 'B '; 'C '; 'C#'; 'D '; 'D#'];
len=2^11;
tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)
tableNotes=tableNotes(:,:,3);
tableNotes=tableNotes(:);
test= sin(2*pi*tableNotes*(0:1/Fs:len/Fs));

clear notesJouee;
[b(2,:), a(2,:)]=butter(2, [63.5/(Fs/2) 127/(Fs/2)]);
[b(3,:), a(3,:)]=butter(2, [127/(Fs/2) 244.5/(Fs/2)]);
[b(4,:), a(4,:)]=butter(2, [244.5/(Fs/2) 508/(Fs/2)]);
[b(5,:), a(5,:)]=butter(2, [508/(Fs/2) 1014/(Fs/2)]);
[b(6,:), a(6,:)]=butter(2, [1014/(Fs/2) 2000/(Fs/2)]);

for index= [1:length(segments)]
    tic
    clear ton;
    clear octave
    for k=1:48;
        ton(k+1,:)=conv(segments{index}, test(k,:));
    end

    [~, loc]=findpeaks(sum(ton.^2, 2), 'NPEAKS', 1,'MINPEAKHEIGHT', mean(sum(ton.^2, 2))+2*std((sum(ton.^2, 2))));
    h=mod(loc-1,12);

    if mod(loc-1,12)==0
        h=12;
    end
    
    notesJouee(index,:)=determinationNoteSegmentOctave_Harmonic_Product_Spectrum(segments{index} , Fs);
    notesJouee(index,1:2)=[tabNomNotes(h,:)];
    time(index)=toc;
end
