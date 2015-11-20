function [varargout] = analyseRythmiquePourApprentissage(oss, bornes, FsOSS, Fs, display)
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
%
%       display: si vrai, affiche deux graphe représentant la répartition
%       des durées de notes.
%
%   BUT:
%       Cette fonction tente de déterminer la durées musicale de chaque
%       note. D'autre part elle détermine le tempo via la fonction
%       determinationTempoV3 en passant par l'autocorrélation de oss.
%       Pour la détermination des durées de notes, on détermine des
%       intervalles de durées (en s) qui correspondent à chaque durée
%       musicale potentielle. La largeur des ces intervalles dépend de la
%       probabilité pour une note d'appartenir à une certaine classe.      

    if nargin <4
        display = false;
    end

    ecart=diff(bornes)/Fs; % écart entre deux bornes en secondes
    generatePeigneGaussienne;

    %% Détermination de la densité de probabilité des tempos
    determinationTempoV3; % Les résultats sont globalement bon mais il peut y avoir un écart d'un facteur 2.
    % Séléection des candidats
    [~, temposCandidats]=findpeaks(C, 'SORTSTR', 'descend');
    
    for tau=1:length(temposCandidats)
    %% Détermination des durées de notes
        ecartRef=60/temposCandidats(tau); %coefficient de normalisation des écarts
        indiceEcartsPourPeigne = findClosest(abscisse,ecart/ecartRef*4);
        probas=peigneGaussienne(indiceEcartsPourPeigne,:);
        [probasMax(:,tau), durees] = max(probas');
    end
    % Choix du meilleur tempo candidat
    mu_Tau=mean(probasMax);
    [~, tauMeilleur]=max(mu_Tau);
    tempo=temposCandidats(tauMeilleur);
    
    %% Calcul des paramètres pour la SVM
    ecartAutoriseBPM = 4;
    features = [sumInRange(C,1,tempo-ecartAutoriseBPM-1);
                sumInRange(C,tempo+ecartAutoriseBPM+1,length(C))];
    features=[features;sumInRange(C,tempo/2-ecartAutoriseBPM,tempo/2+ecartAutoriseBPM)];
    features=[features;sumInRange(C, tempo-ecartAutoriseBPM, tempo+ecartAutoriseBPM);
        sumInRange(C,2*tempo-ecartAutoriseBPM,2*tempo+ecartAutoriseBPM)]; %Pb: on srt de C
    features=[features;
                length(find(C>0));
                tempo];
        
    mins = [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,      minBPM];
    maxs = [ 1.0, 1.0, 1.0, 1.0, 1.0, maxBPM,   maxBPM];

    features_normalized = zeros(size(features));
    for i = 1:length(features)
        if mins(i) ~= maxs(i)
            features_normalized(i) = ((features(i) - mins(i)) / (maxs(i) - mins(i)));
        end
    end
    
    %% Fin de la fonction
    if nargout==2
        varargout{1}=tempo;
        varargout{2}=features_normalized;
    end
end