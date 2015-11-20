function [ note ] = determinationNoteSegmentOctave_Cepstral_Method( segment , Fs)
%determinationNoteSegment.m
%   USAGE:
%       [ note ] = determinationNoteSegmentOctave( segment , Fs)
%
%	ATTRIBUTS:    
%       note:   Note détecté au au format string (Lettre anglosaxonne|# ou
%       espace|octave
%   
%       segment:     Extrait du signal audio d'origine 
%       Fs:      Fréquence d'échantillonnage de l'audio d'origine
%    
%	DESCRIPTION:   
%       On réalise une fft sur le signal 'segment'. On compare cette fft
%       avec des modèles de gaussienne centrée sur les notes de E2 à E6.
%       On choisit alors celle qui correspond le mieux. Il y a une
%       subtilité pour déterminer l'octave.
%       Ne fonctionne actuellement que pour détecter une note à la fois (et
%       fonctionne mal...)
%	BUT:    
%       Renvoyer les notes jouées dans le 'segment'

tabNomNotes=['E '; 'F '; 'F#'; 'G '; 'G#'; 'A '; 'A#'; 'B '; 'C '; 'C#'; 'D '; 'D#'];

%% Calcul de la fft sur le segment
if(length(segment)<2^19)
    segFftWin=fft(segment.*blackman(length(segment)), 2^15);  %Permet d'assurer une précision suffisante
    %   TODO: rendre ce paamètre de fft dépendant de la longueur du segment
    %   (mais toujours une puissance de 2).
else
    segFftWin=fft(segment.*blackman(length(segment)));
end


f0=YIN(segment,Fs)

 
tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)
tableNotes(:,:,3);
A = reshape(tableNotes(:,:,3),1,[]);
g=findClosest(A, f0);
if (mod(g,12)==0)
    h=12;
else   
h=mod(g,12);
end
if (f0>63.5 && f0<127)
    octave=2;
end
if (f0>127 && f0<244.5)
    octave=3;
end
if (f0>244.5 && f0<508)
    octave=4;
end
if (f0>508 && f0<1014)
octave=5;
end
if (f0>1014 && f0<2000)
octave=6;
end

note=[tabNomNotes(h,:)  num2str(octave)];

end