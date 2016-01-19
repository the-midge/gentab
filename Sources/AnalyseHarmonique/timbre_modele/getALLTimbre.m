%%%
% gentab_all_AH.m
% Ce script teste tous les composants de l'algorithme à partir 
% d'un signal audio qu'il charge lui même
%


close all
beep off

addpath(genpath('D:\GenTab\Sources'))

[tableNotes] = generateTableNotes(-17,42);
tableNotes=tableNotes(:,:,3);
tableNotes=tableNotes(:);
indexNotesTotal = 1;

nMorceaux = 9;
%% Onset Detection
disp('1: Aller Retour Diatonique - 8s');
disp('2: Heart & Soul - 16s');
disp('3: No Surprises - 26s');
disp('4: Seven Nation Army - 30s');
disp('5: Hardest Button to Button - 35s');
disp('6: Johnny B Good - 47s');
disp('7: Voodoo Child - 40s');    
disp('8:	Kashmir - 33s');
disp('9:   Time is Running Out - 24s'); 
disp('10:	48 notes - divers rythmes - 4m14s');
h1 = waitbar(0,'Analyse Harmonique...');

audioFilenames={'ar-diatonique-tux.wav'; 'heart-and-soul-tux.wav';...
    'nosurprises.wav';'hardest-button.wav';'Johnny_B_Good.wav';...
    'Voodoo_Child.wav';'Kashmir.wav';'Time_Running_Out.wav';...
    '48_dddd_cc_n_n.wav'};
for k=1:nMorceaux
    audioFilename=audioFilenames{k};
    disp(audioFilename);
    waitbar((k-1)/(nMorceaux-1),h1,strcat(num2str(k-1), '/', num2str(nMorceaux), ': ', audioFilename));

    [x,Fs]=audioread(audioFilename);
    x=x(:,1);

    OnsetDetection;   
    [segments, bornes]=segmentation(x, length(oss), sampleIndexOnsets, Fs, sampleIndexOffsets(length(sampleIndexOffsets)));
    [~, file, ~]=fileparts(audioFilename);
    filename = strcat('DATA/', file, '/expected.txt');
    [notesMIDI, onsetsExp] = extractNotes(filename);
    onsetsDet=round(sampleIndexOnsets*length(x)/length(oss));
    
    %% Parcours de toute les notes détectées
    indiceDet = 0;
    indiceExp = 0;
    detInExp = 0;
    expInDet = 0;

    k=1;
    l=1;
    while indiceDet < length(segments)
        if indiceDet < length(segments)
            indiceDet=indiceDet+1;
        end   

        newDetInExp = findClosest(onsetsExp, onsetsDet(indiceDet));
        indiceExp = newDetInExp;
        newExpInDet = findClosest(onsetsDet, onsetsExp(indiceExp));

       if newExpInDet-newDetInExp == expInDet-detInExp && newExpInDet> expInDet         
            %% Calcul de la fft sur le segment
            segment=segments{indiceDet};

            if(length(segment)<2^19)
                segFftWin=fft(segment.*blackman(length(segment)), 2^15);  %Permet d'assurer une précision suffisante
                %   TODO: rendre ce paamètre de fft dépendant de la longueur du segment
                %   (mais toujours une puissance de 2).
            else
                segFftWin=fft(segment.*blackman(length(segment)));
            end
            y=length(segFftWin);
            % axe_freq = (10:y/2-1-15380)*Fs/y;
            % segFftWin=abs(segFftWin(11:(length(segFftWin)/2-15380)));
            axe_freq = (0:y/2-1)*Fs/y;
            segFftWin=abs(segFftWin(1:(length(segFftWin)/2)));

            freqSousHarmonique = tableNotes(notesMIDI(indiceExp)-39); % f0/2
            indiceSousHarmonique = findClosest(axe_freq, freqSousHarmonique); %indice de la sous harmonique dans le vecteur axe_freq
            timbres(indexNotesTotal,:)=sum(segFftWin(bsxfun(@plus, indiceSousHarmonique*[1, 2:2:12],(-4:4)')))./sum(segFftWin);
            indexNotesTotal=indexNotesTotal+1;
       end
       detInExp = newDetInExp;
       expInDet = newExpInDet;
    end

end
close(h1);