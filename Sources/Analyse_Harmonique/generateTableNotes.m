function [Y] = generateTableNotes(indiceMin, indiceMax, fBase, doStem)
%[Y] = generateTableNotes(indiceMin, indiceMax, fBase)
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   [Y] = generateTableNotes() retourne en Y la table
%   décrite ci-après entre les demi-tons d'indice -5 (E3) et indiceMax 42
%   (D#7) relative au A4=440Hz.
%
%   [Y] = generateTableNotes(doStem) 
%   retourne en Y la table décrite ci-après entre les demi-tons d'indice -5 (E3) et indiceMax 42
%   (D#7) relative au A4=440Hz. Si doStem=true, un apercçu de la distribution des fréquences centrales calculées
%   et récupérées en Y(:,:,3)sera tracé dans la figure courante/
%
%   [Y] = generateTableNotes(indiceMin, indiceMax) 
%   retourne en Y la table décrite ci-après entre les demi-tons d'indice indiceMin et indiceMax
%   relative au A4=440Hz.
%
%   [Y] = generateTableNotes(indiceMin, indiceMax, fBase)  
%   retourne en Y la table décrite ci-après entre les demi-tons d'indice indiceMin et indiceMax
%   relative au à la fréquence donnée en fBase
%
%   [Y] = generateTableNotes(indiceMin, indiceMax, fBase, doStem) 
%   permet de tracer dans la fenêtre courante un apercçu de la distribution des fréquences centrales calculées
%   et récupérées en Y(:,:,3)
%
%   Y est de dimension 12 X nbOctaves X 4 où nbOctaves correspond au nombre
%   d'octaves balayées même partiellement. nbOctaves est calculés à partir
%   des deux premieers arguments indice... On conseille de donner
%   indiceMax-indiceMin multiple de 12.
%
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Cette fonction génère une table en 3 dimensions constituée de la façon
%   suivante:
%       - La table est une superposition de 12 matrices
%       - Une des dimension correspond donc aux 12 demi-tons possibles de la
%       gamme chromatique européenne (Du E au D#). 
%       - Les matrices correspondent dans un sens aux différentes octaves
%       pour lesquelles on calcule les notes. Dans l'autre sens, on trouve
%       3 paramètres: 
%           *1 L'indice de la note relative au A4 à 440Hz
%           *2 La fréquence située au milieu de l'intervalle entre la note
%           en question (indice donné en 1) et celle qui la précède (indice
%           donné en 1 -1)
%           *3 La fréquence de la note en question (indice donné en 1)
%           *4 La fréquence située au milieu de l'intervalle entre la note
%           en question (indice donné en 1) et celle qui la suit (indice
%           donné en 1 +1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Conditions sur les arguments
if nargin < 4;   doStem = 0; end
if nargin < 3;   
    fBase = 110; %Fréquence de base du A2
end
if nargin ==1 &&  strcmp(class(indiceMin), class(true))
    doStem=indiceMin;   %Le premier argument correspondait à l'affichage final (booléen)
    indiceMin=-5;   %Correspond au E2
    indiceMax=42;   %Correspond au D#5 (indice 6 + 3*12) 
end
if nargin == 0;   
    indiceMin=-5;   %Correspond au E2
    indiceMax=42;   %Correspond au D#5 (indice 6 + 3*12)
end

%%  Initialisations        
nbOctaves=round((indiceMax-indiceMin)/12);  %Nombre d'octaves concernées

Y=zeros(12, 4, nbOctaves); %12 demi-tons x 4 paramètres x 4 octaves

%% Calculs
for(i=[1:12])
    for(j=[1:nbOctaves])
       Y(i,j,1)= indiceMin+i-1+(j-1)*12;   %Calcul de l'indice de la fondamentale (j=1) ou de l'harmonique j
       
     %% Méthode annexe
     %  Y(i,j,3)= fBase*2^((indiceMin+i-1+(j-1)*12)/12);   %Calcul du paramètres 3
     %  Y(i,j,2)= fBase*2^((indiceMin+i-1+(j-1)*12 -1)/12); %Calcul de la note précédente
     %  Y(i,j,4)= fBase*2^((indiceMin+i-1+(j-1)*12 +1)/12); %Calcul de la note suivante
       
     % Y(i,j,2)= (Y(i,j,2)+Y(i,j,3))/2;    %Calcul du paramètres 2
     %  Y(i,j,4)= (Y(i,j,4)+Y(i,j,3))/2;   %Calcul du paramètres 4
    end
end

%%  Suite des calculs
Y(:,:,3)=fBase*2.^(Y(:,:,1)/12);   %Calcul du paramètres 3
Y(:,:,2)=fBase*2.^((Y(:,:,1)-1)/12);   %Calcul de la note précédente
Y(:,:,4)=fBase*2.^((Y(:,:,1)+1)/12);   %Calcul de la note suivante
Y(:,:,2)=(Y(:,:,3)+Y(:,:,2))/2;   %Calcul du paramètres 2
Y(:,:,4)=(Y(:,:,3)+Y(:,:,4))/2;   %Calcul du paramètres 4

%%  Affichage graphique des notes générées
if(doStem);
    vect_aff=Y(:,:,3)';
    vect_aff=vect_aff(:);
    stem((1:(nbOctaves*12)), sort(vect_aff));
    clear vect_aff;
end