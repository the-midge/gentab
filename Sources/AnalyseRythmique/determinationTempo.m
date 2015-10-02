function [ tempo ] = determinationTempo( listeNotesGroupees, temposCandidats )
%determinationTempo.m
%   USAGE:
%       [ tempo ] = determinationTempo( listeNotesGroupees, temposCandidats )
%
%   ATTRIBUTS:
%       tempo: tempo du morceau en bpm normalisé au nombre pair le plus proche
%
%       listeNotesGroupees: liste de notes contenant leur duree et leur
%       population
%
%       temposCandidats: durée des notes converties en bpm et triée dans
%       l'ordre croissant (après conversion)
%
%   BUT:
%       Pour déterminer le tempo, on compte le nombre total de note plus 
%       lente que la noire et le nombre de noires. On reprend la liste des 
%       écarts que l'on trie dans l'ordre ascendant (descendant) et on 
%       calcule la moyenne des écarts pour les noires (avec les deux 
%       valeurs données précédement). On arrondi au nombre pair le plus
%       proche. C'est le tempo.
%   
%   RÉSULTATS:
%       Bons résultats à 2 ou 4 bpm près (acceptable). Faire plus de tests
%       TODO: /!\ Il faut prendre en compte le cas ou il n'y a pas de noires!


 popNoire=double(listeNotesGroupees(find(strcmp(listeNotesGroupees.DureeDeLaNote,'noire')),3));
 popCroche=double(listeNotesGroupees(find(strcmp(listeNotesGroupees.DureeDeLaNote,'croche')),3));
 popCrochePointee=double(listeNotesGroupees(find(strcmp(listeNotesGroupees.DureeDeLaNote,'croche pointee')),3));
 popInfNoire=sum(double(listeNotesGroupees(find(strcmp(listeNotesGroupees.DureeDeLaNote,'noire'))+1:length(listeNotesGroupees),3)));
 popInfCroche = popInfNoire+popNoire+popCrochePointee;
 tempo=(mean(temposCandidats(popInfNoire+1:popInfNoire+popNoire))*popNoire+mean(temposCandidats(popInfCroche+1:popInfCroche+popCroche))*popCroche/2)/(popCroche+popNoire);
 %les temposCandidats ne sont pas normalisée
 tempo=2*round(tempo/2) %Arrondi par 2

end

