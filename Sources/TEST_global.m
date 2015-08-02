%%%
% TEST_Global.m
% Ce script teste tous les composants de l'algorithme à partir 
% d'un signal audio qu'il charge lui même
%

clear all
close all
clc

addpath(genpath('..\sources')); %Permet l'accès à tous les fichiers du dossier sources

%% Chargement des données
atmosphere='Atmosphere_D';  %Correspond à une série de fichiers audio présent dans \Data
disp('Fichier audio en entrée?');
disp('1: Day Tripper - 8 sec');
disp('2: Notes variées - 34 sec');
disp('3: Mélange notes et silences - 12s');
disp(['4: ' atmosphere ' - 4s']);
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
        [x,Fs,Nbits]=wavread('Day_Tripper.wav');
        x=x(1:Fs*8,1);
    case 2
        disp('Notes Variées');
        %Où un echantillon généré logiciellement contenant de la guitare et des
        %durées de notes variées.

        [x,Fs,Nbits]=wavread('Echantillon_34_secondes_notes_variees.wav');
        x=x(1:Fs*34,1);
    case 3
        disp('Notes et silences');
        %Où un echantillon (12s) généré logiciellement contenant de la guitare et des
        %silences (croches et noires et à la fin un silence d'une ronde et demie

        [x,Fs,Nbits]=wavread('silences.wav');
        x=x(1:Fs*12,1);
    case 4
        disp(atmosphere);

        [x,Fs,Nbits]=wavread([atmosphere '.wav']);
        x=x(:,1);
    case 5
        disp('Aller-Retour chromatique');
        % Toutes les notes de E2 à A4 sont jouées avec environ le même
        % intervalle entre chaque (croches).        
        [x,Fs,Nbits]=wavread('aller-retour-chromatique.wav');
        x=x(:,1);
    case 6
        disp('Blue Orchid');
        % Enregistrement en guitare claire d'un riff complet de la chanson
        % Blue Orchid des White Stripes
        
        [x,Fs,Nbits]=wavread('Blue_Orchid_sans_dead_note_avec_bend.wav');
        x=x(:,1);
    case 7
        disp('Mad World');
        % Enregistrement en guitare claire d'un arpège de l'intro de Mad
        % World de Gary Jules
        
        [x,Fs,Nbits]=wavread('gary_jules_mad_world_acoustic_intro.wav');
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
disp('ID: Identification des notes + OD + SEG');
disp('RY: Détermination de la composition rythmique + OD + SEG');
disp('ALL: Tous les algorithmes précédents');
disp('OUT: Sortie');

OD='OD';
SEG='SEG';
ID='ID';
RY='RY';
ALL='ALL';
OUT='OUT';
choix_algo=input('Choix? ');

clc
switch upper(choix_algo)
    case 'OD'
        disp('Onset Detection');
        %% Onset Detection
        GENE_TestOnsetDetection
        
    case 'SEG'
        disp('Onset Detection + Segmentation');
        %% Onset Detection
        GENE_TestOnsetDetection;
        
        %% Segmentation
        [L, bornes]=segmentation(x, sf, [pks, loc], Fs);
        
    case 'ID'
        disp('Onset Detection + Segmentation + Identification des notes');
        %% Onset Detection
        GENE_TestOnsetDetection;
        
        %% Segmentation
        [L, bornes]=segmentation(x, sf, [pks, loc], Fs);
        
        %% Détermination des notes
        GENE_determination_notes;
    case 'RY'
        disp('Onset Detection + Segmentation + Détermination de la composition rythmique');
        %% Onset Detection
        GENE_TestOnsetDetection;
        
        %% Segmentation
        [L, bornes]=segmentation(x, sf, [pks, loc], Fs);
        
        %% Analyse rythmique
        GENE_analyse_composition_rythmique;
    case 'ALL'
        disp('Onset Detection + Segmentation + Identification des notes + Détermination de la composition rythmique');
        %% Onset Detection
        GENE_TestOnsetDetection;
        
        %% Segmentation
        [L, bornes]=segmentation(x, sf, [pks, loc], Fs);
        
        %% Analyse rythmique
        GENE_analyse_composition_rythmique;
        
        %% Détermination des notes
        GENE_determination_notes;
   case 'OUT'
        clc
        clear all;
        break;
    otherwise
    disp('Erreur');
end
clear OD SEG ID RY ALL OUT;