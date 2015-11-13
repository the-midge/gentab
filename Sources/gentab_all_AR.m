%%%
% gentab_all_AR.m
% Ce script teste tous les composants de l'algorithme à partir 
% d'un signal audio qu'il charge lui même
%


close all
beep off

addpath(genpath('../Sources'))

%% Éxécution

disp('AR: Analyse rythmique des fichiers audios');
disp('OUT: Sortie');

AR='AR';

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
        [segments, bornes]=segmentation(x, length(sf), sampleIndexOnsets, Fs);
        [durees, tempo, features(:,k)] = AnalyseRythmique(sf, bornes, FsSF, Fs, 0);
        
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(sf), durees);
        tempos(k) = tempo;
        
        [~, file, ~]=fileparts(audioFilename);
        filename = strcat('DATA/', file, '/expected.txt');
        [ecartTempo(k), tempoExp(k)]=evaluateTempo(filename, tempo);        
    end
    
    [tempos', tempoExp', ecartTempo']
    [MIN, worst] = min(tempos);
    MEAN = mean(tempos);
    [MAX, best] = max(tempos);
  
%     disp(['Worst is n°', num2str(worst), ' with ', num2str(MIN), '%']);
%     disp(['Best is n°', num2str(best), ' with ', num2str(MAX), '%']);
%     disp(['Mean is ', num2str(MEAN), '%']);
    clear OD OUT;
    break;
end

if(strcmp(choixAlgo, OUT))
    close all
    clear all
end