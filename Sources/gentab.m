%%%
% gentab.m
% Ce script teste tous les composants de l'algorithme à partir 
% d'un signal audio qu'il charge lui même
%

clear all
close all
clc
beep off

addpath(genpath('../Sources'))

%% Chargement des données
disp('Fichier audio en entrée?');
disp('1: essaiRomain');
disp('2: Blue Orchid (bends) - 30s');
disp('3: essaiRomain - 12s');
disp('4: Sortie');

choixEchantillon=input('Choix? '); %Attend une action utilisateur
clc
switch choixEchantillon
    case 1
        disp('essaiRomain');
        % On selectionne Les 8 premières secondes de la chanson Day Tripper des
        % Beatles
        % Dans cet échantillon, de la guitare est jouée en solo
        audioFilename='essaiRomain.wav';
        [x,Fs]=audioread(audioFilename);
        x=x(1:Fs*12,1);
    case 2
        disp('Blue Orchid (bends)');
        %Où un echantillon généré logiciellement contenant de la guitare et des
        %durées de notes variées.
        audioFilename='Echantillon_34SecondesNotesVariees.wav';
        [x,Fs]=audioread(audioFilename);
        x=x(1:Fs*30,1);
    case 3
        disp('essaiRomain');
        %Où un echantillon (12s) généré logiciellement contenant de la guitare et des
        %silences (croches et noires et à la fin un silence d'une ronde et demie
        audioFilename='essaiRomain.wav';
        [x,Fs]=audioread(audioFilename);
        x=x(1:Fs*12,1);
    
    case 4
        clc
        clear all;
        break;
        
    otherwise
    disp('Erreur');
end

clear choixEchantillon;

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
choixAlgo=input('Choix? ');

clc

%% Onset Detection
if(~strcmp(choixAlgo, OUT)) % Dans tout les cas sauf une sortie
        OnsetDetection;
end
    
%% Segmentation
if(~strcmp(choixAlgo, OUT) & ~strcmp(choixAlgo, OD)) % Dans tout les cas sauf une sortie ou OD
        [segments, bornes]=segmentation(x, length(sf), sampleIndexOnsets, Fs);
end

%% Analyse rythmique
if(strcmp(choixAlgo, AR) | strcmp(choixAlgo, ALL));
    AnalyseRythmique;
end
    
%% Analyse harmonique
if(strcmp(choixAlgo, AH) | strcmp(choixAlgo, ALL));
    AnalyseHarmonique;
end

if(strcmp(choixAlgo, OUT))
    clc
    close all
    clear all
end
clear OD SEG AH AR ALL OUT;