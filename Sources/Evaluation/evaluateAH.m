function [confTons, confOctaves]=evaluateAH(filename, noteDet)
%evaluateAH.m
%
%   USAGE:   
%       [confTons, confOctaves]=evaluateAH(filename, noteDet)
%   ATTRIBUTS:    
%       confTons: Matrice de confusion des tons
%       confOctaves: Matrice de confusion des octaves
%   
%       filename: nom et chemin absolu du fichier où sont stockées les
%       valeurs attendues
%       noteDet:   notes détectées par l'application
%    
%   DESCRIPTION:
%       Ce script evalue l'analyse harmonique des onsets en lisant les données attendues dans
%       le  fichier expected.txt
%       N.B: Une note est composé d'un ton et d'une octave
%
%   BUT:   
%       Fournir des indicateurs de la performances des algorithmes
%       d'analyse harmonique
%       Indicateurs:
%       *   Matrice de confusion 12x12 tons attendues vs. tons détectées
%           (cette matrice ne tient pas compte des octaves détectées)
%       *   Matrice de confusion 5x5 octaves attendues vs. octaves
%       détectées
%       *   Histogramme des écarts entre le tons attendue et le ton détecté


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


confTons = zeros(13,13);
confOctaves = zeros(5,5);

%% Lecture des données attendues
tempo=str2num(fgets(FID)); %tempo
nbNotesExp=str2num(fgets(FID)); % Nombre de notes attendues

for k=1:nbNotesExp
   %Lecture d'une note
   line = fgets(FID);
   entiers = sscanf(line, '%d');
   onset = entiers(1);  %onset attendu
   duree = entiers(2);  % durée attendue
   
   characteres = sscanf(line, '%c');
   octave = str2num(characteres(end-2)); % octave attendue
   
   rowNames = {'R ', 'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};   % temp
   for j=1:13
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
fclose(FID);
%% Construction des matrices de confusions
indiceDet = 0;
indiceExp = 0;
detInExp = 0;
expInDet = 0;

for k=1:length(noteDet)
    onsetsDet(k)=noteDet(k).indice;
end

tonsAComparer=[];
octavesAComparer=[];
confOctaves=zeros(6);
confTons=zeros(13);
k=1;
while indiceDet < length(noteDet)
    if indiceDet < length(noteDet)
        indiceDet=indiceDet+1;
    end   
    
    newDetInExp = findClosest(onsetsExp, noteDet(indiceDet).indice);
    indiceExp = newDetInExp;
    newExpInDet = findClosest(onsetsDet, noteExp(indiceExp).indice);
   
   if newExpInDet-newDetInExp == expInDet-detInExp && newExpInDet> expInDet
        tonsAComparer(k,:)=[noteDet(indiceDet).ton noteExp(indiceExp).ton];
        octavesAComparer(k,:)=[noteDet(indiceDet).octave noteExp(indiceExp).octave];
        k=k+1;
        confTons(noteDet(indiceDet).ton,noteExp(indiceExp).ton) = confTons(noteDet(indiceDet).ton,noteExp(indiceExp).ton) + 1;
        confOctaves(noteDet(indiceDet).octave,noteExp(indiceExp).octave) = confOctaves(noteDet(indiceDet).octave,noteExp(indiceExp).octave) + 1;
    end
    detInExp = newDetInExp;
    expInDet = newExpInDet;
end

%%   Affichage de la matrice de confusion des tons
figure(2)
mask=eye(13);
plotconfusion(mask(tonsAComparer(:,2),:)', mask(tonsAComparer(:,1),:)');
PTFS = nnplots.title_font_size;
titleStyle = {'fontweight','bold','fontsize',PTFS};
xlabel('Tons Cibles',titleStyle{:});
ylabel('Tons Détectés',titleStyle{:});
title(['Matrice de confusion des tons'],titleStyle{:});
ax = gca;
set(ax, 'XTickLabel', {'R ', 'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'});
set(ax, 'YTickLabel', {'R ', 'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'});

figure(3)
mask=[0 zeros(1,5); zeros(5,1), eye(5)];
plotconfusion(mask(octavesAComparer(:,2),:)', mask(octavesAComparer(:,1),:)');
PTFS = nnplots.title_font_size;
titleStyle = {'fontweight','bold','fontsize',PTFS};
xlabel('Octaves Cibles',titleStyle{:});
ylabel('Octaves Détectés',titleStyle{:});
title(['Matrice de confusion des octaves'],titleStyle{:});

%%   Affichage de la matrice de confusion des tons (texte)
% disp('Matrice de confusion des tons');
% rowNames = {'R ', 'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};
% firstRow = '';
% for k = 1:length(rowNames)
%     firstRow = [firstRow, ' ', rowNames{k}];
% end
% disp(['    ', firstRow]);
% for k = 1:length(rowNames)
%     disp([rowNames{k}, '   ', num2str(confTons(k,:))]);
% end
% 
% %% Affichage de la matrice de confusion des octaves
% disp('Matrice de confusion des octaves');
% disp(['    ', num2str(2:6)]);
% for k = 2:6
%     disp([num2str(k), '   ', num2str(confOctaves(k-1,:))]);
% end
% 
% disp(['Taux de succès tons: ' num2str(sum(diag(confTons))/sum(sum(confTons))*100) '%']);
% disp(['Taux de succès octaves: ' num2str(sum(diag(confOctaves))/sum(sum(confOctaves))*100) '%']);
end