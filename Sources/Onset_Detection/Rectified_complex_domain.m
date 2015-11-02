function RCD_out=Rectified_complex_domain(stft,fMin,fMax,Fs,N)



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
    
           
           
            X_RCD(:,:)=zeros(size(Phi));
            
            for n=2:Nbre
                for k=1:TailleFenetrage
                    if(abs(SignalFrame(k,n))>abs(SignalFrame(k,n-1)))
                         X_RCD(k,n)=abs(SignalFrame(k,n)-X_t(k,n));
                    else
                        X_RCD(k,n)=0;
                    end
                end
            end 
            
            for n=1:TailleFenetrage            
            CD=X_RCD(n,:);
            end 
            RCD_out=CD';
           
end

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            %  Rectified complex domain onset detection
%             for n=2:Nbre
%             X_RCD(:,n)=abs(SignalFrame(:,n))-abs(SignalFrame(:,n-1));
%             end
%             
%             [ligne colonne]=find(X_RCD(:,:)<0);
%             
%              for i=1:size(ligne)
%                 X_RCD(ligne(i),colonne(i))=0;
%              end
%                 
%              CD=abs(X_RCD(n,:)-X_t(n,:));
%            
%             
%             
%              figure(2),plot(t,abs(stft));
%              figure(3),plot(CD)
%   
