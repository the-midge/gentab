function [ note ] = determinationNoteSegmentOctave_Harmonic_Product_Spectrum( segment , Fs)
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
    segFftWin=fft(segment.*blackman(length(segment)), 2^15);  %Permet d'assurer une précision suffisante
    %   TODO: rendre ce paamètre de fft dépendant de la longueur du segment
    %   (mais toujours une puissance de 2).
else
    segFftWin=fft(segment.*blackman(length(segment)));
end
  
% lissage de la transformée de Fourier
% h=800;
% degreLissage=round(Fs/h/10);
% segFftWin=filtfilt(ones(degreLissage,1)/degreLissage, 1, segFftWin);
                                                  
% Manipulation de la fft pour l'avoir sous la bonne forme
y=length(segFftWin);
% axe_freq = (10:y/2-1-15380)*Fs/y;
% segFftWin=abs(segFftWin(11:(length(segFftWin)/2-15380)));
axe_freq = (0:y/2-1)*Fs/y;
segFftWin=abs(segFftWin(1:(length(segFftWin)/2)));
%figure,plot(axe_freq,segFftWin)
                                                  
hps1=downsample(segFftWin,1);
hps2=downsample(segFftWin,2);
hps3=downsample(segFftWin,3);
hps4=downsample(segFftWin,4);
hps5=downsample(segFftWin,5);
s = [];

for i=1:length(hps5)
      Product= hps1(i)*hps2(i)*hps3(i)*hps4(i)*hps5(i);
      s(i)=[Product];
end

[m,n]=findpeaks(s, 'SORTSTR', 'descend');
Maximum = n(1);

%try fix octave error
% CorrectFactor = 0.986;
% threshold = 0.2;
% if (s(n(1)) * 0.5) > (s(n(2))) %& ( ( m(2) / m(1) ) > threshold )
% 
%     Maximum  = n(length(n));
% 
% end


% Sélectionner le peak en dessous de celui choisi, test si il est environ
% égal à 1/2 fois le peak choisi et que le ratio en amplitude est au dessus
% d'un seuil (0,2 pour 5 harmoniques), alors prendre le peak d'octave n-1

% peak_amp_max=m(1);
% peak_amp_under_max=m(2);
% ratio=m(2)/m(1);
% if (peak_amp_max/2.5<peak_amp_under_max && peak_amp_under_max<peak_amp_max/0.2 && ratio>0.4)
%     tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)
%     tableNotes(:,:,3);
%      B = reshape(tableNotes(:,:,3),1,[]);
%      z=findClosest(B, indicemax_freq);
%      if z>=12
%      indicemax_freq=B(z-12);
%      end
% end



% Recherche des maximums de la fft 

indicemax_freq=Maximum*Fs/y;
if indicemax_freq<81
    indicemax_freq=indicemax_freq*2;
end


% %% Recherche de la fréquence la plus proche dans la table de notes
                                                  
tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)
tableNotes(:,:,3);
A = reshape(tableNotes(:,:,3),1,[]);
g=findClosest(A, indicemax_freq);


h=mod(g,12);
if mod(g,12)==0
    h=12;
end
if (indicemax_freq>tableNotes(9,1,2)/2 && indicemax_freq<tableNotes(9,1,2))
    octave=2;
end
if (indicemax_freq>tableNotes(9,1,2) && indicemax_freq<tableNotes(9,2,2))
    octave=3;
end
if (indicemax_freq>tableNotes(9,2,2) && indicemax_freq<tableNotes(9,3,2))
    octave=4;
end
if (indicemax_freq>tableNotes(9,3,2) && indicemax_freq<tableNotes(9,4,2))
octave=5;
end
if (indicemax_freq>tableNotes(9,4,2) && indicemax_freq<tableNotes(end, end,4))
octave=6;
end
if (indicemax_freq>tableNotes(end, end,4))
octave=7;
end

note=[tabNomNotes(h,:)  num2str(octave)];

% [absc,~]=findpeaks(segFftWin, 'SORTSTR', 'descend');
% max=absc(1);
% seuil1=0.8*max;
% [seuil]=seuil1.*ones(size(axe_freq));
% [pks_amp,pks_abs]=findpeaks(segFftWin,Fs,'MinPeakHeight',seuil1,'NPeaks',4);
% if(size(pks_amp,1)>=2)
%    indicemax_freq=pks_abs(2)*1000*Fs/y*44.1033872;
% end
%figure, plot(axe_freq,[segFftWin seuil']);

end