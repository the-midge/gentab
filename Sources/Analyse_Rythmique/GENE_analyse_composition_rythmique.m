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
tempo= determinationTempo( liste_notes_groupees, sort(tempos_candidats))

%% Création du vecteur contenant toutes les types de notes joués dans l'ordre

% Une fois le tempo trouvé approximativement, on recalcule les norme des
% notes d'une manière plus rigoureuse connaissant le tempo (t):
%
%   r   bp  b   np  n   cp  c  dcp  dc
% |---|---|---|---|---|---|---|---|---|
%  t/4     t/2      t      2*t     4*t
%
%   On va calculer les bornes de ces classes et classifiée les notes en
%   fonction de ces bornes (en % du tempo):
% bornes_classes_notes=[     31.25;   43.75;  62.5;  85.5; 125;   175;  250;      350      ]/100; % valeurs théoriques
bornes_classes_notes=[     31.25;   43.75;  62.5;   93;   125;   175;    290;      290     ]/100; % valeurs modifiées (pas de DcrochP)
%                     |rondes|blancheP|blanche|noireP|noire|crocheP|croche|DcrocheP|Dcroche|
%                        9       8        7      6      5     4       3        2      1
for i=1:length(tempos_candidats)    % Pour toute les notes
    if(tempos_candidats(i)<bornes_classes_notes(1)*tempo)
        liste_note(i) = 9; %ronde
    elseif(tempos_candidats(i)>bornes_classes_notes(1)*tempo & tempos_candidats(i)<bornes_classes_notes(2)*tempo)
        liste_note(i) = 8; %blanche pointée
    elseif(tempos_candidats(i)>bornes_classes_notes(2)*tempo & tempos_candidats(i)<bornes_classes_notes(3)*tempo)
        liste_note(i) = 7; % blanche
    elseif(tempos_candidats(i)>bornes_classes_notes(3)*tempo & tempos_candidats(i)<bornes_classes_notes(4)*tempo)
        liste_note(i) = 6; % noire pointée
    elseif(tempos_candidats(i)>bornes_classes_notes(4)*tempo & tempos_candidats(i)<bornes_classes_notes(5)*tempo)
        liste_note(i) = 5; % noire
    elseif(tempos_candidats(i)>bornes_classes_notes(5)*tempo & tempos_candidats(i)<bornes_classes_notes(6)*tempo)
        liste_note(i) = 4; % croche pointée
    elseif(tempos_candidats(i)>bornes_classes_notes(6)*tempo & tempos_candidats(i)<bornes_classes_notes(7)*tempo)
        liste_note(i) = 3; % croche
    elseif(tempos_candidats(i)>bornes_classes_notes(7)*tempo & tempos_candidats(i)<bornes_classes_notes(8)*tempo)
        liste_note(i) = 2; % double croche pointée
    else
        liste_note(i) = 1; % double croche
    end
end
%notes_normees= correction_double_croche_pointee( notes_normees, classe_double_croche, tempo, ecart, Fs );
% liste_note=[];
% for(i=[1:length(notes_normees)])
%     liste_note=[liste_note;[tab_nom_duree_notes((classe_double_croche-notes_normees(i))*2+1)]];
% end
% liste_note