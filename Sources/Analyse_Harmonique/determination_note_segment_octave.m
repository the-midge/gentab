function [ note ] = determination_note_segment_octave( segment , Fs)
%determination_note_segment.m
%   USAGE:
%       [ note ] = determination_note_segment_octave( segment , Fs)
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

tab_nom_notes=['E '; 'F '; 'F#'; 'G '; 'G#'; 'A '; 'A#'; 'B '; 'C '; 'C#'; 'D '; 'D#'];

%% Calcul de la fft sur le segment
if(length(segment)<2^19)
    seg_fft_win=fft(segment.*blackman(length(segment)), 2^15);  %Permet d'assurer une précision suffisante
    %   TODO: rendre ce paamètre de fft dépendant de la longueur du segment
    %   (mais toujours une puissance de 2).
else
    seg_fft_win=fft(segment.*blackman(length(segment)));
end
% Manipulation de la fft pour l'avoir sous la bonne forme
seg_fft_win=abs(seg_fft_win(1:(length(seg_fft_win)/2)));

%% Génération d'un filtre pour la pondération de chaque note
tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)

% Crée à partir de table note, 12 'filtres' dans le domaine fréquentiel, un
% pour chaque note (A-G). On se réfère à eux pour la comparaison
filtre=generateGaussian(length(abs(seg_fft_win)), Fs, tableNotes); 
%Vecteur de la fréquence pour cette fft spécifiquement
f=((Fs/(length(seg_fft_win)):(Fs/(length(seg_fft_win))):Fs/2));

%Visualisation
% plot(f, [seg_fft_win filtre]); legend('FFT du segment', tab_nom_notes);
% %legend non testé


%% Projection de la fft sur le filtre généré. 
% Mets en évidence les pics à des fréquences de note normalisées.
bornes_octaves=sort([tableNotes(1,:,2) tableNotes(1,end,4)])'; % sélectionne les bords des lobes gaussiens de tous les filtres
ind_bornes_octaves=findClosest(f, bornes_octaves);

projection_win= filtre.*repmat(seg_fft_win, 1, 12);

for i=1:length(ind_bornes_octaves)-1
    sum_projection_win(:,i)=sum(projection_win(ind_bornes_octaves(i):ind_bornes_octaves(i+1),:),1)';
end

%% Visualisation
%sum_projection_win=sum(projection_win,1)';
% figure
% mesh(sum_projection_win');
% set(gca, 'XTick',1:12, 'XTickLabel',{'E ' 'F ' 'F#' 'G ' 'G#' 'A ' 'A#' 'B ' 'C ' 'C#' 'D ' 'D#'})

%% Sélection du résultat maximum de cette projection.
% TODO: à améliorer

[valMax indice_note_jouee]=max(sum(sum_projection_win,2)); %N'est valable que pour 1 note jouée à la fois
projection_deroulee=sum_projection_win(:);
ind_compoTonale=find(projection_deroulee>(mean(projection_deroulee)+std(projection_deroulee)));
octaveFondamentale=floor((ind_compoTonale(1)+3)/12)+2;    %Cette mise à l'échelle est basée sur le fait que la première note possible est un E2.


note=[tab_nom_notes(mod(indice_note_jouee,12)+1,:) num2str(octaveFondamentale)];


end