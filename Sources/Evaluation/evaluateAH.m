function [confTons, confOctaves]=evaluateAH(filename, notesDet)
%evaluateAH.m
%
%   USAGE:   
%       [confTons, confOctaves]=evaluateAH(filename, notesDet)
%   ATTRIBUTS:    
%       confTons: Matrice de confusion des tons
%       confOctaves: Matrice de confusion des octaves
%   
%       filename: nom et chemin absolu du fichier où sont stockées les
%       valeurs attendues
%       notesDet:   notes détectées par l'application
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


confTons = eye(12,12)*10;
confOctaves = zeros(5,5);

%% Lecture des données attendues
tempo=str2num(fgets(FID)); %tempo
nbNotesExp=str2num(fgets(FID)); % Nombre de notes attendues

for k=1:nbNotesExp
   %Lecture d'une note 
end

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

disp('All OK');

end