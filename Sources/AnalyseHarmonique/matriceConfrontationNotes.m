% clear all
% clc

load ../DATA/seven-nation-army/noteExp.mat

tons = ['E';'E'; 'G'; 'E'; 'D'; 'C'; 'B'; 'E' ;'E'; 'G'; 'E'; 'D' ;'C' ;'D'; 'C'; 'B' ;'E' ;'E' ;'G' ;'E'; 'D' ;'C' ;'B' ;'E'; 'E' ;'G'; 'E' ;'D'; 'C'; 'D' ;'C' ;'B'; 'G' ;'G' ;'G' ;'G' ;'G'; 'A' ;'A' ;'A' ;'A' ;'A' ;'A' ;'A' ;'E'; 'C'; 'B'];  
tons(:, 2) = ' ';
tons(:, 3) = '3';

tableNotes = generateTableNotes;
freq_rem = tableNotes(:,:,3);
freq_rem(:);

for index= [1:length(segments)]  
    
    segment=segments{index};
    
    tonsNotes(index,1) = noteExp(index).convertMIDI - 27;

    
    
    %% Calcul de la fft sur le segment
    if(length(segment)<2^19)
        segFftWin=fft(segment.*blackman(length(segment)), 2^15);  %Permet d'assurer une précision suffisante
        %   TODO: rendre ce paamètre de fft dépendant de la longueur du segment
        %   (mais toujours une puissance de 2).
    else
        segFftWin=fft(segment.*blackman(length(segment)));
    end

    % lissage de la transformée de Fourier
    % h=800;
    % degreLissage=round(Fs/h/10);
    % segFftWin=filtfilt(ones(degreLissage,1)/degreLissage, 1, segFftWin);

    % Manipulation de la fft pour l'avoir sous la bonne forme
    y = length(segFftWin);
    % axe_freq = (10:y/2-1-15380)*Fs/y;
    % segFftWin=abs(segFftWin(11:(length(segFftWin)/2-15380)));
    axe_freq = (0:y/2-1)*Fs/y;
    segFftWin=abs(segFftWin(1:(length(segFftWin)/2)));
    
    matriceSegFftWin(index, :) = segFftWin;
    
    indicesNotes(index, 1) = findClosest(axe_freq, freq_rem(tonsNotes(index)));
%     figure,plot(axe_freq,segFftWin)
end




% coef_freq_rem = [0.5 1 2 3 4];
% E = strmatch('E 3', tons);
% 
% mi = matriceSegFftWin(E, :);
% mi = matriceSegFftWin(E, indice_mi*coef_freq_rem);
% mean_mi = mean(mi);





