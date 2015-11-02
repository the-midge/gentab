function CD_out=Complex_Domain(stft,fMin,fMax,Fs,N)




%[stft, t, f] = stft(x, Fs, 60, h, NFFT);




            % Cette fonction retourne un vecteur de nImages, contenant l'onset detection
            % dans le signal entre fMin et fMax en utilisant la différence
            % spectrale complexe
           
           
            IFmin = max(1,round(fMin/Fs*N)); % fmin réduite au fenêtrage de hamming
            IFmax = round(min(fMax/2,fMax/Fs*N));% fmax réduite au fenêtrage de hamming
            
            SignalFrame = stft(IFmin:IFmax,:); % on prend la transformée de fourier dans la fréquence réduite
            
            TailleFenetrage = size(SignalFrame,1); % nombre de fréquences 
            Nbre = size(SignalFrame,2); % nombre d'indices (temps)
            
            Phi = (angle(SignalFrame(:,:))); % on calcule toutes les phases de toutes les fréquences du signal
            Phi_renverse=Phi';
            Phi_derive_temp= diff(Phi_renverse); 
            Phi_derive=[Phi_derive_temp' zeros(TailleFenetrage,1)];
             
            X_t=zeros(size(Phi));
            
            for n=3:Nbre       
            X_t(:,n)=abs(SignalFrame(:,n-1)).*exp(Phi(:,n-1)+Phi_derive(:,n-1));
            end 
            
            %  complex domain onset detection
    
            for n=1:TailleFenetrage            
            CD=abs(SignalFrame(n,:)-X_t(n,:));
            end 
           
            CD_out=CD';
       %  CD(:) = 1/max(abs(CD(:))).*CD(:);     
            
end
