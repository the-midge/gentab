function [ note ] = determinationNoteSegmentOctave_YIN( segment , Fs)
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
% segment_col=segment';
% segment=[zeros(1,1000) segment_col zeros(1,1000)];
% y=length(segment)
% t=(0:y-1)/Fs;        % times of sampling instants
% subplot(4,1,1)
% plot(t,segment);
% title('signal normal')
% segment_delayed=[zeros(1,2000) segment_col ];
% subplot(4,1,2)
% plot(t,segment_delayed);
% title('signal retardé')
% segment_en_avance=[segment_col zeros(1,2000)];
% subplot(4,1,3)
% plot(t,segment_en_avance);
% title('signal en avance')
% 
% d=mean(abs(segment-segment_delayed));
% cheveigne=(segment-segment_en_avance).^2;
% subplot(4,1,4)
% plot(t,cheveigne);
% title('cheveigne')
% 
% if l==0
%   cheveigne_prim=1;
% else
%   cheveigne_prim=cheveigne(l)/(1/l*sum(cheveigne(1:l)));
% end



% maxlag = Fs/50;
% r = xcorr(segment, maxlag, 'coeff');
% t=(0:length(segment)-1)/Fs;        % times of sampling instants
% subplot(2,1,1);
% plot(t,segment);
% legend('Waveform');
% xlabel('Time (s)');
% ylabel('Amplitude');
% 
% d=(-maxlag:maxlag)/Fs;
% subplot(2,1,2);
% r=r(floor(length(r)/2):end);
% d2=(0:maxlag+1)/Fs;
% plot(d2,r);
% legend('Auto-correlation');
% xlabel('Lag (s)');
% ylabel('Correlation coef');

% difference function
[freq_f r]=yin(segment,Fs);
freq_f=str2num(freq_f);
% [mn, idx] = min(r.ap0);
% best=r.f0(idx);
% f0=2^best*440;

% segment_col=segment';
% % y=length(segment);
% % for i=1:y-100
% %     cheveigne(i)=(segment(i)-segment(i+100))*(segment(i)-segment(i+100));
% % end    
% %cheveigne=[cheveigne zeros(1,100)];  
% %figure(2), plot(t,cheveigne)
% segment=[segment_col zeros(1,10)];
% segment_delayed=[zeros(1,10) segment_col ];
% cheveigne=(segment-segment_delayed).^2;
% 
% plot(cheveigne)
% [indices]=find(cheveigne==0)
% 













  
  
tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)
tableNotes(:,:,3);
A = reshape(tableNotes(:,:,3),1,[]);
g=findClosest(A, freq_f);
if (mod(g,12)==0)
    h=12;
else   
h=mod(g,12);
end
if (freq_f>63.5 && freq_f<127)
    octave=2;
end
if (freq_f>127 && freq_f<244.5)
    octave=3;
end
if (freq_f>244.5 && freq_f<508)
    octave=4;
end
if (freq_f>508 && freq_f<1014)
octave=5;
end
if (freq_f>1014 && freq_f<2000)
octave=6;
end

note=[tabNomNotes(h,:)  num2str(octave)];

end