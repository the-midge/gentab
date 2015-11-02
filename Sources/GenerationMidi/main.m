clear all
close all
clc
%% Script :
% Ce script decrit les etapes de la transformation d'un signal
% representant les notes en sortie de la chaine de traitement a partir de
% laquelle on veut generer un fichier MIDI lisible par un logiciel de
% generation de tablature ou partition (Guitar Pro, etc...)
%
% Etapes :
%
% 1) Generation aleatoire d'un signal representant une suite de notes
% 2) Pre traitement
% 3) Construction de la matrice pour conversion MIDI 
% 4) Piano Roll
% 5) Conversion MIDI

%% Generation aleatoire d'un signal représentant une suite de notes.
nbNotes = 12;

dur = round(15*rand(nbNotes, 1)) +1; % duree : entier positif entre 1 et 16
ton = round(12*rand(nbNotes, 1)); % ton : entier positif entre 0 et 12
oct = round(4*rand(nbNotes, 1)) + 2; % octave : entier positif entre 2 et 6

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

% Taille de la sequence
nbIndTotal = sum(dur)
k = (0:nbIndTotal)';

% etablissement de la sequence + display
for j = 1:nbNotes
    sequence(j) = Note(ind(j), dur(j), ton(j), oct(j));
    infoNoteHuman(sequence(j)); 
end

%% Pre traitement
% On considere ici une partition en 4/4

tempo = 120; % bpm par defaut
tempoSeconde = tempo/60; % bps : unite de temps
unitDuree = 1/16; % unite minimale relative par defaut : double croche = 1/4 de temps pour mesure 4/4 donc 1/4*1/4 = 1/16

FsMidi = tempoSeconde*unitDuree; % Frequence d'echantillonage pour pre traitement
t = k*FsMidi; % echelle des temps du pretraitement

%% Construction de la matrice pour conversion MIDI 
% La matrice de pre traitement (notes) est definie par rapport a la matrice
% attendue au moment de la generation du fichier MIDI.
%
% La fonction matrix2midi (provenant du projet matlab-midi :
% https://github.com/kts/matlab-midi) a besoin des infos 
% suivantes pour structurer le fichier final :
%
% 1/ track : nombre de pistes de donnees MIDI
% 2/ channel : nombre de cannaux MIDI de transmission de pistes
% 3/ numero de note : ton + 15 + octave * 12 = numero de note
% 4/ velocity : volume de la note
% 5/ "on" : debut de la note sur l'echelle des temps
% 6/ "off" : fin de la note sur l'echelle des temps

notes = zeros(nbNotes, 6); % matrice de pretraitement

for j = 1:nbNotes
    notes(j, 1) = 1; % Track par defaut : 1
    notes(j, 2) = 1; % Channel par defaut : 1
    notes(j, 3) = sequence(j).ton + 15 + sequence(j).octave*12; % numero de note
    notes(j, 4) = 95; % velocity par defaut : 95
        
    if(j == 1) % instant "on" de la note
        notes(j, 5) = 0; 
    else
        notes(j, 5) = notes(j-1, 6);
    end
    
    notes(j, 6) = notes(j, 5) + sequence(j).duree*FsMidi; % instant "off" de la note        
end

% Toutes les notes portant le numero 15 sont des silences qu'il faut
% exclure de la matrice. 
notes(find(notes(:, 3) == 15), :) = [];

%% Piano Roll

pianoRoll = ones(size(k)).*-1;

% determination de la hauteur des notes
for n = 1:length(ind)
    pianoRoll(ind(n) +1, 1) = ton(n);
end

% determination de la duree des notes
for l = 1:length(pianoRoll)
    if(pianoRoll(l) == -1)
        pianoRoll(l) = pianoRoll(l-1);
    end
end

% piano roll
% les notes a 0 representent les silences
figure(2), clf, plot(t, pianoRoll, 'o')
set(gca,'ytick', -1:1:13)
axis([0 t(end) -1 13])
grid on

%% Conversion MIDI

% Generation du fichier midi
midi = matrix2midi(notes);
writemidi(midi, 'testout.mid');
