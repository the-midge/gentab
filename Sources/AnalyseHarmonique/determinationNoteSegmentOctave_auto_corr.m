function [ note ] = determinationNoteSegmentOctave_auto_corr( segment , Fs)
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
maxlag = Fs/50;
r = xcorr(segment, maxlag, 'coeff');

  t=(0:length(segment)-1)/Fs;        % times of sampling instants
     subplot(2,1,1);
     plot(t,segment);
     legend('Waveform');
     xlabel('Time (s)');
     ylabel('Amplitude');

     d=(-maxlag:maxlag)/Fs;
     subplot(2,1,2);
     plot(d,r);
     legend('Auto-correlation');
     xlabel('Lag (s)');
     ylabel('Correlation coef');
     

ms2=floor(Fs/1500);  
ms20=floor(Fs/80);  
% half is just mirror for real signal
r=r(floor(length(r)/2):end);
[maxi,idx]=max(r(ms2:ms20));
f0 = Fs/(ms2+idx-1);

% %% Recherche de la fréquence la plus proche dans la table de notes
                                                  
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