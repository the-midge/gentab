function [tempoExp, x, Fs]=loadTrain2004data(filename)
%loadTrain2004data.m
%
%   USAGE:   
%       [tempoExp, x, Fs]=loadTrain2004data(nEchantillon)
%   ATTRIBUTS:    
%       nEchantillon: Numéro de l'échantillon définissant le morceau:
%       nEchantillon = 6 => train6.wav et train6.txt
%   
%       tempo: Tempo attendu lu dans l'annotation.
%       x: extrait audio passé en mono.
%       Fs: fréquence d'échantillonnage de l'audio.
%   DESCRIPTION:
%       Cette fonction extrait l'annotation d'un morceau de la base de données
%       ismir2006 tempo extraction. Il renvoie également le morceau audio.
    path = 'D:\mirex-2004'; %Chemin absolu utilisable uniquement par Martin.
    
    extensionAudio = '.wav';
    extensionAnnotation = '.bpm';
    
    fileAudio = strcat(path, '\', filename, extensionAudio);
    fileAnnotation = strcat(path, '\', filename, extensionAnnotation);
    
    if ~isdir(path)
        error(strcat('[ERREUR] Le dossier ', path, ' n''existe pas.'));
    end

    if ~exist(fileAnnotation, 'file');
        error(strcat('[ERREUR] Le fichier ', fileAnnotation, ' n''existe pas dans ', path));
    end
    if ~exist(fileAudio, 'file');
        error(strcat('[ERREUR] Le fichier ', fileAnnotation, ' n''existe pas dans ', path));
    end

    %% Lecture des annotations
    % Ouverture du fichier
    FID=fopen(fileAnnotation, 'r');
    if(FID==-1)
        error('Impossible d''ouvrir le fichier');
    end
    line = fgets(FID);
    data=sscanf(line, '%f');
    tempoExp = data(1);
    fclose(FID);
    
    %% Lecture du fichier audio
    [x,Fs]=audioread(fileAudio);
end
