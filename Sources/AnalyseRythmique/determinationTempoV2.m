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

%% Calcul de l'auto corrélation
autoCorr = xcorr(sfFiltered, sfFiltered, 'unbiased');
autoCorr = autoCorr(floor(length(autoCorr)/2)+1:end);
tAutoCorr = (1/FsSF:1/FsSF:length(autoCorr)/FsSF)';

%% Calcul de la fenêtre comme donné dans la documentation
tau0 = 0.5; % en seconde (correspond à 1/120bpm)
sigma0 = 1.4; % en octaves
W=exp(-0.5*(log2(tAutoCorr/tau0)/sigma0).^2);

%% Fonction de froce du tempo(tempo strength)
TPS = W.*abs(autoCorr);
%% Visualisation
%plot(tAutoCorr, TPS, 'b', tAutoCorr, W*max(TPS), 'r');

%% Calcul du tempo
[val, ind]=max(TPS);
tempo=60/tAutoCorr(ind);

while tempo>160
    tempo=tempo/2;
end
tempo = 2*round(tempo/2);    % arrondi par 2