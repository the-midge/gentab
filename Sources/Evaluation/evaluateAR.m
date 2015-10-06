function [confDuree]=evaluateAR(filename, noteDet)
%evaluateAR.m
%
%   USAGE:   
%       [confDuree]=evaluateAR(filename, noteDet)
%   ATTRIBUTS:    
%       confDuree: Matrice de confusion des durées de notes
%   
%       filename: nom et chemin absolu du fichier où sont stockées les
%       valeurs attendues
%       noteDet:   notes détectées par l'application
%    
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


confDuree = zeros(16,16);

%% Lecture des données attendues
tempo=str2num(fgets(FID)); %tempo
nbNotesExp=str2num(fgets(FID)); % Nombre de notes attendues

for k=1:nbNotesExp
   %Lecture d'une note
   line = fgets(FID);
   entiers = sscanf(line, '%d');
   noteExp(k,1) = entiers(1);  %onset attendu
   noteExp(k,2) = entiers(2);  % durée attendue
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
        confDuree(noteDet(indiceDet, 2),noteExp(indiceExp, 2)) = confDuree(noteDet(indiceDet, 2),noteExp(indiceExp, 2)) + 1;
    end
    detInExp = newDetInExp;
    expInDet = newExpInDet;
end

%%   Affichage de la matrice de confusion des durees
disp('Matrice de confusion des durees');
disp(['    ', num2str(1:16)]);
for k = 1:16
    disp([num2str(k), '   ', num2str(confDuree(k,:))]);
end

%% Affichage de l'histogramme des écarts
toeplitz(-15:15);
toeplitzMat = ans(1:16,16:end);
for k=-15:15
    totalAttendu = sum(confDuree');
    histogramme(k+16)=sum(confDuree(find(toeplitzMat==k)));
end

bar((-15:15),histogramme);
axis([-15 15 0 max(histogramme)]);

fclose(FID);
end