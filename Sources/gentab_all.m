%%%
% gentab_all.m
% Ce script teste tout

clear all
close all

addpath(genpath('../Sources'))

%% Éxécution

nMorceaux = 11;
%% Onset Detection
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
disp('11:	48 notes - divers rythmes - 4m14s');
h1 = waitbar(0,'Analyse Harmonique...');

for m=1:nMorceaux
    tic
    switch(m)
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
        case 11
            audioFilename='48_dddd_cc_n_n.wav';
            disp(audioFilename);            
    end
    waitbar((m-1)/((nMorceaux)*5),h1,strcat(num2str(m-1), '/', num2str(nMorceaux), ': ', audioFilename));

    [x,Fs]=audioread(audioFilename);
    x=x(:,1);
    if( m==1)   % Cas particulier de Day Tripper
        x=x(1:Fs*8,1);
    end

    %% OD + SEG
    OnsetDetection;   
    if exist('FsSF', 'var')
        FsOSS=FsSF;
        oss=sf;
    end
    
    if exist('sampleIndexOffsets', 'var')
        [segments, bornes]=segmentation(x, length(oss), sampleIndexOnsets, Fs, sampleIndexOffsets(length(sampleIndexOffsets)));
    else
        [segments, bornes]=segmentation(x, length(oss), sampleIndexOnsets, Fs);
    end
    waitbar(((m-1)*5+1)/((nMorceaux)*5),h1,strcat(num2str(m-1), '/', num2str(nMorceaux), ': ', audioFilename));

    %% AH
    AnalyseHarmonique;
    waitbar(((m-1)*5+2)/((nMorceaux)*5),h1,strcat(num2str(m-1), '/', num2str(nMorceaux), ': ', audioFilename));

    %% AR
    if exist('sampleIndexOffsets', 'var')
        [durees, temposDetecte(m), silences, sampleIndexOffsets] = AnalyseRythmique(oss, bornes, FsOSS, Fs, sampleIndexOnsets, sampleIndexOffsets, 0);
    else
        [durees, temposDetecte(m)] = AnalyseRythmique(oss, bornes, FsOSS, Fs, sampleIndexOnsets, 0);
    end
    if exist('correctionDureeNotes', 'file')
        correctionDureeNotes;
    end
    waitbar(((m-1)*5+3)/((nMorceaux)*5),h1,strcat(num2str(m-1), '/', num2str(nMorceaux), ': ', audioFilename));

    %% MeF + eval
    if exist('silences', 'var')
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss), silences, dureesCorrigees, notesJouees);  
    elseif exist('dureesCorrigees', 'var')
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss), dureesCorrigees, notesJouees);  
    else
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss), durees, notesJouees);  
    end

    [~, file, ~]=fileparts(audioFilename);
    filename = strcat('DATA/', file, '/expected.txt');
    [confTons(:,:,m), confOctaves(:,:,m)]=evaluateAH(filename, notesDet, 0);
    [confDurees(:,:,m)]=evaluateAR(filename, notesDet, temposDetecte(m), 0);

    [txFDetection(m), txDetectionManquante(m), txReussite(m), ecartMoyen(m)] = evaluateOD(filename, notesDet);

    tauxTons(m)=	sum(diag(confTons(:,:,m)))/sum(sum(confTons(:,:,m)))*100;
    tauxOctaves(m)=	sum(diag(confOctaves(:,:,m)))/sum(sum(confOctaves(:,:,m)))*100;
    tauxDurees(m)=	sum(diag(confDurees(:,:,m)))/sum(sum(confDurees(:,:,m)))*100;

    [ecartTempo(m), tempoExp(m)]=evaluateTempo(filename, temposDetecte(m)); 
    
    waitbar(((m-1)*5+4)/((nMorceaux)*5),h1,strcat(num2str(m-1), '/', num2str(nMorceaux), ': ', audioFilename));

    %% Tempo impose
    tempoImpose = tempoExp(m);
    if exist('sampleIndexOffsets', 'var')
        [dureesImposees, ~, silences, sampleIndexOffsets] = AnalyseRythmique(oss, bornes, FsOSS, Fs, sampleIndexOnsets, sampleIndexOffsets, 0, tempoImpose);
    else
        [dureesImposees, ~] = AnalyseRythmique(oss, bornes, FsOSS, Fs, sampleIndexOnsets, 0, tempoImpose);
    end
    
    if exist('correctionDureeNotes', 'file')
        durees=dureesImposees;
        correctionDureeNotes;
    end
    
    if exist('silences', 'var')
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss), silences, dureesCorrigees, notesJouees);  
    elseif exist('dureesCorrigees', 'var')
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss), dureesCorrigees, notesJouees);  
    else
        notesDet = miseEnForme(sampleIndexOnsets,  length(x)/length(oss), durees, notesJouees);  
    end
    
    [confDureesImpose(:,:,m)]=evaluateAR(filename, notesDet, temposDetecte(m), 0);
    tauxDureesImposees(m)=	sum(diag(confDureesImpose(:,:,m)))/sum(sum(confDureesImpose(:,:,m)))*100;
    waitbar(((m-1)*5+5)/((nMorceaux)*5),h1,strcat(num2str(m-1), '/', num2str(nMorceaux), ': ', audioFilename));
    
    disp(['Taux de succès tons: ' num2str(tauxTons(m)) '%']);
    disp(['Taux de succès octaves: ' num2str(tauxOctaves(m)) '%']);
    disp(['Taux de succès durées (tempo libre): ' num2str(tauxOctaves(m)) '%']);
    disp(['Taux de succès durées (tempo imposé): ' num2str(tauxDureesImposees(m)) '%']);
    toc

end
close(h1);