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


confTons = zeros(12,12);
confOctaves = zeros(5,5);

%% Lecture des données attendues
tempo=str2num(fgets(FID)); %tempo
nbNotesExp=str2num(fgets(FID)); % Nombre de notes attendues

for k=1:nbNotesExp
   %Lecture d'une note
   line = fgets(FID);
   entiers = sscanf(line, '%d');
   noteExp(k,1) = entiers(1);  %onset attendu
   noteExp(k,2) = entiers(2);  % durée attendue
   
   characteres = sscanf(line, '%c');
   noteExp(k,4) = str2num(characteres(end-2)); % octave attendue
   
   rowNames = {'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};   % temp
   for j=1:12
       if strcmp(rowNames{j}, characteres(end-4:end-3)) ~= 0
          noteExp(k,3)=j; % note attendue
       end
   end
end

if nbNotesExp~=length(noteExp)
    error('Erreur de lecture: le fichier ne contient pas le nombre de notes indiquées');
end

%% Construction des matrices de confusions
indiceDet = 0;
indiceExp = 0;
detInExp = 0;
expInDet = 0;
while indiceDet < length(noteDet)
    if indiceDet < length(noteDet)
        indiceDet=indiceDet+1;
    end   
    
    newDetInExp = findClosest(noteExp(:,1), noteDet(indiceDet,1));
    indiceExp = newDetInExp;
    newExpInDet = findClosest(noteDet(:,1), noteExp(indiceExp,1));
    
    if newExpInDet-newDetInExp == expInDet-detInExp && newExpInDet> expInDet
        confTons(noteDet(indiceDet, 3),noteExp(indiceExp, 3)) = confTons(noteDet(indiceDet, 3),noteExp(indiceExp, 3)) + 1;
        confOctaves(noteDet(indiceDet, 4),noteExp(indiceExp, 4)) = confOctaves(noteDet(indiceDet, 4),noteExp(indiceExp, 4)) + 1;
    end
    detInExp = newDetInExp;
    expInDet = newExpInDet;
end

% indiceDet=1;
% for indiceExp=1:min([length(noteDet) length(noteExp)])     
%     if noteDet(findClosest(noteDet(:,1), noteExp(indiceExp,1)),1)== noteExp(findClosest(noteExp(:,1), noteDet(indiceDet,1)),1)
%        disp('ok'); 
%        indiceDet=indiceDet+1;
%     else
%         attenduDansTrouve = findClosest(noteDet(:,1), noteExp(indiceExp,1));
%         trouveDansAttendu = findClosest(noteExp(:,1), noteDet(indiceDet,1));
%         if attenduDansTrouve < trouveDansAttendu
%             disp('Manque une note');
%         else
%             disp('Une note de trop');
%             indiceDet=indiceDet+2;
%         end            
%     end
%     confTons(noteDet(indiceDet-1, 3),noteExp(indiceExp, 3)) = confTons(noteDet(indiceDet-1, 3),noteExp(indiceExp, 3)) + 1;
%     confOctaves(noteDet(indiceDet-1, 4),noteExp(indiceExp, 4)) = confOctaves(noteDet(indiceDet-1, 4),noteExp(indiceExp, 4)) + 1;
% end

%%   Affichage de la matrice de confusion des tons
disp('Matrice de confusion des tons');
rowNames = {'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};
firstRow = '';
for k = 1:length(rowNames)
    firstRow = [firstRow, ' ', rowNames{k}];
end
disp(['    ', firstRow]);
for k = 1:length(rowNames)
    disp([rowNames{k}, '   ', num2str(confTons(k,:))]);
end

%% Affichage de la matrice de confusion des octaves
disp('Matrice de confusion des octaves');
disp(['    ', num2str(2:6)]);
for k = 2:6
    disp([num2str(k), '   ', num2str(confOctaves(k-1,:))]);
end

fclose(FID);
end