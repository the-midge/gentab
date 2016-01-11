function [confDurees, ecartTempo]=evaluateAR(filename, notesDet, tempo, display)
%evaluateAR.m
%
%   USAGE:   
%       [confDurees]=evaluateAR(filename, notesDet, tempo, display)
%   ATTRIBUTS:    
%       confDurees: Matrice de confusion des durées de notes
%       ecartTempo: écart en % du tempo
%
%       filename: nom et chemin absolu du fichier où sont stockées les
%       valeurs attendues
%       notesDet:   notes détectées par l'application
%       tempo: tempo détecté par l'application
%       display: affiche une un histogramme
%   DESCRIPTION:
%       Ce script evalue l'analyse rythmique des onsets en lisant les données attendues dans
%       le  fichier expected.txt
%       N.B: Une note est composé d'un ton et d'une octave
%
%   BUT:   
%       Fournir des indicateurs de la performances des algorithmes
%       d'analyse harmonique
%       Indicateurs:
%       *   Matrice de confusion 16x16 durées attendues vs. durées détectées
%       *   Histogramme des écarts entre la durée attendue et la durée
%       détectée
%       * écart en % du tempo

%% Vérification sur l'argument filename
filename = strrep(filename, '\', '/');  % Conversion Win -> linux
% if filename(end) ~= '/'
%     filename = [filename '/'];
% end
[path, file, extension]=fileparts(filename);
if ~isdir(path)
    error(strcat('[ERREUR] Le dossier ', path, ' n''existe pas.'));
end

if ~exist(filename, 'file');
    error(strcat('[ERREUR] Le fichier ', filename, ' n''existe pas dans ', path));
end


% Ouverture du fichier
FID=fopen(filename, 'r');
if(FID==-1)
    error('Impossible d''ouvrir le fichier');
end


confDurees = zeros(16,16);

%% Lecture des données attendues
tempoExp=str2num(fgets(FID)); %tempo
nbNotesExp=str2num(fgets(FID)); % Nombre de notes attendues

for k=1:nbNotesExp
   %Lecture d'une note
   line = fgets(FID);
   entiers = sscanf(line, '%d');
   onset = entiers(1);  %onset attendu
   duree = entiers(2);  % durée attendue
   
   characteres = sscanf(line, '%c');
   octave = str2num(characteres(end-2)); % octave attendue
   
   rowNames = {'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};   % temp
   for j=1:12
       if strcmp(rowNames{j}, characteres(end-4:end-3)) ~= 0
          ton=j; % note attendue
       end
   end
   noteExp(k)=Note(onset, duree, ton, octave);
   onsetsExp(k)=onset;
end

if nbNotesExp~=length(noteExp)
    error('Erreur de lecture: le fichier ne contient pas le nombre de notes indiquées');
end

%% Construction des matrices de confusions
indiceDet = 0;
indiceExp = 0;
detInExp = 0;
expInDet = 0;

silences=[];
onsetsDet=[];
for k=1:length(notesDet)
    if notesDet(k).ton~=1 % Cette note est un silence
        onsetsDet=[onsetsDet notesDet(k).indice];
    else
        silences=[silences; k];
    end
end

k=1;
dureesAComparer=[];
while indiceDet < length(notesDet)
    if indiceDet < length(notesDet)
        indiceDet=indiceDet+1;
    end   
    
    newDetInExp = findClosest(onsetsExp, notesDet(indiceDet).indice);
    indiceExp = newDetInExp;
    newExpInDet = findClosest(onsetsDet, noteExp(indiceExp).indice);
   
    if newExpInDet-newDetInExp == expInDet-detInExp && newExpInDet> expInDet
        if indiceDet<length(notesDet) % On n'évalue jamais la dernière note
            if ismember(indiceDet+1, silences)
                duree = notesDet(indiceDet).duree+notesDet(indiceDet+1).duree;
            else
                duree = notesDet(indiceDet).duree;
            end
            dureesAComparer(k,:)=[duree noteExp(indiceExp).duree];
            k=k+1;
            confDurees(duree,noteExp(indiceExp).duree) = confDurees(duree,noteExp(indiceExp).duree) + 1;
        end
    end
    detInExp = newDetInExp;
    expInDet = newExpInDet;
end

%%
figure(4)
mask=eye(16);
plotconfusion(mask(dureesAComparer(:,2),:)', mask(dureesAComparer(:,1),:)');
PTFS = nnplots.title_font_size;
titleStyle = {'fontweight','bold','fontsize',PTFS};
xlabel('Durées Cibles',titleStyle{:});
ylabel('Durées Détectés',titleStyle{:});
title(['Matrice de confusion des durees'],titleStyle{:});

% %%   Affichage de la matrice de confusion des durees
% disp('Matrice de confusion des durees');
% disp(['    ', num2str(1:length(confDurees))]);
% for k = 1:16
%     disp([num2str(k), '   ', num2str(confDurees(k,:))]);
% end

%% Affichage de l'histogramme des écarts
toeplitz(-15:15);
toeplitzMat = ans(1:16,16:end);
for k=-15:15
    totalAttendu = sum(confDurees');
    histogramme(k+16)=sum(confDurees(find(toeplitzMat==k)));
end

if display
    figure
    bar((-15:15),histogramme);
    axis([-15 15 0 max(histogramme)+1]);    
end

ecartTempo = (tempoExp-tempo)/tempoExp*100;
disp('Écart du tempo:');
disp([num2str(ecartTempo) ' %']);
if(ecartTempo ~= 0)
    disp(['Tempo attendu: ' num2str(tempoExp) ' au lieu de ' num2str(tempo)]);
end

disp(['Taux de succès durées: ' num2str(sum(diag(confDurees))/sum(sum(confDurees))*100) '%']);
fclose(FID);
end