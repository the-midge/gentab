%GENE_analyse_composition_rythmique.m
%
%   COMMENTAIRES:
%       On doit éviter les triple croches s'il y en a plus de ???
%       Ensuite on définit quel étage correspond aux doubles croches et on redescend les étages
%       Pour arriver à celui qui correspond aux noires.
%       On calcule le tempo et on vérifie qu'il correspond à notre intervalle [50; 150]
%       Si on le dépasse c'est qu'il y a du avoir des faux-positifs à la détection de notes qui ont dues être considérés comme des triples croches
%       On supprime l'écart minimal (dans le temps et les échantillons) et on recommence jusqu'à correspondre à l'intervalle
%       Si on est en dessous, On décale les étages jusqu'à être dans le bon intervalle
%       Ex: si on avait trouvé la noire à 40 BPM, en multipliant par 2, on obtiendrait 80BPM ce qui est très bien
%
%   RÉSULTATS:
%       Fonctionne plutôt bien pour les premiers tests. La qualité de cet
%       algo dépend fortement de celle de l'Onset Detection.

ecart=diff(bornes);
tempos_candidats=(ecart./Fs);
tempos_candidats=((60)./tempos_candidats);

%On normalise les tempos (1/écarts) dans le domaines 4:0.5:9 environ (16BPM
% à 512 BPM)
notes_normees=0.5*round(log2(round(tempos_candidats))/0.5);


%% Constitution des classes de durée de note avec leur population(nombre de
% notes de cette durée
tab_classes_pop=[];
for i=[4:0.5:9]
    tab_classes_pop=[tab_classes_pop; i length(find(notes_normees==i))];
end

%% On cherche maintenant à déterminer qu'elle est la durée musicale de 
%   chaque classe, ce qui nous permettra d'éditer la partition plus tard

%On cherche la plus haute classe qui a de la population = double croche
%A terme il faudra prendre en compte la possibilité de triple croche?
classe_double_croche=max(tab_classes_pop(find(tab_classes_pop(:,2)>0),1));
    
%Ce tableau contiendra les différents types de notes présentes, leurs
%classe et leur population
liste_notes_groupees=[];
tab_nom_duree_notes={['double croche'];['double croche pointee'];['croche'];['croche pointee'];['noire'];['noire pointee'];['blanche'];['blanche pointee'];['ronde']};

for(i=[1:0.5:(classe_double_croche-4)])
    if(tab_classes_pop((classe_double_croche-i+1)*2-7,2)>0)
        liste_notes_groupees=vertcat(liste_notes_groupees,dataset([tab_nom_duree_notes(i*2-1)], [tab_classes_pop((classe_double_croche-i+1)*2-7,1)], [tab_classes_pop((classe_double_croche-i+1)*2-7,2)]));
    end
end
liste_notes_groupees=set(liste_notes_groupees, 'VarNames', {['DureeDeLaNote'], ['Classe'], ['Population']});

tempos_candidats=sort(tempos_candidats);
tempo= determinationTempo( liste_notes_groupees, tempos_candidats )

%notes_normees= correction_double_croche_pointee( notes_normees, classe_double_croche, tempo, ecart, Fs );
%% Création du vecteur contenant toutes les types de notes joués dans l'ordre
liste_note=[];
for(i=[1:length(notes_normees)])
    liste_note=[liste_note;[tab_nom_duree_notes((classe_double_croche-notes_normees(i))*2+1)]];
end
liste_note