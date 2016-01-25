function [confTons, confOctaves]=evaluateAH(filename, notesDet, display)
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

if nargin == 2
    display = 1;
end
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
       onsetsExp(k)=onset;
       clear ton octave characteres;
   end
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

silences=[];
onsetsDet=[];
for k=1:length(notesDet)
    if notesDet(k).ton~=1 % Cette note est un silence
        onsetsDet=[onsetsDet notesDet(k).indice];
    else
        silences=[silences; k];
    end
end

tonsAComparer=[];
octavesAComparer=[];
confOctaves=zeros(6);
confTons=zeros(13);
k=1;
l=1;
while indiceDet < length(notesDet)
    if indiceDet < length(notesDet)
        indiceDet=indiceDet+1;
    end   
    
    newDetInExp = findClosest(onsetsExp, notesDet(indiceDet).indice);
    indiceExp = newDetInExp;
    newExpInDet = findClosest(onsetsDet, noteExp(indiceExp).indice);
   
   if newExpInDet-newDetInExp == expInDet-detInExp && newExpInDet> expInDet
       notesDetUtilisees = [];
       noteExpUtilisees = [];
       detTon=notesDet(indiceDet).ton;
       expTon=noteExp(indiceExp).ton;
       detOctave=notesDet(indiceDet).octave;
       expOctave=noteExp(indiceExp).octave;
       % 1. Recherche des résultats exact
        for m=1:length(detTon)
            if find(find(detTon(m)==expTon)==find(detOctave(m)==expOctave))
                % On a trouvé un résultat exact
                idxExpTrouve=find(detTon(m)==expTon);
                idxExpTrouve=idxExpTrouve(find(find(detTon(m)==expTon)==find(detOctave(m)==expOctave)));
                tonsAComparer(l,:)=[notesDet(indiceDet).ton(m) noteExp(indiceExp).ton(idxExpTrouve)];
                octavesAComparer(l,:)=[notesDet(indiceDet).octave(m) noteExp(indiceExp).octave(idxExpTrouve)];
                l=l+1;
                notesDetUtilisees=[notesDetUtilisees;m];
                noteExpUtilisees=[noteExpUtilisees;idxExpTrouve];
            end
        end
       %2. Recherche même ton parmi les restant
       for m=1:length(detTon)
            if ~length(find(m==notesDetUtilisees))
                idxExpTrouve=find(detTon(m)==expTon);   % Si on trouve pour detTon(m) un ton qui correspond dans exp
                if length(idxExpTrouve)>0
                    idxExpTrouve(idxExpTrouve==noteExpUtilisees)=[];      % On enlève les indices qui sont déjà utilisés
                end
                if length(idxExpTrouve)>0  % S'il en reste...
                    distances= abs(detOctave(m)-expOctave(idxExpTrouve));
                    [~, idxMeilleurCand]=min(distances);    % Retourne l'indice du premier minimum (même s'il y a des égalité)
                    idxExpTrouve=idxExpTrouve(idxMeilleurCand); % On ne garde que celui là
                    tonsAComparer(l,:)=[notesDet(indiceDet).ton(m) noteExp(indiceExp).ton(idxExpTrouve)];
                    octavesAComparer(l,:)=[notesDet(indiceDet).octave(m) noteExp(indiceExp).octave(idxExpTrouve)];
                    l=l+1;
                    notesDetUtilisees=[notesDetUtilisees;m];
                    noteExpUtilisees=[noteExpUtilisees;idxExpTrouve];
                end
            end
       end
        %3. Associer les éléments restants entre eux en minimisant les
        %distances dans les matrices de confusions
        for m=1:length(detTon)
            if ~length(find(m==notesDetUtilisees))
                idxExpRestants=1:length(expTon);
                idxExpRestants(noteExpUtilisees)=[];
            	distances= abs(detOctave(m)-expOctave(idxExpRestants))+abs(detTon(m)-expTon(idxExpRestants));
                [~, idxMeilleurCand]=min(distances);    % Retourne l'indice du premier minimum (même s'il y a des égalité)
                idxExpTrouve=idxExpRestants(idxMeilleurCand); % On ne garde que celui là
                tonsAComparer(l,:)=[notesDet(indiceDet).ton(m) noteExp(indiceExp).ton(idxExpTrouve)];
                octavesAComparer(l,:)=[notesDet(indiceDet).octave(m) noteExp(indiceExp).octave(idxExpTrouve)];
                l=l+1;
                notesDetUtilisees=[notesDetUtilisees;m];
                noteExpUtilisees=[noteExpUtilisees;idxExpTrouve];
            end
        end
        %4. Associer les éléments détecté restants à des silences
        for m=1:length(detTon)
            if ~length(find(m==notesDetUtilisees))
                tonsAComparer(l,:)=[notesDet(indiceDet).ton(m) 0];
                octavesAComparer(l,:)=[notesDet(indiceDet).octave(m) 0]; % Erreur possible ici car on met une octave à0
                notesDetUtilisees=[notesDetUtilisees;m];
                l=l+1;
            end
        end
%         tonsAComparer(l,:)=[notesDet(indiceDet).ton noteExp(indiceExp).ton];
%         octavesAComparer(l,:)=[notesDet(indiceDet).octave noteExp(indiceExp).octave];
        k=k+1;
%         confTons(notesDet(indiceDet).ton,noteExp(indiceExp).ton) = confTons(notesDet(indiceDet).ton,noteExp(indiceExp).ton) + 1;
%         confOctaves(notesDet(indiceDet).octave,noteExp(indiceExp).octave) = confOctaves(notesDet(indiceDet).octave,noteExp(indiceExp).octave) + 1;
    end
    detInExp = newDetInExp;
    expInDet = newExpInDet;
end

%%   Affichage de la matrice de confusion des tons
if display
    figure(2)
    mask=eye(13);
    plotconfusion(mask(tonsAComparer(:,2)+1,:)', mask(tonsAComparer(:,1)+1,:)');
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
    octavesAComparer(octavesAComparer==0)=1;
    plotconfusion(mask(octavesAComparer(:,2),:)', mask(octavesAComparer(:,1),:)');
    PTFS = nnplots.title_font_size;
    titleStyle = {'fontweight','bold','fontsize',PTFS};
    xlabel('Octaves Cibles',titleStyle{:});
    ylabel('Octaves Détectés',titleStyle{:});
    title(['Matrice de confusion des octaves'],titleStyle{:});
end
mask=eye(13);
[~, confTons, ~, ~]=confusion(mask(tonsAComparer(:,2)+1,:)', mask(tonsAComparer(:,1)+1,:)');
mask=[0 zeros(1,5); zeros(5,1), eye(5)];
[~, confOctaves, ~, ~]=confusion(mask(octavesAComparer(:,2),:)', mask(octavesAComparer(:,1),:)');
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