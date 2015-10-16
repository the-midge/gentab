clear all
close all
clc
% Script de generation aleatoire d'une suite de note
% pour etablir un standard d'exportation des resultats (MIDI like)
nbNotes = 10;

dur = round(15*rand(nbNotes, 1)) +1; % duree : entier positif entre 1 et 16
ton = round(11*rand(nbNotes, 1)) +1; % ton : entier positif entre 1 et 12
oct = round(4*rand(nbNotes, 1)) + 2; % octave : entier positif entre 2 et 6

%% generation de la sequence
%etablissement de l echelle des temps relatifs (en indice)
i = 1;
ind = zeros(size(dur));

for i = 1:nbNotes 
    if(i == 1)
        ind(i) = 0;
    else
        ind(i) = ind(i - 1) + dur(i - 1);
    end
end

%etablissement d'une sequence de notes (utile pour la conversion MIDI ?)
for j = 1:nbNotes
    sequence(j) = Note(ind(j), dur(j), ton(j), oct(j));
    infoNote(sequence(j));
end

% Taille de la sequence
nbIndTotal = sum(dur)
t = (1:nbIndTotal)';


notes = zeros(size(t));

% for k = 1:length(ind) -1
%     onset(ind(k), 1) = ton(k);
%         for l = 1:dur(k)
%             onset(ind(k)+l, 1) = ton(k);
%         end
% end

%% Piano Roll

% determination de la hauteur des notes
for k = 1:length(ind) -1
    notes(ind(k) +1, 1) = ton(k)*oct(k);
end

% determination de la duree des notes
for l = 1:length(notes)
    if(notes(l) == 0)
        notes(l) = notes(l-1);
    end
end

% piano roll
figure(1), clf, plot(t, notes, 'o')
set(gca,'ytick', 0:1:max(ton)*max(oct)+1)
axis([0 nbIndTotal 0 (max(ton)*max(oct))+1])
grid on






