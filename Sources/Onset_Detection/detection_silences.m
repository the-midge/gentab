function [y_detect_silences]=detection_silences(y, seuil, seuil_trigger)
% Detection_silences.m
%   Usage: 
%       [y_detect_silences]=detection_silences(y, seuil, seuil_trigger)
%       
%   Arguments:
%           y: résultat de la stft du signal audio
%           seuil: pourcentage du niveau de bruit que l'on veut détecter
%           seuil_trigger: largeur de la fenêtre du trigger en pourcentage du niveau de
%           bruit
%           
%
%           y_detect_silences: résultat dans le domaine spatial pour les
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
    seuil_trigger=20/100;   %Seuil de trigger de 20%
end
projection_y_useful=mean(abs(y))';      % Projection du signal sur le temps (par moyennage)
projection_y_useful=y-min(abs(y));      %La valeur minimale devient 0 et tout le signal est augmenté de cet offset.

[nbEch, level]=hist(projection_y_useful, 20);   % Histogramme avec un classe tous les 5% de l'amplitude min-max
[nbEchBruit, niveauBruit_ind]=max(nbEch);        % On part du principe que le niveau de bruit est la classe qui à la plus forte valeur dans l'histogramme (fumeux...)
niveauBruit=level(niveauBruit_ind+1);             % On récupère cette classe via l'indice récupéré juste avant

indices_debut_silences=[];
   look4silence=true; 

for k=1:length(projection_y_useful)                                             % sur tout le signal
   if(look4silence &  (projection_y_useful(k)<seuil*niveauBruit))                % si on cherche un silence et que le signal est inférieur au seuil*niveau de bruit
       indices_debut_silences=[indices_debut_silences k];                       % On ajout l'échantillon courant au indices de début de silences
       look4silence=false;                                                      % On ne cherche plus de silence
   end
   if(~look4silence & (projection_y_useful(k)>(seuil+seuil_trigger)*niveauBruit))% Si on ne cherche pas de silence et que le niveau courant est supérieur à (seuil+...)
       look4silence=true;                                                       % Alors on peut recommencer à chercher un silence
   end    
end
% Mise en forme du vecteur de sorties comme défini dans la doc plus haut
y_detect_silences=zeros(length(projection_y_useful) , 1);
y_detect_silences(indices_debut_silences)=1;

end

%% Visualisation
% figure
% % axis([-1 length(projection_y_useful -0.2 1.2]);
% subplot(211), plot([projection_y_useful seuil*niveauBruit*ones(length(projection_y_useful),1)])%Augmentation du seuil de 30°%
% subplot(212), plot(y_useful_noisy);
% y_useful_noisy(indices_sup_seuilMoinsTrigger)=0;
% passageAuSilence=diff(y_useful_noisy)>0;
% subplot(413), plot(y_useful_noisy);
% 
% subplot(414), plot(passageAuSilence);