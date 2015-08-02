function [ note ] = determination_note_segment( segment , Fs)
%determination_note_segment.m
%   USAGE:
%       [ note ] = determination_note_segment( segment , Fs)
%
%       TODO:
%           Mettre en place la comme de la projection uniquement sur une
%           octave (La à La) pour constitué la carte 2 dimension de la note
%           (octave x notes). On pourrait ainsi déterminé les composantes
%           non-fondamentales et l'octave de la note.


% Calcul de la fft sur le segment
if(length(segment)<2^19)
    seg_fft_win=fft(segment.*blackman(length(segment)), 2^15);  %Permet d'assurer une précision suffisante
else
    seg_fft_win=fft(segment.*blackman(length(segment)));
end
seg_fft_win_replie=seg_fft_win(1:(length(seg_fft_win)/2))+seg_fft_win(length(seg_fft_win):-1:(length(seg_fft_win)/2+1));
seg_fft_win_replie=abs(seg_fft_win_replie);

% génération d'un filtre pour la pondération de chaque note
filtre=generateGaussian(length(abs(seg_fft_win_replie)), Fs);

%Vecteur de la fréquence pour cette fft spécifiquement
f=((Fs/(length(seg_fft_win)):(Fs/(length(seg_fft_win))):Fs/2));

%Visualisation
%plot(f, [seg_fft_win_replie filtre])

% Projection de la fft sur le filtre généré. Mets en évidence les pics à
% des fréquences de note normalisées.
projection_win= filtre.*repmat(seg_fft_win_replie, 1, 12);
sum_projection_win=sum(projection_win,1)';

%Sélection du résultat maximum de cette projection.
[valMax indice_note_jouee]=max(sum_projection_win); %N'est valable que pour 1 note jouée à la fois


tab_nom_notes=['E '; 'F '; 'F#'; 'G '; 'G#'; 'A '; 'A#'; 'B '; 'C '; 'C#'; 'D '; 'D#'];
note=tab_nom_notes(indice_note_jouee,:);


end

