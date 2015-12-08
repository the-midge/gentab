%%%
% gentab_all_OD.m
% Ce script teste tous les morceaux avec la fonction d'OD
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


disp('D: Onset Detection des fichiers audios (D: Display)');
disp('ND: Idem (ND: No Display)');
disp('OUT: Sortie');

D='D';
ND='ND';

OUT='OUT';
% choixAlgo=input('Choix? ');

choixAlgo=ND;
%% Onset Detection
if(~strcmp(choixAlgo, OUT)) % Dans tout les cas sauf une sortie
    disp('1:	DayTripper - 8s');
    disp('2:	Aller Retour Diatonique - 8s');
    disp('3:	Heart & Soul - 16s');
    disp('4:	No Surprises - 26s');
    disp('5:	Seven Nation Army - 30s');
    disp('6:	Hardest Button to Button - 35s');
    disp('7:	Johnny B Good - 47s');
    disp('8:	Voodoo Child - 40s');
    disp('9:	Kashmir - 33s');
    disp('10:   Time is Running Out - 24s');
    for k=1:10
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
            case 7
                audioFilename='Johnny_B_Good.wav';
            case 8
                audioFilename='Voodoo_Child.wav';
            case 9
                audioFilename='Kashmir.wav';
            case 10
                audioFilename='Time_Running_Out.wav';
        end
        [x,Fs]=audioread(audioFilename);
        x=x(:,1);
        if( k==1)   % Cas particulier de Day Tripper
            x=x(1:Fs*8,1);
        end
        if(strcmp(choixAlgo, D))
            figure(k),       
        end
        OnsetDetection;   
        if(strcmp(choixAlgo, ND))
            close all
        end
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss));
        tempo = 0;
        
        [~, file, ~]=fileparts(audioFilename);
        filename = strcat('DATA/', file, '/expected.txt');
        [txFDetection(k), txDetectionManquante(k), txReussite(k), ecartMoyen(k)] = evaluateOD(filename, notesDet);
    end
    
    [txFDetection', txDetectionManquante', txReussite']
    [MIN, worst] = min(txReussite);
    MEAN = mean(txReussite);
    [MAX, best] = max(txReussite);
  
    disp(['Worst is n°', num2str(worst), ' with ', num2str(MIN), '%']);
    disp(['Best is n°', num2str(best), ' with ', num2str(MAX), '%']);
    disp(['Mean is ', num2str(MEAN), '%']);
    clear D ND OUT;
    break;
end

if(strcmp(choixAlgo, OUT))
    close all
    clear all
end