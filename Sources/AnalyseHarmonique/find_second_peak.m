function [ note ] = find_second_peak( segment , Fs)
%determinationNoteSegment.m

% HPS pour Harmonic Product Spectrum 

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
    segFftWin=fft(segment.*blackman(length(segment)), 2^13);  %Permet d'assurer une précision suffisante
    %   TODO: rendre ce paamètre de fft dépendant de la longueur du segment
    %   (mais toujours une puissance de 2).
else
    segFftWin=fft(segment.*blackman(length(segment)));
end
                                                  
                                                  
% Manipulation de la fft pour l'avoir sous la bonne forme
y=length(segFftWin);
axe_freq = (6:y/2-1)*Fs/y; % seuil de fft qui commence à 37 Hz
segFftWin=abs(segFftWin(7:(length(segFftWin)/2)));
%figure, plot(axe_freq,segFftWin);
[pks,locs,w,p] = findpeaks(segFftWin);
h=find(pks>=max(pks)/2);
indicemax_freq=pks(h(2));

% [m,n]=findpeaks(s, 'SORTSTR', 'descend');
% Maximum = n(1);


% Recherche des maximums de la fft 

% indicemax_freq=Maximum*Fs/y;


% %% Recherche de la fréquence la plus proche dans la table de notes
                                                  
tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)
tableNotes(:,:,3);
A = reshape(tableNotes(:,:,3),1,[]);
g=findClosest(A, indicemax_freq);
h=mod(g,12);
if (indicemax_freq<63.5)
    octave=1;
end
if (indicemax_freq>63.5 && indicemax_freq<127)
    octave=2;
end
if (indicemax_freq>127 && indicemax_freq<244.5)
    octave=3;
end
if (indicemax_freq>244.5 && indicemax_freq<508)
    octave=4;
end
if (indicemax_freq>508 && indicemax_freq<1014)
octave=5;
end
if (indicemax_freq>1014 && indicemax_freq<2000)
octave=6;
end
if (indicemax_freq>2000)
octave=7;
end

note=[tabNomNotes(h,:)  num2str(octave)];

end