function [ notesDet ] = miseEnForme(sampleIndexOnsets,  FsSF, silences, durees, notesJouees)
%miseEnForme.m
%   USAGE:
%       [ notesDet ] = miseEnForme(sampleIndexOnsets,  FsSF, silences, durees, notesJouee)
%       [ notesDet ] = miseEnForme(sampleIndexOnsets,  FsSF, silences, durees)
%       [ notesDet ] = miseEnForme(sampleIndexOnsets,  FsSF, silences, notesJouee)
%       [ notesDet ] = miseEnForme(sampleIndexOnsets,  FsSF)

%	ATTRIBUTS:    
%       notesDet:   Vecteur d'objets Note complété avec les résultats
%       disponibles
%   
%       sampleIndexOnsets:  Indice du début des note dans la base de STFT
%       FsSF:               Rapport entre base d'échantillonnage et base STFT
%       durees:             vecteur contenant les durées des notes au format 1:16
%       notesJouee:         Vecteur contenant les durées des notes au format A#2
%    
%	DESCRIPTION:   
%       Rempli un objet Note pour chaque triplet Onset+durées+ton sauf si
%       certaine variable ne sont pas disponibles
%	BUT:    
%       Mettre en forme les données avant génération de sortie

    if nargin==4
        if isa(durees, 'cell')
            notesJouees = durees;
            clear durees;
        end
    end

    if ~exist('durees', 'var')
        durees=ones(length(sampleIndexOnsets)+length(silences), 1);
    end

    if ~exist('notesJouees', 'var')
        notesJouees{1}='E 2';
        notesJouees=repmat(notesJouees, length(sampleIndexOnsets)+length(silences),1);
    end

    l=1; k=1;
    if isempty(silences)
        maxL=length(sampleIndexOnsets)+1;
    else
        maxL=length(durees)+1;
    end
    while(k<length(sampleIndexOnsets)+~isempty(silences) && l<length(durees))
        if ismember(l, silences) || l>maxL
            notesDet(l)=Note(round((sampleIndexOnsets(k-1)+50)*FsSF), durees(l), 'R 0');
            l=l+1;
        else
            notesDet(l)=Note(round(sampleIndexOnsets(k)*FsSF), durees(l), notesJouees{k});
            l=l+1;
            k=k+1;
        end
    end
end

