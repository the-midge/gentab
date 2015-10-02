function [] = evaluateResults(filepath, varargin)
%   evaluateResults.m
%   USAGE:
%       [] = evaluateResults(filepath, notes, rythme)
%       [] = evaluateResults(filepath, notes)
%       [] = evaluateResults(filepath, sample$S1ndexOnsets)
%
%   ATTRIBUTS:
%       filepath:
%           Chemin relatif du fichier audio de test. Doit finir par '\'
%       notes:
%           Liste des notes reconnues. Format 'note|#/(espace)|octave' sans
%           séparateur
%       rythme:
%           Liste des durées de note reconnues. Format: cell array
%           verticale contenant le "nom" des durées de note.

%% Vérification sur l'argument filepath
filepath = strrep(filepath, '\', '/');  % Conversion Win -> linux
if filepath(end) ~= '/'
    filepath = [filepath '/'];
end
pattern = '/expected.txt';
if ~isdir(filepath)
    error(strcat('[ERREUR] Le dossier ', filepath, ' n''existe pas.'));
end
filename = strcat(filepath, pattern);
if ~exist(filename, 'file');
    error(strcat('[ERREUR] Le fichier ', pattern, ' n''existe pas dans ', filepath));
end
%% Vérification sur les autres arguments
% S'il y a 3 arguments, on vérifie qu'on respecte le premier format d'usage

evaluateAR = true;
evaluateAH = true;
    
if(nargin == 3)
    if(~ischar(varargin{1}))
        error('[ERREUR] L''argument ''notes'' n''a pas le bon format');
    end
    if(~iscell(varargin{2}))
        error('[ERREUR] L''argument ''notes'' n''a pas le bon format');
    end
    notesDet = varargin{1};
    rythmeDet = varargin{2};
elseif(nargin == 2)
    if(~ischar(varargin{1}) && ~iscell(varargin{1}) && ~isreal(varargin{1}))
        error('[ERREUR] Le second argument n''a pas le bon format');
    end
    % Si l'argument est composé de strings
    if  ischar(varargin{1})
        evaluateAR = false;
        notesDet = varargin{1};
    end
    if  iscell(varargin{1})
        evaluateAH = false;
        rythmeDet = varargin{1};
    end
    if (isreal(varargin{1}) && ~ischar(varargin{1}))
        evaluateAH = false;
        evaluateAR = false;
    end
end

if  (nargin == 2)
    if  size(notesDet, 2) ~= 3
        error('[ERREUR] L''argument ''notes'' n''a pas le bon format');
    end
end

% if(ischar(varargin{1}))
%     notesDet = varargin{1};
%     evaluateAH = true;
% elseif(isreal(varargin{1}))
%     notesDet = varargin{1};   % Il ne s'agit pas du tout des notes jouées mais le programme s'arretera avant de déclencher une erreur
%     evaluateAR = false;
%     evaluateAH = false;
% end


[notesExp, rythmeExp]=loadExpectedTXT(filename);

%% Évaluation du nombre d'onset détecté
nbOnsetExp=size(notesExp, 1);
nbOnsetDet=size(notesDet, 1);
[ onsetPerformance ] = evaluateOnsets(nbOnsetExp, nbOnsetDet);

if(~evaluateAR & ~evaluateAH)
    return;
end

%% Évaluation des notes détectées
if(evaluateAH)
    disp(' ');
    disp('Reconnaissance des notes (tons)');
    if(strcmp(notesDet, notesExp))  % Test si tout est parfait
        disp('GOOD!: 100%!');
    else
       notesDetDouble=convert2double(notesDet);           %Conversion numérique des mesures
       notesExpDouble=convert2double(notesExp);

       if(nbOnsetDet==nbOnsetExp)   %Cas où le nombre de ligne est le même
           pourcentageOctave=sum(notesDetDouble(:,3)==notesExpDouble(:,3))/length(notesExpDouble)*100;
           disp(['Détection des octaves = ' num2str(pourcentageOctave) '%.']);

           pourcentageFondamentales = sum((notesDetDouble(:,1)+notesDetDouble(:,2))==(notesExpDouble(:,1)+notesExpDouble(:,2)))/length(notesExpDouble)*100;
           disp(['Détection des notes = ' num2str(pourcentageFondamentales) '%.']);
       elseif(nbOnsetDet>nbOnsetExp)    % S'il y a des notes de détectées en trop
           notesOk=0;
           j=0;
           for(i=1:nbOnsetExp)  % Pour toutes les notes attendues
              if(notesDetDouble(i+j,3)==notesExpDouble(i,3) && (notesDetDouble(i+j,1)+notesDetDouble(i+j,2))==(notesExpDouble(i,1)+notesExpDouble(i,2)))
                  notesOk=notesOk+1;
              else
                  if(j<nbOnsetDet-nbOnsetExp)
                    j=j+1;
                  else
                      %warning('Trop de différences pour évaluer');
                  end
              end
           end
           pourcentageCorrect = notesOk/length(notesExpDouble)*100;
           disp(['Détection des notes et fondamentales = ' num2str(pourcentageCorrect) '%.']);
       else      
           notesOk=0;
           j=0;
           for(i=1:nbOnsetDet)
              if(notesDetDouble(i,3)==notesExpDouble(i+j,3) && (notesDetDouble(i,1)+notesDetDouble(i,2))==(notesExpDouble(i+j,1)+notesExpDouble(i+j,2)))
                  notesOk=notesOk+1;
              else
                  if(j<nbOnsetExp-nbOnsetDet)
                    j=j+1;
                  else
                      %warning('Trop de différences pour évaluer');
                      break;
                  end
              end
           end
           pourcentageCorrect = notesOk/length(notesExpDouble)*100;
           disp(['Détection des notes et fondamentales = ' num2str(pourcentageCorrect) '%.']);
       end

    end
end

%% Évaluation du rythme
if(evaluateAR)
    disp(' ');
    disp('Reconnaissance du rythme (durée de note)');


    % Connaissant les noms des durées de notes, on récupère un équivalent numérique de la
    % durée de la note , plus facile à comparer. (On peut se passer de cette
    % étape si on utilise des énumérations).
    tabNomDureeNotes={['double croche'];['double croche pointee'];['croche'];['croche pointee'];['noire'];['noire pointee'];['blanche'];['blanche pointee'];['ronde']};

    if(iscell(rythmeDet))
        [~, rythmeDetDouble] = ismember(rythmeDet, tabNomDureeNotes);
    else
        rythmeDetDouble=rythmeDet;
    end
    [~, rythmeExpDouble] = ismember(rythmeExp, tabNomDureeNotes);

    if(nbOnsetDet==nbOnsetExp)
        if(sum(rythmeExpDouble==rythmeDetDouble)==nbOnsetDet)
            disp('GOOD!: 100%!');
        else
            comparaison=abs(rythmeExpDouble-rythmeDetDouble);
            nErreurs=length(find(comparaison~=0));
            nErreursMinimes=length(find(comparaison==1));
            nErreursImportantes=length(find(comparaison>1));    %La note détectés est relativement très éloignées de celle attendue (noire au lieu de croche)
            disp([num2str(nErreurs) ' erreurs trouvées (sur ' num2str(nbOnsetDet) ' détectées) dont:']);
            disp(['     ' num2str(nErreursMinimes) ' erreurs minimes']);
            disp(['     ' num2str(nErreursImportantes) ' erreurs importantes']);
        end
    else
        disp('Impossible d''analyser la correspondance du rythme');
        [val, indMax]=max(xcorr(rythmeExpDouble, rythmeDetDouble));
        decalage=indMax-length(rythmeExpDouble);
        disp(['Décalage de ' num2str(decalage) ' note(s)']);
        correlation = val/sum(rythmeExpDouble.^2);
        disp(['Corrélation de ' num2str(correlation*100) '%']);
    end
end
end

% Calcul le taux de détection entre le nombre d'onset attendus et le nombre
% d'onsets détectés
function [ performance ] = evaluateOnsets(nbOnsetExp, nbOnsetDet)
    disp('Détection des onsets:');
    disp([num2str(nbOnsetDet) ' détectés.']);
    disp([num2str(nbOnsetExp) ' attendus.']);

    if(nbOnsetDet<nbOnsetExp)
        disp(['/!\ :  ' num2str(nbOnsetExp-nbOnsetDet) ' onsets n''ont pas été detectés!']);
        performance = (nbOnsetDet)/nbOnsetExp;
    elseif(nbOnsetDet>nbOnsetExp)
        disp(['/!\ :  ' num2str(nbOnsetDet-nbOnsetExp) ' onsets ont été détectés en trop!']);
        performance = (2*nbOnsetExp-nbOnsetDet)/nbOnsetExp*100;
    else
        disp(['GOOD!: ' 'Tous les onsets attendus on été detectés!']);
    end
    disp(['Performance: ' num2str(performance) '%']);
end

% Convertit le nom des notes du format A#2 vers A->val numérique de ASCII
% (A), bool, numéro d'octave
function [notesDouble] = convert2double(notesChar)
       notesDouble=double(notesChar);           %Conversion numérique des mesures
       notesDouble(:,3)=notesDouble(:,3)-48;    % convertit la 3 colonne en le numéro de l'octave
       notesDouble(:,2)=(notesDouble(:,2)-32)/3; % Convertit la colonne 2 en "boolean" vrai si #, 0 sinon
end