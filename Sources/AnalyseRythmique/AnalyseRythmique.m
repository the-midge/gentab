function [varargout] = analyseRythmique(oss, bornes, FsOSS, Fs, indexOnsets, indexOffsets, display, tempo)
%   analyseRythmique.m
%
%   USAGE: 
%       [durees, tempo] = analyseRythmique(oss, bornes, FsOSS, Fs, 1);
%   ATTRIBUTS:
%       durees: durees de chaque note dans l'ordre. Format: nombre de
%       double-croches (croche = 2, noire = 4)
%       tempo: tempo estimé du morceau
%
%       oss: Onset Strength Signal - sortie de la fonction de détection d'onset detection
%       bornes: échantillons dans la base du temps d'origine pour lesquels,
%       un onset est détecté
%       FsOSS: Fréquence d'échantillonnage après la fonction d'osnet
%       detection
%       Fs : Fréquence d'échantillonnage du morceau
%       indexOnsets: Index des instants où une note démarre.
%       indexOffsets: Index des instants où un silence est détecté
%       
%       display: si vrai, affiche deux graphe représentant la répartition
%       des durées de notes.
%       tempo: si le tempo est donné en entrée, il n'est pas estimé dans
%       l'algorithme.
%
%   BUT:
%       Cette fonction tente de déterminer la durées musicale de chaque
%       note. D'autre part elle détermine le tempo via la fonction
%       determinationTempoV3 en passant par l'autocorrélation de oss.
%       Pour la détermination des durées de notes, on détermine des
%       intervalles de durées (en s) qui correspondent à chaque durée
%       musicale potentielle. La largeur des ces intervalles dépend de la
%       probabilité pour une note d'appartenir à une certaine classe.      

    if nargin < 7
        display = false;
    end

    ecart=diff(bornes)/Fs; % écart entre deux bornes en secondes
    generatePeigneGaussienne;
    
    if ~exist('tempo', 'var')
        %% Détermination de la densité de probabilité des tempos
        determinationTempoV3; % Les résultats sont globalement bon mais il peut y avoir un écart d'un facteur 2.

        % Séléection des candidats
        [~, temposCandidats]=findpeaks(C, 'SORTSTR', 'descend');

        for tau=1:length(temposCandidats)
        % Détermination des durées de notes
            ecartRef=60/temposCandidats(tau); %coefficient de normalisation des écarts
            indiceEcartsPourPeigne = findClosest(abscisse,ecart/ecartRef*4);
            probas=peigneGaussienne(indiceEcartsPourPeigne,:);
            [probasMax(:,tau), durees] = max(probas');
        end
       
        % Choix du meilleur tempo candidat
        mu_Tau=mean(probasMax);
        [~, tauMeilleur]=max(mu_Tau);
        tempo=temposCandidats(tauMeilleur);      
        
        %% Doublement ou division via la SVM
        doubleOrHalve;
        load nnTrained
        [probDoubleOrHalve]=sim(nnTrained, features_normalized)*100 ;   %Probabilité (%) qu'il faille diviser par 2, ne rien faire ou doubler le tempo trouvé).
        if(probDoubleOrHalve(1)>25)  %Si la proba de diviser est supérieure à 25% on divise
            tempo=tempo/2;
        elseif(probDoubleOrHalve(3)>66) %Si la proba de double est supérieure à 66% on double
            tempo=2*tempo;
        end %Sinon on ne fait rien
        tempo=round(tempo);
    end
    
    %% Détermination des durées de notes avec le bon tempo (normalement)
    ecartRef=60/tempo; %coefficient de normalisation des écarts
    indiceEcartsPourPeigne = findClosest(abscisse,ecart/ecartRef*4); % abscisse de indiceEcartsPourPeigne = dureesBrutes
    
    % Correction
    dureesBrutes = abscisse(indiceEcartsPourPeigne);
    
    % Intégration des silences
    % note2split: note a séparer car l'onset est suivi d'un offset
    note2split=[];
    for k = 1:length(indexOnsets)-1
        if(indexOnsets(k+1)>indexOffsets(find(indexOffsets>indexOnsets(k), 1)))
            note2split=[note2split; k];
        end
    end
    % séparation
    durees = dureesBrutes;
    silences = [];
    for k=length(note2split):-1:1
        currNote=note2split(k);
        dureeCurrNote= dureesBrutes(currNote);
        if dureeCurrNote < edgeHistogramme(2)
            indexOffsets(currNote)=[];  % On supprime ce silence, la note est trop courte pour être divisée
        elseif dureeCurrNote >= edgeHistogramme(2) && dureeCurrNote < edgeHistogramme(3)
            durees(currNote)=1;
            durees=[durees(1:currNote) dureeCurrNote-1 durees(currNote+1:end)];
            silences=[currNote; silences];
        elseif dureeCurrNote >= edgeHistogramme(3) && dureeCurrNote < edgeHistogramme(5)
            durees(currNote)=2;
            durees=[durees(1:currNote) dureeCurrNote-2 durees(currNote+1:end)];
            silences=[currNote; silences];
        elseif dureeCurrNote >= edgeHistogramme(5) && dureeCurrNote < edgeHistogramme(12)
            durees(currNote)=4;
            durees=[durees(1:currNote) dureeCurrNote-4 durees(currNote+1:end)];
            silences=[currNote; silences];
        elseif dureeCurrNote >= edgeHistogramme(12) && dureeCurrNote < edgeHistogramme(end)
            durees(currNote)=8;
            durees=[durees(1:currNote) dureeCurrNote-8 durees(currNote+1:end)];
            silences=[currNote; silences];
        end
    end
    silences=silences+(1:length(silences))';
    %% No correction
%     probasEcart = peigneGaussienne(indiceEcartsPourPeigne,:);
%     [~, durees] = max(probasEcart')
        
    %% Fin du programme
    if display
        figure, clf, hold on
        stem(ecart, 'b');
        stem(durees, 'r');
        legend('Durees (en s)', 'Durees déterminée (en nb de double-croches)')
        plot(repmat(edgeHistogramme*ecartRef, length(ecart), 1));
    end
    
    varargout{1}=durees;
    if nargout==2        
        varargout{2}=tempo;
    end
    if nargout == 4
         varargout{1}=durees;
        varargout{2}=tempo;
        varargout{3}=silences;
        varargout{4}=indexOffsets;
    end
end