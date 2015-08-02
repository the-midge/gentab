function [] = evaluateResults(filename, notesDet, rythmeDet)
%   evaluateResults.m
%   USAGE:
%       [] = evaluateResults(filename, notes, rythme)
%   ATTRIBUTS:
%       filename:
%           Chemin relatif du fichier audio de test. Doit finir par '\'
%       notes:
%           Liste des notes reconnues. Format 'note|#/(espace)|octave' sans
%           séparateur
%       rythme:
%           Liste des durées de note reconnues. Format: cell array
%           verticale contenant le "nom" des durées de note.

pattern = 'expected.txt';
[notesExp, rythmeExp]=loadExpectedTXT([filename pattern]);

clc
%% Évaluation du nombre d'onset détecté
nbOnsetExp=length(notesExp);
nbOnsetDet=length(notesDet);
disp('Détection des onsets:');
disp([num2str(nbOnsetDet) ' détectés.']);
disp([num2str(nbOnsetExp) ' attendus.']);

if(nbOnsetDet<nbOnsetExp)
    disp(['/!\ :  ' num2str(nbOnsetExp-nbOnsetDet) ' onsets n''ont pas été detectés!']);
elseif(nbOnsetDet>nbOnsetExp)
    disp(['/!\ :  ' num2str(nbOnsetDet-nbOnsetExp) ' onsets ont été détectés en trop!']);
else
    disp(['GOOD!: ' 'Tous les onsets attendus on été detectés!']);
end

%% Évaluation des notes détectées
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
                      error('Trop de différences pour évaluer');
                  end
              end
           end
           pourcentageCorrect = notesOk/length(notesExpDouble)*100;
           disp(['Détection des notes et fondamentales = ' num2str(pourcentageCorrect) '%.']);
       end
       
    end
  
%% Évaluation du rythme
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