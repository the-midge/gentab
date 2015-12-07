function [ note ] = determinationNoteSegmentOctave_convolution(x, Fs)
%determinationNoteSegmentOctave_convolution
%   Détermination d'octave par convolution avec une banque de sinus
%   (résonateurs)
    tabNomNotes=['E '; 'F '; 'F#'; 'G '; 'G#'; 'A '; 'A#'; 'B '; 'C '; 'C#'; 'D '; 'D#'];
    len=2^11;
    tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)

    tableNotes=tableNotes(:,:,3);
    tableNotes=tableNotes(:);
    bankOfSines= sin(2*pi*tableNotes*(0:1/Fs:len/Fs));

    for kTon=1:48;
        ton(kTon+1,:)=conv(x, bankOfSines(kTon,:));
    end
    [~, loc]=findpeaks(sum(ton.^2, 2), 'NPEAKS', 1,'MINPEAKHEIGHT', mean(sum(ton.^2, 2))+2*std((sum(ton.^2, 2))));
    h=mod(loc-1,12);
    if mod(loc-1,12)==0
        h=12;
    end
    note = [tabNomNotes(h,:) ' '];
end

