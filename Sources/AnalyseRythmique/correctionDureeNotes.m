clear all
clc

%% Algo de correction de la duree des notes suivant un decoupage en mesure 4:4
% Suite a la generation des probabilites de chaque duree de note
% (generatePeigneGaussienne), on determine en cas de conflit la duree la
% plus probable de la note a traiter.

generatePeigneGaussienne;

dureesMesurees = [4.3 4.2 4.9 4.6 4.4 4.7 2.2 2.3 2.2 2.1]';

[out] = determinationDurees(dureesMesurees, peigneGaussienne, abscisse);

%%
mesure4_4 = 16;

dureeNotes = zeros(length(dureesMesurees), 3);
numMesure = 1;
col = 0;

for l = 1:length(dureesMesurees)
    if(out(l, 3) > out(l, 5))
        dureeNotes(l, 1) = out(l,2);
        
    else
        dureeNotes(l, 1) = out(l,4);
    end
    
    col = col +1;
    part(numMesure, col) = dureeNotes(l, 1);
    
    
    if(sum(part(numMesure, :)) >= mesure4_4)
        if(sum(part(numMesure, :)) > mesure4_4)
        	numMesure 
        	col
        else
            
        end
            numMesure = numMesure + 1
            col = 0
    end
end
    



