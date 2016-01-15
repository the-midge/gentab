function [ notesMIDI, onsetsExp ] = extractNotes( filename )
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
   idxNote=regexpi(characteres, '[A-G][ #][1-9]');
    
   if idxNote>0
       for i=1:length(idxNote)
           octave(i) = str2num(characteres(idxNote(i)+2)); % octave attendue

           rowNames = {'R ', 'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};   % temp
           for j=1:13
               if strcmp(rowNames{j}, characteres(idxNote(i):idxNote(i)+1)) ~= 0
                  ton(i)=j-1; % note attendue
               end
           end
       end
       if k==87
           info=0;
       end
       noteExp(k)=Note(onset, duree, ton, octave);
       notesMIDI(k)=noteExp(k).convertMIDI();
       onsetsExp(k)=onset;
       clear ton octave characteres;
   end
end

if nbNotesExp~=length(noteExp)
    error('Erreur de lecture: le fichier ne contient pas le nombre de notes indiquées');
end
fclose(FID);

end

