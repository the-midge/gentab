function [txFDetection, txDetectionManquante, txReussite, ecartMoyen]=evaluateOD(filename, noteDet)
%evaluateOD.m
%
%   USAGE:   
%       [txFDetection, txDetectionManquante, txErreur, ecartMoyen]=evaluateOD(filename, noteDet)
%   ATTRIBUTS:    
%   
%       txFDetection: Taux de fausse détection
%       txDetectionManquante:   Taux de détection manquante
%       txReussite: Taux de réussite (100% - deux taux cités plus haut)
%       ecartMoyen: écart moyen entre deux onsets correctement détectés
%    
%   DESCRIPTION:
%       Ce script evalue l'onset détection en lisant les données attendues dans
%       le  fichier expected.txt
%
%   BUT:   
%       Fournir des indicateurs de la performances des algorithmes
%       d'onset detection
%       Indicateurs:
%       *   txFDetection: Taux de fausse détection = (nombre de détection
%       excédentaires/nombre de détections attendues)
%       *   txDetectionManquante:   Taux de détection manquante = (nombre de
%       détections manquées/nombre de détections attendues)
%       *   txReussite: 100% - Somme des deux taux de détection précédents
%       *   ecartMoyen: écart moyen entre deux onsets correctement détectés

%% Vérification sur l'argument filename
filename = strrep(filename, '\', '/');  % Conversion Win -> linux

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
%% Calcul des indicateurs
nbOnsetsExcedentaires = 0;
nbOnsetsManquants = 0;
ecarts=[];
indiceDet = 0;
indiceExp = 0;
detInExp = 0;
expInDet = 0;
    
for k=1:length(noteDet)
    onsetsDet(k)=noteDet(k).indice;
end

while indiceDet < length(noteDet)
    if indiceDet < length(noteDet)
        indiceDet=indiceDet+1;
    end   
    
    newDetInExp = findClosest(onsetsExp, noteDet(indiceDet).indice);
    indiceExp = newDetInExp;
    newExpInDet = findClosest(onsetsDet, noteExp(indiceExp).indice);
    
    if newExpInDet-newDetInExp == expInDet-detInExp && newExpInDet> expInDet
        ecarts(indiceExp)=abs(noteExp(indiceExp).indice-noteDet(indiceDet).indice);
    elseif newDetInExp == detInExp
        nbOnsetsExcedentaires = nbOnsetsExcedentaires+1;
    elseif indiceExp-detInExp >1
        nbOnsetsManquants = nbOnsetsManquants+1;
    end
    
    detInExp = newDetInExp;
    expInDet = newExpInDet;
end


nbNotesExp=nbNotesExp-1;

if indiceExp-nbNotesExp <0
    nbOnsetsManquants = nbOnsetsManquants+(nbNotesExp-indiceExp);
end

txFDetection = nbOnsetsExcedentaires/nbNotesExp*100;
txDetectionManquante = nbOnsetsManquants/nbNotesExp*100;
txReussite = 100-txFDetection-txDetectionManquante;
ecartMoyen = mean(ecarts);

end