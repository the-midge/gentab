function [ vecteurPonderation ] = generateGaussian( nbPoints, Fs, tableNotes )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
f=(Fs/(2*nbPoints):Fs/(2*nbPoints):Fs/2);   %Vecteur de la fréquence

indices=findClosest(f, tableNotes(:,:,3));
indicesBasGauss=findClosest(f, tableNotes(:,:,2));
indicesHautGauss=findClosest(f, tableNotes(:,:,4));
nbOctaves=size(tableNotes);
nbOctaves=nbOctaves(2);
vecteurPonderation=zeros(nbPoints, 12);
for(i=[1:nbOctaves])
    for(j=[1:12])
        vecteurPonderation(indicesBasGauss(j,i):indicesHautGauss(j,i)-1,j)=gausswin(indicesHautGauss(j,i)-indicesBasGauss(j,i));
    end
end

end

