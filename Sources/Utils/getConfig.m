function [ applicationPath, FilesFolder ,EvaluationFolder] = getConfig(~)
    filename = '../config.txt';
    if ~exist(filename, 'file');
        error(strcat('[ERREUR] Le fichier ', filename, ' n''existe pas dans ', path));
    end
    % Ouverture du fichier
    FID=fopen(filename, 'r');
    if(FID==-1)
        error('Impossible d''ouvrir le fichier');
    end
    applicationPath = fgets(FID);
    FilesFolder = fgets(FID);
EvaluationFolder=fgets(FID);
    fclose(FID);
end

