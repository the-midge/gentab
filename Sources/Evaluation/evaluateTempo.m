function [ecartTempo, tempoExp]=evaluateTempo(filename, tempo)
%evaluateTempo.m
%
%   USAGE:   
%       [ecartTempo, tempoExp]=evaluateTempo(filename, tempo)
%   ATTRIBUTS:    
%       ecartTempo: écart en % du tempo
%
%       filename: nom et chemin absolu du fichier où sont stockées les
%       valeurs attendues
%       tempo: tempo détecté par l'application
%
%   DESCRIPTION:
%       Ce script evalue le tempo détecté en lisant les données attendues dans
%       le  fichier expected.txt
%
%   BUT:   
%       Fournir des indicateurs de la performances des algorithmes
%       d'analyse harmonique
%       Indicateurs:
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
%%

ecartTempo = (tempoExp-tempo)/tempoExp*100;
% disp('Écart du tempo:');
% disp([num2str(ecartTempo) ' %']);
% if(ecartTempo ~= 0)
%     disp(['Tempo attendu: ' num2str(tempoExp) ' au lieu de ' num2str(tempo)]);
% end

fclose(FID);
end