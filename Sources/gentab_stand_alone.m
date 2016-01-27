%%%
% gentab_stand_alone.m
% Ce script charge un fichier audio et exécute tout l'algorithme, sans
% évaluation, sans affichage, avec génération du fichier de sortie. 

close all
clc
beep off

addpath(genpath('../GenTab/'))
% [~, cheminFichier, ~]=getConfig();

%% Chargement des données
[x,Fs]=audioread(audioFilename);
x=sum(x,2);  

OnsetDetection;
[segments, bornes]=segmentation(x, length(oss), sampleIndexOnsets, Fs, sampleIndexOffsets(length(sampleIndexOffsets)));

%% Analyse rythmique
[durees, tempo, silences, sampleIndexOffsets] = AnalyseRythmique(oss, bornes, FsOSS, Fs, sampleIndexOnsets, sampleIndexOffsets, 0);
correctionDureeNotes;

%% Analyse harmonique
AnalyseHarmonique;

%% Mise en forme des résultats
notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss), silences, dureesCorrigees, notesJouees);  

%% Évaluation des résultats
out = strcat(exportDir, '/', fileName, '.mid');
generationMidi;