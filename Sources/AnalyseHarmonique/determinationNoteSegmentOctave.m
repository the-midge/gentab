function [ note ] = determinationNoteSegmentOctave( segment , Fs)
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
% Manipulation de la fft pour l'avoir sous la bonne forme
segFftWin=abs(segFftWin(1:(length(segFftWin)/2)));

%% Génération d'un filtre pour la pondération de chaque note
tableNotes=generateTableNotes(false);   % Génère dans une table, les fréquences des notes de E2 à E6 (plus d'autres infos)

% Crée à partir de table note, 12 'filtres' dans le domaine fréquentiel, un
% pour chaque note (A-G). On se réfère à eux pour la comparaison
filtre=generateGaussian(length(abs(segFftWin)), Fs, tableNotes); 
%Vecteur de la fréquence pour cette fft spécifiquement
f=((Fs/(length(segFftWin)):(Fs/(length(segFftWin))):Fs/2));

%Visualisation
% plot(f, [segFftWin filtre]); legend('FFT du segment', tabNomNotes);
% %legend non testé


%% Projection de la fft sur le filtre généré. 
% Mets en évidence les pics à des fréquences de note normalisées.
bornesOctaves=sort([tableNotes(1,:,2) tableNotes(1,end,4)])'; % sélectionne les bords des lobes gaussiens de tous les filtres
indBornesOctaves=findClosest(f, bornesOctaves);

projectionWin= filtre.*repmat(segFftWin, 1, 12);

for i=1:length(indBornesOctaves)-1
    sumProjectionWin(:,i)=sum(projectionWin(indBornesOctaves(i):indBornesOctaves(i+1),:),1)';
end

%% Visualisation
%sumProjectionWin=sum(projectionWin,1)';
% figure
% mesh(sumProjectionWin');
% set(gca, 'XTick',1:12, 'XTickLabel',{'E ' 'F ' 'F#' 'G ' 'G#' 'A ' 'A#' 'B ' 'C ' 'C#' 'D ' 'D#'})

%% Sélection du résultat maximum de cette projection.
% TODO: à améliorer

[valMax indiceNoteJouee]=max(sum(sumProjectionWin,2)); %N'est valable que pour 1 note jouée à la fois
projectionDeroulee=sumProjectionWin(:);
indCompoTonale=find(projectionDeroulee>(mean(projectionDeroulee)+std(projectionDeroulee)));
octaveFondamentale=floor((indCompoTonale(1)+3)/12)+2;    %Cette mise à l'échelle est basée sur le fait que la première note possible est un E2.

note=[tabNomNotes(mod(indiceNoteJouee-1,12)+1,:) num2str(octaveFondamentale)];

end