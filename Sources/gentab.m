%%%
% gentab.m
% Ce script teste tous les composants de l'algorithme à partir 
% d'un signal audio qu'il charge lui même
%

clear all
close all
clc
beep off

addpath(genpath('..\sources')); %Permet l'accès à tous les fichiers du dossier sources

%% Chargement des données
disp('Fichier audio en entrée?');
disp('1: Day Tripper - 8 sec');
disp('2: Notes variées - 34 sec');
disp('3: Mélange notes et silences - 12s');
disp('5: Aller-retour chromatique - 18s');
disp('6: Blue Orchid (bends) - 30s');
disp('7: Mad World (intro) - 33s');
disp('9: Sortie');

choix_echantillon=input('Choix? '); %Attend une action utilisateur
clc
switch choix_echantillon
    case 1
        disp('Day Tripper');
        % On selectionne Les 8 premières secondes de la chanson Day Tripper des
        % Beatles
        % Dans cet échantillon, de la guitare est jouée en solo
        relative_path = '\DATA\sons\Day_Tripper\';
        audio_filename='Day_Tripper.wav';
        [x,Fs,Nbits]=wavread(audio_filename);
        x=x(1:Fs*8,1);
    case 2
        disp('Notes Variées');
        %Où un echantillon généré logiciellement contenant de la guitare et des
        %durées de notes variées.
        audio_filename='Echantillon_34_secondes_notes_variees.wav';
        [x,Fs,Nbits]=wavread(audio_filename);
        x=x(1:Fs*34,1);
    case 3
        disp('Notes et silences');
        %Où un echantillon (12s) généré logiciellement contenant de la guitare et des
        %silences (croches et noires et à la fin un silence d'une ronde et demie
        audio_filename='silences.wav';
        [x,Fs,Nbits]=wavread(audio_filename);
        x=x(1:Fs*12,1);
    case 4

    case 5
        disp('Aller-Retour chromatique');
        % Toutes les notes de E2 à A4 sont jouées avec environ le même
        % intervalle entre chaque (croches).
        audio_filename='aller-retour-chromatique.wav';
        [x,Fs,Nbits]=wavread(audio_filename); 
        x=x(:,1);
    case 6
        disp('Blue Orchid');
        % Enregistrement en guitare claire d'un riff complet de la chanson
        % Blue Orchid des White Stripes
        relative_path = 'Data/sons/Blue_Orchid_sans_dead_note_avec_bend';
        audio_filename='Blue_Orchid_sans_dead_note_avec_bend.wav';
        [x,Fs,Nbits]=wavread(audio_filename);
        x=x(:,1);
    case 7
        disp('Mad World');
        % Enregistrement en guitare claire d'un arpège de l'intro de Mad
        % World de Gary Jules
        audio_filename='gary_jules_mad_world_acoustic_intro.wav';
        [x,Fs,Nbits]=wavread(audio_filename); 
        x=x(:,1);
    case 9
        clc
        clear all;
        break;
        
    otherwise
    disp('Erreur');
end

clear choix_echantillon;

%% Prétraitement
% TODO:
%   Intégrer ici des traitements sur le signal qui doivent être exécutés
%   avant toute opérations.

%% Éxécution
%   Réquête utilisateur et exécution de tout où partie de l'algorithme

disp('Algo à exécuter?');
disp('OD: Onset Detection');
disp('SEG: Segmentation + OD');
disp('AH: Analyse harmonique (Identification des notes jouées) + OD + SEG');
disp('AR: Analyse Rythmique (Détermination de la composition rythmique) + OD + SEG');
disp('ALL: Tous les algorithmes précédents');
disp('OUT: Sortie');

OD='OD';
SEG='SEG';
AH='AH';
AR='AR';
ALL='ALL';
OUT='OUT';
choix_algo=input('Choix? ');

clc

%% Onset Detection
if(~strcmp(choix_algo, OUT)) % Dans tout les cas sauf une sortie
        GENE_TestOnsetDetection;
end
    
%% Segmentation
if(~strcmp(choix_algo, OUT) & ~strcmp(choix_algo, OD)) % Dans tout les cas sauf une sortie ou OD
        [segments, bornes]=segmentation(x, length(sf), sample_index_onsets, Fs);
end

%% Analyse rythmique
if(strcmp(choix_algo, AR) | strcmp(choix_algo, ALL));
    GENE_analyse_composition_rythmique;
end
    
%% Analyse harmonique
if(strcmp(choix_algo, AH) | strcmp(choix_algo, ALL));
    GENE_determination_notes;
end

if(strcmp(choix_algo, OUT))
    clc
    close all
    clear all
end
clear OD SEG AH AR ALL OUT;