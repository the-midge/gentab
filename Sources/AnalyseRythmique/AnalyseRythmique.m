function [varargout] = analyseRythmique(oss, bornes, FsOSS, Fs, display, tempo)
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
%       tempo: si le tempo est donné en entrée, il n'est pas estimé dans
%       l'algorithme.
%
%   BUT:
%       Cette fonction tente de déterminer la durées musicale de chaque
%       note. D'autre part elle détermine le tempo via la fonction
%       determinationTempoV2 en passant par l'autocorrélation de oss.
%       Pour la détermination des durées de notes, on détermine des
%       intervalles de durées (en s) qui correspondent à chaque durée
%       musicale potentielle. La largeur des ces intervalles dépend de la
%       probabilité pour une note d'appartenir à une certaine classe.      

    if nargin <4
        display = false;
    end
        %%
    ecart=diff(bornes)/Fs; % écart entre deux bornes en secondes

%     probabilitesInitiales = [0.15;0.3;0.05;0.2;0.05;0.1;0.02;0.05;0;0;0;0.05;0;0;0;0.03];
%     % probabilitesInitialesV2 est issu de la publication
%     % ViitKE03-melodies.pdf
%     probabilitesInitialesV2 = [0.02;0.107;0.009;0.079;0.0005;0.01;0.0005;0.0201;0;0;0;0.0005;0;0;0;0.006];
%     probabilitesInitialesV2 = probabilitesInitialesV2*1/sum(probabilitesInitialesV2);
%     
%     probabilitesInitiales = probabilitesInitialesV2;
%     facteursReferences = (0.25:0.25:4)'; % facteur multiplicatif par rapport à la noire=1 (ronde=4, croche = 0.5)
% 
%     %% Calcul des intervalles
%     edgeHistogramme = [0];
%     decalage = 0;
%     for k=1:length(facteursReferences)-1
%         if(probabilitesInitiales(k+1) == 0)
%             decalage=decalage+1;
%         else
%             edgeHistogramme(k+1)= getBarycentre(facteursReferences(k-decalage), facteursReferences(k+1), probabilitesInitiales(k+1), probabilitesInitiales(k-decalage)); %la probabilité d'un point est donnée à l'autre point car il y a une notion dinverse
%              if decalage>0
%                 while (decalage>=0)
%                     edgeHistogramme(k-decalage)=edgeHistogramme(k+1);
%                     decalage=decalage-1;
%                 end
%             end
%         end
%         k=k+1;
%     end
%     edgeHistogramme(k+1) = 5;
    generatePeigneGaussienne;
    if ~exist('tempo', 'var')
            %% Détermination de la densité de probabilité des tempos
            determinationTempoV3; % Les résultats sont globalement bon mais il peut y avoir un écart d'un facteur 2.
            % Séléection des candidats
            [~, temposCandidats]=findpeaks(C);

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
    
    %% Doublement ou division via la SVM

    
    end
    %% Détermination des durées de notes avec le bon tempo (normalement)
    ecartRef=60/tempo; %coefficient de normalisation des écarts
    indiceEcartsPourPeigne = findClosest(abscisse,ecart/ecartRef*4);
    
    
    
    probasEcart=peigneGaussienne(indiceEcartsPourPeigne,:);
    [~, durees] = max(probasEcart');
    
    
    if display
%         figure(1), clf
%         bar(edgeHistogramme*ecartRef, pop, 'histc')
%         hold on
%         scatter(edgeHistogramme*ecartRef, [0; probabilitesInitiales]*max(pop)/2)
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
    if nargout == 3
         varargout{2}=tempo;
        varargout{3}=svm_sum;
    end
    if nargout == 4
        varargout{2}=tempo;
        varargout{3}=svm_sum;
        varargout{4}=mult;
    end
end