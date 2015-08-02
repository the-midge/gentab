function [ notes_normees_modifiees ] = correction_double_croche_pointee( notes_normees, classe_double_croche, tempo, ecarts, Fs )
% correction_double_croche_pointee.m
%   USAGE:
%       [ notes_normees_modifiees ] = correction_double_croche_pointee( notes_normees, classe_double_croche, tempo, ecarts )
%   ATTRIBUTS:
%       notes_normees_modifiees: ce vecteur doit remplacer 'notes_normees'
%       
%       notes_normees: Ce vecteur contient les notes sous forme de "tempos
%       normalisés" par octave dans le domaines 4:0.5:9
%
%       classe_double_croche: classe des double-croches calculée a priori
%       dans le domaine 4:0.5:9
%
%       tempo: tempo final arrondi au nombre pair le plus proche
%
%       ecarts: vecteurs des écarts entre les bornes des segments (en nb
%       d'échantillons).
%
%       Fs: fréquence d'échantillonnage
%
%   BUT:
%       Les doubles croches pointées sont rares... On considère donc que 
%       pour une mesure intérmédiaire entre une double croche et une 
%       double croche pointée, il y a une plus grande probabilité qu'il 
%       s'agisse d'une double croche. On revoit donc l'estimation de la 
%       classe imédiatement inférieure à celle des doubles croches.
%    
%   RÉSULTATS:
%       Semble fonctionner mais mérite beaucoup plus de tests


    ind_notes_suspectes=find(notes_normees==classe_double_croche-0.5);
    tempo_double_croche=4*tempo;
    tempo_double_croche_pointee=tempo*2^classe_double_croche/2^(classe_double_croche-1.5);
    
    %On refait le calcul des tempos, ça ne coute pas cher
    tempos=(ecarts(2:length(ecarts))./Fs);
    tempos=((60)./tempos);
    notes_normees_modifiees=notes_normees;
    notes_normees_modifiees(ind_notes_suspectes(find(tempos(ind_notes_suspectes)>(tempo_double_croche/2+tempo_double_croche_pointee/2))))=classe_double_croche;

end

