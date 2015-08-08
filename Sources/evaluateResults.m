function [] = evaluateResults(path, varargin)
%   evaluateResults.m
%   USAGE:
%       [] = evaluateResults(path, notes, rythme)
%       [] = evaluateResults(path, sample_index_onsets)
%       [] = evaluateResults(path, notes, rythme)

%   ATTRIBUTS:
%       path:
%           Chemin relatif du fichier audio de test. Doit finir par '\'
%       notes:
%           Liste des notes reconnues. Format 'note|#/(espace)|octave' sans
%           séparateur
%       rythme:
%           Liste des durées de note reconnues. Format: cell array
%           verticale contenant le "nom" des durées de note.
if(nargin == 3)
    rythmeDet = varargin{2};
    evaluate_AR = true;
else
    evaluate_AR = false;
end

if(ischar(varargin{1}))
    notesDet = varargin{1};
    evaluate_AH = true;
elseif(iscell(varargin{1}))
    rythmeDet = varargin{1};
    evaluate_AH = false;
    evaluate_AR = true;
elseif(isreal(varargin{1}))
    notesDet = varargin{1};   % Il ne s'agit pas du tout des notes jouées mais le programme s'arretera avant de déclencher une erreur
    evaluate_AR = false;
    evaluate_AH = false;
end

pattern = 'expected.txt';
[notesExp, rythmeExp]=loadExpectedTXT([path pattern]);

clc
%% Évaluation du nombre d'onset détecté
nbOnsetExp=length(notesExp);
nbOnsetDet=length(notesDet);
[ onset_performance ] = evaluate_onsets(nbOnsetExp, nbOnsetDet);

if(~evaluate_AR & ~evaluate_AH)
    return;
end
%% Évaluation des notes détectées
if(evaluate_AH)
    disp(' ');
    disp('Reconnaissance des notes (tons)');
    if(strcmp(notesDet, notesExp))
        disp('GOOD!: 100%!');
    else
       notesDouble=double(notesDet);           %Conversion numérique des mesures
       notesExpDouble=double(notesExp);

       if(nbOnsetDet==nbOnsetExp)   %Cas où le nombre de ligne est le même
           pourcentageOctave=sum(notesDouble(:,3)==notesExpDouble(:,3))/length(notesExpDouble)*100;
           disp(['Détection des octaves = ' num2str(pourcentageOctave) '%.']);

           pourcentageFondamentales = sum((notesDouble(:,1)+notesDouble(:,2))==(notesExpDouble(:,1)+notesExpDouble(:,2)))/length(notesExpDouble)*100;
           disp(['Détection des notes = ' num2str(pourcentageFondamentales) '%.']);
       elseif(nbOnsetDet>nbOnsetExp)
           notesOk=0;
           j=0;
           for(i=1:nbOnsetExp)
              if(notesDouble(i+j,3)==notesExpDouble(i,3) && (notesDouble(i+j,1)+notesDouble(i+j,2))==(notesExpDouble(i,1)+notesExpDouble(i,2)))
                  notesOk=notesOk+1;
              else
                  if(j<nbOnsetDet-nbOnsetExp)
                    j=j+1;
                  else
                      error('Trop de différences pour évaluer');
                  end
              end
           end
           pourcentageCorrect = notesOk/length(notesExpDouble)*100;
           disp(['Détection des notes et fondamentales = ' num2str(pourcentageCorrect) '%.']);
       else      
           notesOk=0;
           j=0;
           for(i=1:nbOnsetDet)
              if(notesDouble(i,3)==notesExpDouble(i+j,3) && (notesDouble(i,1)+notesDouble(i,2))==(notesExpDouble(i+j,1)+notesExpDouble(i+j,2)))
                  notesOk=notesOk+1;
              else
                  if(j<nbOnsetExp-nbOnsetDet)
                    j=j+1;
                  else
                      warning('Trop de différences pour évaluer');
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
if(evaluate_AR)
    disp(' ');
    disp('Reconnaissance du rythme (durée de note)');


    % Connaissant les noms des durées de notes, on récupère un équivalent numérique de la
    % durée de la note , plus facile à comparer. (On peut se passer de cette
    % étape si on utilise des énumérations).
    tab_nom_duree_notes={['double croche'];['double croche pointee'];['croche'];['croche pointee'];['noire'];['noire pointee'];['blanche'];['blanche pointee'];['ronde']};
    for i=1:length(tab_nom_duree_notes)
        nomDureeDouble(i)=sum(double(tab_nom_duree_notes{i}));
    end
    nomDureeDouble=nomDureeDouble';

    for i=1:length(rythmeDet)
        rythmeDetDouble(i)=sum(double(rythmeDet{i}));
    end
    rythmeDetDouble=rythmeDetDouble';
    [~, rythmeDetDouble] = ismember(rythmeDetDouble, nomDureeDouble);

    for i=1:length(rythmeDet)
        rythmeExpDouble(i)=sum(double(rythmeExp{i}));
    end
    rythmeExpDouble=rythmeExpDouble';
    [~, rythmeExpDouble] = ismember(rythmeExpDouble, nomDureeDouble);

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
        %Trouver quelqurechose ici
        %plot(xcorr(rythmeExpDouble, rythmeExpDouble)/sum(rythmeExpDouble.^2));
    end
end
end

function [ performance ] = evaluate_onsets(nbOnsetExp, nbOnsetDet)
    disp('Détection des onsets:');
    disp([num2str(nbOnsetDet) ' détectés.']);
    disp([num2str(nbOnsetExp) ' attendus.']);

    if(nbOnsetDet<nbOnsetExp)
        disp(['/!\ :  ' num2str(nbOnsetExp-nbOnsetDet) ' onsets n''ont pas été detectés!']);
        performance = (nbOnsetDet)/nbOnsetExp;
    elseif(nbOnsetDet>nbOnsetExp)
        disp(['/!\ :  ' num2str(nbOnsetDet-nbOnsetExp) ' onsets ont été détectés en trop!']);
        performance = (2*nbOnsetExp-nbOnsetDet)/nbOnsetExp;
    else
        disp(['GOOD!: ' 'Tous les onsets attendus on été detectés!']);
    end
    disp(['Performance: ' num2str(performance) '%']);
end
