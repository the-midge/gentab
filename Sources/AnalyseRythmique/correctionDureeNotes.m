clear all
clc

%% Algo de correction de la duree des notes suivant un decoupage en mesure 4:4
% Suite a la generation des probabilites de chaque duree de note
% (generatePeigneGaussienne), on determine en cas de conflit la duree la
% plus probable de la note a traiter.

% TODO : gerer les eventuelles liaisons de prolongation (enjambement de la
%        barre de mesure)

generatePeigneGaussienne; % On genere les probabilités de duree de notes

peigneGaussienne(:, 17:18) = 0; % on ajoute les durées 17 et 18 avec une probabilité de 0 pour gerer les depassements de duree > 16

% simulation d'entrees
dureesMesurees = [4.3 4.2 5 4.6 4.4 4.7 2.2 2.3 2.2 2.1 17.91 8.6 8.4 8.9 8.2 4.1]';
% dureesMesurees = [4.3 4.1 4.8 4.6];

% Determination des durees reelles en fonction des durees mesurées.
[out] = determinationDurees(dureesMesurees, peigneGaussienne, abscisse);

%% Script de correction de durees des notes en fonction de la mesure souhaitée

mesure4_4 = 16;
mesure3_4 = 12;
mesure2_4 = 8;

dureeMesure = mesure3_4

numMesure = 1;
col = 0;
colPart = 0;

% Description de l'algorithme de correction de duree

% 2) On la remplit en parallele une matrice part afin de pouvoir effectuer
% des operations sur la mesure si celle-ci necessite une correction

for l = 1:length(dureesMesurees)
    
    col = col +1;
    colPart = colPart + 1;
    
    % 1) On crée une nouvelle mesure et on la remplit avec la duree comportant
    %    la probabilité la plus forte
    if(out(l, 3) > out(l, 5))
        mesuresTemporaires(numMesure, col) = out(l, 2);
        
        % 2) On la remplit en parallele une matrice part afin de pouvoir effectuer
        %    des operations sur la mesure si celle-ci necessite une correction
        part(1, colPart) = out(l, 2);
        part(2, colPart) = out(l, 3);
        part(3, colPart) = out(l, 4);
        part(4, colPart) = out(l, 5);        
    else
        mesuresTemporaires(numMesure, col) = out(l,4);
        part(1, colPart) = out(l, 4);
        part(2, colPart) = out(l, 5);
        part(3, colPart) = out(l, 2);
        part(4, colPart) = out(l, 3);
    end
    
    % on determine la duree entiere de la mesure
    somme = sum(mesuresTemporaires(numMesure, :));

        % On gere ici seulement le cas d'un depassement de duree sur la
        % mesure.
        while(somme > dureeMesure)
            
            % on traite les eventuelles corrections en fonction des
            % probabilités du second choix calculé dans la fonction
            % determinationDurees de maniere crossante. 
            %
            [val ind] = max(part(4, :));
                
            % Dans le cas où il reste une probabilité non egale à 0, On
            % permutte les durees et on passe la probabilité à 0. cette
            % etape permet d'eviter de tomber dans une boucle infinie et de
            % passer a la deuxieme etape de l'algo de correction.
            % Notons que si cette etape reussit à obtenir une duree de mesure
            % conforme à ce que l'on veut ( par defaut mesure 4:4), on
            % ignore la deuxieme etape qui suit
            if(val ~= 0)
                mesuresTemporaires(numMesure, ind) = part(3, ind);
                part(4, ind) = 0;
            % l'etape precedente nous donne une info importante dans le cas
            % où l'on arrive pas a ajuster convenablement les notes meme
            % en utilisant leur probabilités : La derniere note a avoir été
            % traité.
            % On fait le postulat que si la premiere etape echoue, c'est a
            % cause de cette derniere note. On decide alors de la
            % decrementer jusqu'a parvenir a la duree de mesure souhaiter
            % (4:4 par defaut)
            else
                [valMin indMin] = min(abs(part(3, :) - part(1, :)));
                mesuresTemporaires(numMesure, indMin) = mesuresTemporaires(numMesure, indMin) - 1;
            end
            
            somme = sum(mesuresTemporaires(numMesure, :));
            
        end
        
        % Lorsqu'on arrive a avoir une mesure correcte, on passe a la
        % suivante, etc...
        if(somme == dureeMesure)
            numMesure = numMesure +1; % mesure suivante
            col = 0;
            colPart = 0; % nouvelle part 
            
        end
end
    



