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


%% Prétraitement
% TODO:
%   Intégrer ici des traitements sur le signal qui doivent être exécutés
%   avant toute opérations.

%% Éxécution
%   Réquête utilisateur et exécution de tout où partie de l'algorithme


disp('OD: Onset Detection des fichiers audios');
disp('OUT: Sortie');

OD='OD';

OUT='OUT';
choixAlgo=input('Choix? ');

clc

%% Onset Detection
if(~strcmp(choixAlgo, OUT)) % Dans tout les cas sauf une sortie
        audioFilename='heart-and-soul-tux.wav';
        [x,Fs]=audioread(audioFilename);
        x=x(:,1);
        OnsetDetection;
        title(audioFilename);
        audioFilename='ar-diatonique-tux.wav';
        [x,Fs]=audioread(audioFilename);
        x=x(:,1);
        OnsetDetection;
        title(audioFilename);
        audioFilename='DayTripper.wav';
        [x,Fs]=audioread(audioFilename);
        x=x(1:Fs*8,1);
        OnsetDetection; 
        title(audioFilename);
        audioFilename='BlueOrchidSansDeadNoteAvecBend.wav';
        [x,Fs]=audioread(audioFilename);
        x=x(1:Fs*30,1);
        OnsetDetection; 
        title(audioFilename); 
end


if(strcmp(choixAlgo, OUT))
    clc
    close all
    clear all
end
clear OD OUT;

