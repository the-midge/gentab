function [yDetectSilences]=detectionSilences(y, seuil, seuilTrigger)
% DetectionSilences.m
%   Usage: 
%       [yDetectSilences]=detectionSilences(y, seuil, seuilTrigger)
%       
%   Arguments:
%           y: résultat de la stft du signal audio
%           seuil: pourcentage du niveau de bruit que l'on veut détecter
%           seuilTrigger: largeur de la fenêtre du trigger en pourcentage du niveau de
%           bruit
%           
%
%           yDetectSilences: résultat dans le domaine spatial pour les
%           début des silences.
%
%   Description: Cette fonction génère un vecteur binaire dans le domaine temporel
% qui est à 1 quand le niveau sonore passe sous un seuil du niveau de bruit
% par défaut. Il doit s'ajouter au résultat de l'onset detection.
% 
% Il est sensible au bruit près du seuil (passage très rapide d'un coté ou
% de l'autre du seuil)
%   Amélioration: trigger en fenêtre pour passer sous ou au dessus du
%   seuil?
% 
%   Dans la suite, il ne faut pas tenir compte de ces valeurs pour le calcul du tempo
%   Si ces valeurs spécifiquement entrainent des durée de notes aberrantes (comment le définir), il faut les supprimer (fade out et non silence)

if nargin<2
    seuil=100/100;  %Seuil de 100%
end
if nargin<3
    seuilTrigger=20/100;   %Seuil de trigger de 20%
end
projectionYUseful=mean(abs(y))';      % Projection du signal sur le temps (par moyennage)
projectionYUseful=y-min(abs(y));      %La valeur minimale devient 0 et tout le signal est augmenté de cet offset.

[nbEch, level]=hist(projectionYUseful, 20);   % Histogramme avec un classe tous les 5% de l'amplitude min-max
[nbEchBruit, niveauBruitInd]=max(nbEch);        % On part du principe que le niveau de bruit est la classe qui à la plus forte valeur dans l'histogramme (fumeux...)
niveauBruit=level(niveauBruitInd+1);             % On récupère cette classe via l'indice récupéré juste avant

indicesDebutSilences=[];
   look4silence=true; 

for k=1:length(projectionYUseful)                                             % sur tout le signal
   if(look4silence &  (projectionYUseful(k)<seuil*niveauBruit))                % si on cherche un silence et que le signal est inférieur au seuil*niveau de bruit
       indicesDebutSilences=[indicesDebutSilences k];                       % On ajout l'échantillon courant au indices de début de silences
       look4silence=false;                                                      % On ne cherche plus de silence
   end
   if(~look4silence & (projectionYUseful(k)>(seuil+seuilTrigger)*niveauBruit))% Si on ne cherche pas de silence et que le niveau courant est supérieur à (seuil+...)
       look4silence=true;                                                       % Alors on peut recommencer à chercher un silence
   end    
end
% Mise en forme du vecteur de sorties comme défini dans la doc plus haut
yDetectSilences=zeros(length(projectionYUseful) , 1);
yDetectSilences(indicesDebutSilences)=1;

end

%% Visualisation
% figure
% % axis([-1 length(projectionYUseful -0.2 1.2]);
% subplot(211), plot([projectionYUseful seuil*niveauBruit*ones(length(projectionYUseful),1)])%Augmentation du seuil de 30°%
% subplot(212), plot(yUsefulNoisy);
% yUsefulNoisy(indicesSupSeuilMoinsTrigger)=0;
% passageAuSilence=diff(yUsefulNoisy)>0;
% subplot(413), plot(yUsefulNoisy);
% 
% subplot(414), plot(passageAuSilence);