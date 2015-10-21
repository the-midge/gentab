%tempoDetection.m
%
%   Ce script tente de déterminer le tempo du morceau à partir de la sortie
%   de l'algorithme d'OD.
%   Il fait appel à l'autocorrélation comme décrit dans
%   Ellis07-beattracking.pdf



%% Filtrage passe-haut du signal 
% Pour avoir une moyenne nulle
f = 0.4/FsSF; % Fréquence de coupure à 4Hz
[b,a]=butter(2, 2*pi*f, 'high');
sfFiltered = filter(b, a, sf);

%% Calcul des autocorrélations

% Auto-corrélation classique
autoCorr = xcorr(sfFiltered, sfFiltered, 'biased');
autoCorr = autoCorr(floor(length(autoCorr)/2)+1:end);
tAutoCorr = (1/FsSF:1/FsSF:length(autoCorr)/FsSF)';

% % Auto-corrélation facteur 2
% autoCorr2Tau = [autoCorr(2:2:end); zeros(length(autoCorr)-length(autoCorr((2:2:end))),1)];
% autoCorr2TauMoins = [autoCorr(1:2:end); zeros(length(autoCorr)-length(autoCorr((1:2:end))),1)];;
% autoCorr2TauPlus = [autoCorr(3:2:end); zeros(length(autoCorr)-length(autoCorr((3:2:end))),1)];
% 
% TPS2 = 0.5*autoCorr + 0.25*autoCorr2Tau + 0.125*autoCorr2TauPlus + 0.125*autoCorr2TauMoins;
%% Calcul de la fenêtre comme donnée dans la documentation
tau0 = 0.5; % en seconde (correspond à 1/120bpm)
sigma0 = 1.4; % en octaves
W=exp(-0.5*(log2(tAutoCorr/tau0)/sigma0).^2);

% W2Tau = [exp(-0.5*(log2(tAutoCorr(2:2:end)/tau0)/sigma0).^2); zeros(length(tAutoCorr)-length(tAutoCorr((2:2:end))),1)];
% W2TauMoins = [exp(-0.5*(log2(tAutoCorr(1:2:end)/tau0)/sigma0).^2); zeros(length(tAutoCorr)-length(tAutoCorr((1:2:end))),1)];
% W2TauPlus = [exp(-0.5*(log2(tAutoCorr(3:2:end)/tau0)/sigma0).^2); zeros(length(tAutoCorr)-length(tAutoCorr((3:2:end))),1)];

%% Fonction de froce du tempo(tempo strength)
TPS = W.*(autoCorr);
% TPS2 = (TPS + 0.5*W2Tau.*abs(autoCorr2Tau) + 0.25*W2TauMoins.*abs(autoCorr2TauMoins) + 0.25*W2TauPlus.*abs(autoCorr2TauPlus));
%% Visualisation
figure
plot(tAutoCorr, TPS, 'b', tAutoCorr, W*max(TPS), 'r');
% plot(tAutoCorr, TPS, 'b', tAutoCorr, W*max(TPS), 'r', tAutoCorr, TPS2 , 'g');

%% Calcul du tempo
[val, indT]=max([TPS]);
[~, indRatio] = max(val);
tempo=60/tAutoCorr(indT(indRatio));

while tempo>141
    tempo=tempo/2;
end
tempo = 2*round(tempo/2)    % arrondi par 2