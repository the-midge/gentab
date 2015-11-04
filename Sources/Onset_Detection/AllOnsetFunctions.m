%% Définition des paramètres de prétraitement
%Paramètres de la stft
N=2^11; h=190;   %fonctionne bien pour h=441

% Degré de lissage
degreLissage=round(Fs/h/10);

%% Début de l'algorithme
% Stft (Short-Time Fourier Transform)
[stftRes, t, f]=stft(x, Fs, 2^11, h, N); %Ces paramètres semblent ceux donnant les meilleurs résultats à ce jour
% Filtre pour éliminer les parasites
[B, A]=butter(2, [0.2 0.9999], 'stop'); %Un filtre coupe-bande qui ne garde que les 20%plus basses fréquences et les 0.1% plus hautes.

for k=1:2
    switch k
        case 1            
            %Pseudo complex domain
            onsetRes(:,k)=getOnsets(stftRes,70,1500,Fs,N);
        case 2
            %Spectral flux
            onsetRes(:,k)=spectralflux(stftRes);
        case 3
            %Phase Deviation
            onsetRes(:,k)=phase_deviation(stftRes, 70, 1500,Fs, N);
        case 4
            %Complex Domain
            onsetRes(:,k)=Complex_Domain(stftRes, 70, 1500,Fs, N);
        case 5
            %Rectified Complex Domain
            onsetRes(:,k)=Rectified_complex_domain(stftRes, 70, 1500,Fs, N);
    end
end

%Filtrage
onsetRes=filter(B,A,onsetRes);
onsetRes=filtfilt(ones(degreLissage,1)/degreLissage, 1, onsetRes);
onsetRes=zscore(onsetRes);