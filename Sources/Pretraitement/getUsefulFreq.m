% getUsefulFreq.m
%   DESCRIPTION:
%       Ce script s'inscrit en prétraitement de l'algorithme d'Onset Detection.
%       Non-utilisé actuellement.
%   BUT:
%       L'objectif est d'extraire de la stft, une bande de fréquence
%       porteuse d'information concernant les onsets. On extrait donc les
%       fréquences utiles.


sigmaYSurF=std(abs(y)')'; %Calcul de l'écart-type sur f de la stft de l'audio

[nbFreq, level]=hist(sigmaYSurF, 200);  % Calcul de l'histogramme des fréquences présente
% Les fréquences ayant une faible variance (dans muYSurF) doivent être
% éliminées.

[nbFreqUseless, noInformationLevelInd]=max(nbFreq); % Relevé dans l'histogramme du niveau dans muYSurF des fréquences à éliminer (les plus nombreuses au même niveau)
noInformationLevel=level(noInformationLevelInd);
% Récupération des indices des fréquences inutiles correspondant noInformationLevel
freqUselessInd=find(sigmaYSurF<=noInformationLevel);
freqUsefulInd=find(sigmaYSurF>noInformationLevel);

% /!\ CECI DOIT ETRE MIS DANS UN ENDROIT PLUS LOGIQUE /!\
% y=zscore((abs(y))')'; % normalisation de y
break;

%% Visualisation
figure(1), clf, mesh(f(freqUsefulInd), t, y(freqUsefulInd,:)');
ylabel('Temps (s)'); xlabel('Fréquence (Hz)'); title('Visualisation de la stft sur la bande utile');


figure(2), clf, mesh(f(freqUselessInd), t, y(freqUselessInd,:)');
ylabel('Temps (s)'); xlabel('Fréquence (Hz)'); title('Visualisation de la stft sur la bande inutile');
