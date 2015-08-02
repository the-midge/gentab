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
% Cette fonction génère un vecteur binaire dans le domaine temporel
% qui est à 1 quand le niveau sonore passe sous le seuil de 100% du niveau
% de bruit par défaut(Pourquoi 130%?)
% Il doit s'ajouter au résultat de l'onset detection.
% 
%
% Il est sensible au bruit près du seuil (passage très rapide d'un coté ou
% de l'autre du seuil)
%   Amélioration: trigger de schmidt puor passer sous ou au dessus du
%   seuil?
% 
%     EDIT: 13/03/2015
%         Amélioration faite
%   Dans l'exploitation, il ne faut pas tenir compte de ces valeurs pour le calcul du tempo
%   Si ces valeurs spécifiquement entrainent des durée de notes aberrantes (comment le définir), il faut les supprimer (fade out et non silence)

if nargin<2
    seuil=100/100;  %Seuil de 120%
end
if nargin<3
    seuil_trigger=20/100;   %Seuil de trigger de 20%
end
%projection_y_useful=mean(abs(y))';
projection_y_useful=y-min(y);

[nbEch, level]=hist(projection_y_useful, 20); %Bruit à 10% du temps du signal
[nbEchBruit, levelBruit_ind]=max(nbEch);
levelBruit=level(levelBruit_ind+1);

indices_debut_silences=[];
   look4silence=true; 

for k=1:length(projection_y_useful)
   if(look4silence &  (projection_y_useful(k)<seuil*levelBruit))
       indices_debut_silences=[indices_debut_silences k];
       look4silence=false;
   end
   if(~look4silence & (projection_y_useful(k)>(seuil+seuil_trigger)*levelBruit))
       look4silence=true;
   end    
end
y_detect_silences=zeros(length(projection_y_useful) , 1);
y_detect_silences(indices_debut_silences)=1;

end

% indices_inf_seuilPlusTrigger=find( projection_y_useful<(seuil+seuil_trigger)*levelBruit );
% y_useful_noisy(indices_inf_seuilPlusTrigger)=1;
% indices_sup_seuilMoinsTrigger=find(projection_y_useful(indices_inf_seuilPlusTrigger)>(seuil-seuil_trigger)*levelBruit);


% figure
% % axis([-1 length(projection_y_useful -0.2 1.2]);
% subplot(211), plot([projection_y_useful seuil*levelBruit*ones(length(projection_y_useful),1)])%Augmentation du seuil de 30°%
% subplot(212), plot(y_useful_noisy);
% y_useful_noisy(indices_sup_seuilMoinsTrigger)=0;
% passageAuSilence=diff(y_useful_noisy)>0;
% subplot(413), plot(y_useful_noisy);
% 
% subplot(414), plot(passageAuSilence);