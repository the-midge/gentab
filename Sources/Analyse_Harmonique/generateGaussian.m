function [ vecteurPonderation ] = generateGaussian( nbPoints, Fs, tableNotes )
%generateGaussian.m
%   USAGE:
%       [ vecteurPonderation ] = generateGaussian( nbPoints, Fs, tableNotes )
%
%	ATTRIBUTS:    
%       vecteurPonderation: Renvoie 12 signaux de longueur nbPoints
%       contenant des gaussiennes sur les fréquences d'une note pour toutes
%       ses octaves.
%   
%       nbPoints: longueur total des vecteurs
%       Fs:      Fréquence d'échantillonnage de l'audio d'origine
%       tableNotes: tableau contenant les information des notes dans la
%       plages choisies. Fournit le paramètre nbOctave. Doit être généré
%       via GenerateTableNote.
%    
%	DESCRIPTION:   
%       Cf vecteurPonderation
%	BUT:    
%       Renvoyer 12 signaux, chacun ayant des gaussienne centrées sur ses
%       fréquences. L'amplitude max étant de 1 et 0 ailleurs. N'a de sens
%       que dans le domaine fréquentiel.

f=(Fs/(2*nbPoints):Fs/(2*nbPoints):Fs/2);   %Vecteur de la fréquence

indices=findClosest(f, tableNotes(:,:,3));          % Cherche dans f l'indice se rapprochant le plus du 2ème param.
indicesBasGauss=findClosest(f, tableNotes(:,:,2));  %idem
indicesHautGauss=findClosest(f, tableNotes(:,:,4)); %idem

nbOctaves=size(tableNotes, 2);

vecteurPonderation=zeros(nbPoints, 12);
for(i=[1:nbOctaves])
    for(j=[1:12])
        vecteurPonderation(indicesBasGauss(j,i):indicesHautGauss(j,i)-1,j)=gausswin(indicesHautGauss(j,i)-indicesBasGauss(j,i));
    end
end

end

