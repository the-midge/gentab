%%%
% gentab.m
% Ce script teste tous les composants de l'algorithme à partir 
% d'un signal audio qu'il charge lui même
%

clear all
close all
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


%% Onset Detection
if(~strcmp(choixAlgo, OUT)) % Dans tout les cas sauf une sortie
    disp('1: DayTripper - 8s');
    disp('2: Aller Retour Diatonique - 8s');
    disp('3: Heart & Soul - 16s');
    disp('4: No Surprises - 26s');
    disp('5: Seven Nation Army - 30s');
    disp('6: Hardest Button to Button - 35s');

    for k=1:6
        switch(k)
            case 1                
                audioFilename='DayTripper.wav';
            case 2
                audioFilename='ar-diatonique-tux.wav';
            case 3
                audioFilename='heart-and-soul-tux.wav';
            case 4
                audioFilename='nosurprises.wav';
            case 5              
                audioFilename='seven-nation-army.wav';
            case 6
                audioFilename='hardest-button.wav';
        end
        [x,Fs]=audioread(audioFilename);
        x=x(:,1);
        if( k==1)   % Cas particulier de Day Tripper
            x=x(1:Fs*8,1);
        end
        
        figure(k),       
        
        OnsetDetection;        
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(sf));
        tempo = 0;
        
        [~, file, ~]=fileparts(audioFilename);
        filename = strcat('DATA/', file, '/expected.txt');
        [txFDetection(k), txDetectionManquante(k), txReussite(k), ecartMoyen(k)] = evaluateOD(filename, notesDet);
        
        %         AllOnsetFunctions;
        %         plot(t, onsetRes)
        %         legend('Pseudo complex domain',...
        %                'Spectral flux',...
        %                'Phase Deviation',...
        %                'Complex Domain',...
        %                'Rectified Complex Domain')
        %         title(audioFilename);
        %         
        %         clear onsetRes;
    end
    
    [txFDetection', txDetectionManquante', txReussite']
    [MIN, worst] = min(txReussite);
    MEAN = mean(txReussite);
    [MAX, best] = max(txReussite);
  
    disp(['Worst is n°', num2str(worst), ' with ', num2str(MIN), '%']);
    disp(['Best is n°', num2str(best), ' with ', num2str(MAX), '%']);
    disp(['Mean is ', num2str(MEAN), '%']);
    clear OD OUT;
    break;
end

if(strcmp(choixAlgo, OUT))
    close all
    clear all
end