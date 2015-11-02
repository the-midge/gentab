function CD_out=phase_deviation(stft,fMin,fMax,Fs,N)

            % Cette fonction retourne un vecteur de nImages, contenant l'onset detection
            % dans le signal entre fMin et fMax en utilisant la deviation
            % de phase
           
            IFmin = max(1,round(fMin/Fs*N)); % fmin réduite au fenêtrage de hamming
            IFmax = round(min(fMax/2,fMax/Fs*N));% fmax réduite au fenêtrage de hamming
            
            SignalFrame = stft(IFmin:IFmax,:); % on prend la transformée de fourier dans la fréquence réduite
            
            TailleFenetrage = size(SignalFrame,1); % nombre de fréquences 
            Nbre = size(SignalFrame,2); % nombre d'indices (temps)
            
            Phi = (angle(SignalFrame(:,:))); % on calcule toutes les phases de toutes les fréquences du signal
            Phi_renverse=Phi';
            Phi_derive_temp= diff(Phi_renverse); 
            Phi_derive=[Phi_derive_temp' zeros(TailleFenetrage,1)]; % dérivée première de la phase
            Phi_derive_temp=Phi_derive';
            Phi_derive_temp_deux= diff(Phi_derive_temp);
            Phi_derive_2=Phi_derive_temp_deux';
            Phi_derive_2=[Phi_derive_2 zeros(TailleFenetrage,1)];

           
            for n=1:TailleFenetrage            
              ph_d=1/N.*abs(Phi_derive_2(n,:));
              %ph_d=abs(SignalFrame(n,:).*Phi_derive_2(n,:))./abs(SignalFrame(n,:));
            end 
   
           CD_out=ph_d';
end


