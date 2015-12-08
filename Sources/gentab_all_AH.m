%%%
% gentab_all_AH.m
% Ce script teste tous les composants de l'algorithme à partir 
% d'un signal audio qu'il charge lui même
%


close all
beep off

addpath(genpath('../Sources'))

%% Éxécution

disp('D: Analyse harmonique des fichiers audios (D: Display)');
disp('ND: Idem (ND: No Display)');
disp('OUT: Sortie');

D='D';
ND='ND';

OUT='OUT';
choixAlgo=input('Choix? ');

nMorceaux = 10;
%% Onset Detection
if(~strcmp(choixAlgo, OUT)) % Dans tout les cas sauf une sortie
    disp('1: DayTripper - 8s');
    disp('2: Aller Retour Diatonique - 8s');
    disp('3: Heart & Soul - 16s');
    disp('4: No Surprises - 26s');
    disp('5: Seven Nation Army - 30s');
    disp('6: Hardest Button to Button - 35s');
    disp('7: Johnny B Good - 47s');
    disp('8: Voodoo Child - 40s');    
    disp('9:	Kashmir - 33s');
    disp('10:   Time is Running Out - 24s'); 
    
    h1 = waitbar(0,'Analyse Harmonique...');
    for k=1:nMorceaux
        tic
        switch(k)
            case 1                
                audioFilename='DayTripper.wav';
                disp(audioFilename);
            case 2
                audioFilename='ar-diatonique-tux.wav';
                disp(audioFilename);
            case 3
                audioFilename='heart-and-soul-tux.wav';
                disp(audioFilename);
            case 4
                audioFilename='nosurprises.wav';
                disp(audioFilename);
            case 5              
                audioFilename='seven-nation-army.wav';
                disp(audioFilename);
            case 6
                audioFilename='hardest-button.wav';
                disp(audioFilename);
            case 7
                audioFilename='Johnny_B_Good.wav';
                disp(audioFilename);
            case 8
                audioFilename='Voodoo_Child.wav';
                disp(audioFilename);
            case 9
                audioFilename='Kashmir.wav';
                disp(audioFilename);
            case 10
                audioFilename='Time_Running_Out.wav';
                disp(audioFilename);
        end
        waitbar((k-1)/(nMorceaux-1),h1,strcat(num2str(k-1), '/', num2str(nMorceaux), ': ', audioFilename));

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
%             close all
        end
        
        [segments, bornes]=segmentation(x, length(oss), sampleIndexOnsets, Fs);
        AnalyseHarmonique
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss), notesJouees);
        tempo = 0;
        [~, file, ~]=fileparts(audioFilename);
        filename = strcat('DATA/', file, '/expected.txt');
        [confTons, confOctaves]=evaluateAH(filename, notesDet, 0);
        tauxTons(k)=	sum(diag(confTons))/sum(sum(confTons))*100;
        tauxOctaves(k)=	sum(diag(confOctaves))/sum(sum(confOctaves))*100;
        disp(['Taux de succès tons: ' num2str(sum(diag(confTons))/sum(sum(confTons))*100) '%']);
        disp(['Taux de succès octaves: ' num2str(sum(diag(confOctaves))/sum(sum(confOctaves))*100) '%']);
        
        toc

    end
    close(h1);
    [tauxTons' tauxOctaves']
        clear D ND OUT;
    break;
end

if(strcmp(choixAlgo, OUT))
    close all
    clear all
end