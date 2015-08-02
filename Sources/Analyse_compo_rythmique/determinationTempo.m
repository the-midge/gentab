function [ tempo ] = determinationTempo( liste_notes_groupees, tempos_candidats )
%determinationTempo.m
%   USAGE:
%       [ tempo ] = determinationTempo( liste_notes_groupees, tempos_candidats )
%
%   ATTRIBUTS:
%       tempo: tempo du morceau en bpm normalisé au nombre pair le plus proche
%
%       liste_notes_groupees: liste de notes contenant leur duree et leur
%       population
%
%       tempos_candidats: durée des notes converties en bpm et triée dans
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


 pop_noire=sum(double(liste_notes_groupees(find(strcmp(liste_notes_groupees.DureeDeLaNote,'noire')),3)));
 pop_inf_noire=sum(double(liste_notes_groupees(find(strcmp(liste_notes_groupees.DureeDeLaNote,'noire'))+1:length(liste_notes_groupees),3)));
 tempo=mean(tempos_candidats(pop_inf_noire+1:pop_inf_noire+pop_noire)); %les tempos_candidats ne sont pas normalisée
 tempo=2*round(tempo/2) %Arrondi par 2

end

