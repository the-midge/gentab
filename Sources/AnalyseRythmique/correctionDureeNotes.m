% clear all
% clc
% 
%  load('..\DATA\Voodoo_Child\durees_brutes_voodoo_child.mat')
% 
clear mesureTemporaire mesures somme col colPart depassementMesure derniereNote dureeMesure echecCorrection ind out somme vectEchec;
% 
% durees = dureesBrutes(1:end);
%% Algo de correction de la duree des notes suivant un decoupage en mesure 4:4
% Suite a la generation des probabilites de chaque duree de note
% (generatePeigneGaussienne), on determine en cas de conflit la duree la
% plus probable de la note a traiter.

% TODO : gerer les eventuelles liaisons de prolongation (enjambement de la
%        barre de mesure)
generatePeigneGaussienne; % On genere les probabilités de duree de notes

peigneGaussienne(:, 17:18) = 0; % on ajoute les durées 17 et 18 avec une probabilité de 0 pour gerer les depassements de duree > 16

% Determination des durees reelles en fonction des durees mesurées.
[out] = determinationDurees(durees, peigneGaussienne, abscisse);

%% Script de correction de durees des notes en fonction de la mesure souhaitée

mesure4_4 = 16;

dureeMesure = mesure4_4;

numMesure = 1;
col = 0;
colPart = 0;
l = 1;
depassementMesure = 0; % booleen
echecCorrection = 0;

while(l <= length(durees))
    col = col +1;
    colPart = colPart + 1;
    
    % 1) On crée une nouvelle mesure et on la remplit avec la duree comportant
    %    la probabilité la plus forte
    if(out(l, 3) > out(l, 5))
        mesures(numMesure, col) = out(l, 2);
        
        % 2) On la remplit en parallele une matrice mesureTemporaire afin de 
        %    pouvoir effectuer des operations sur la mesure si celle-ci 
        %    necessite une correction.
        mesureTemporaire(1, colPart) = out(l, 2);
        mesureTemporaire(2, colPart) = out(l, 3);
        mesureTemporaire(3, colPart) = out(l, 4);
        mesureTemporaire(4, colPart) = out(l, 5);      
    else
        mesures(numMesure, col) = out(l,4);
        
        mesureTemporaire(1, colPart) = out(l, 4);
        mesureTemporaire(2, colPart) = out(l, 5);
        mesureTemporaire(3, colPart) = out(l, 2);
        mesureTemporaire(4, colPart) = out(l, 3);  
    end
    
    mesureTemporaire(5, colPart) = mesureTemporaire(2, colPart) + mesureTemporaire(4, colPart);
    mesureTemporaire(6, colPart) = mesureTemporaire(2, colPart) - mesureTemporaire(4, colPart);
    
    % on determine la duree de la mesure entiere
    somme = sum(mesures(numMesure, :));
    
    % On gere le cas où il y a dépassement de duree sur la mesure
    while(somme > dureeMesure)
        
        depassementMesure = 1;
        
        [val ind] = min(mesureTemporaire(6, :));

        if(ind == col)
            mesures(numMesure, ind) = mesureTemporaire(3, ind);
            mesureTemporaire(6, ind) = 1;
            
            if((mesureTemporaire(6, :) == 1))
                if(echecCorrection == 0)
                    mesureTemporaire = [mesureTemporaire derniereNote];
                    derniereNote = [];
                    mesures(numMesure, 1:col) = mesureTemporaire(1, 1:colPart);
                    l = l + 1;
                    echecCorrection = 1;
                end
            end
        else
            derniereNote = mesureTemporaire(:, colPart);
            mesureTemporaire(:, colPart) = [];
            mesures(numMesure, col) = 0;
            l = l - 1;
        end
        
        somme = sum(mesures(numMesure, :));
     
    end
    
    if(depassementMesure == 1)
        
        while(somme < dureeMesure)

            [val ind] = min(mesureTemporaire(6, :));

            if((mesureTemporaire(6, :) == 1))
                if(echecCorrection == 0)
                    mesureTemporaire = [mesureTemporaire derniereNote];
                    derniereNote = [];
                    mesures(numMesure, 1:col) = mesureTemporaire(1, 1:colPart);
                    l = l + 1;
                    echecCorrection = 1;
                end
            else
                mesures(numMesure, ind) = mesureTemporaire(3, ind);
                mesureTemporaire(6, ind) = 1;
            end

            somme = sum(mesures(numMesure, :));
        end
        
        depassementMesure = 0;
    
        % Test de fin de traitement
        if((somme > dureeMesure))
            if(echecCorrection == 0)
                    mesureTemporaire = [mesureTemporaire derniereNote];
                    derniereNote = [];
                    mesures(numMesure, 1:col) = mesureTemporaire(1, 1:colPart);
                    l = l + 1;
                    echecCorrection = 1;
           end
        end
    end
    
    % Si le morceau fait moins d'une mesure
    if(l == length(durees) && numMesure == 1)
        morceauCourt = 1
    end
    
    if(somme == 17 && echecCorrection == 1)
        mesures(numMesure, col) = mesures(numMesure, col) - 1;
    end
    
    if(somme == 15 && echecCorrection == 1)
        mesures(numMesure, col) = mesures(numMesure, col) + 1;
    end

    if((somme == dureeMesure) || (echecCorrection == 1))
        if(echecCorrection == 1)
            vectEchec(numMesure) = 1;
        else
            vectEchec(numMesure) = 0;
        end
        
        numMesure = numMesure +1; % mesure suivante
        col = 0;
        colPart = 0; % nouvelle part 
        mesureTemporaire = [];
        derniereNote = [];

        echecCorrection = 0;
    end
    
l = l + 1;
end

vectEchec = vectEchec';
mesures = mesures';
dureesCorrigees = mesures(:)';
dureesCorrigees(find(dureesCorrigees == 0)) = [];