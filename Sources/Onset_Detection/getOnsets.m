 function SigOut = getOnsets(STFT,fMin, fMax, Fs, NFFT)
            %This function returns a vector of length nFrames, containing
            % an onset detection in the signal between frequencies fMin and
            % fMax. It uses the complex spectral difference method.
           
            IFmin = max(1,round(fMin/Fs*NFFT)); % fs*nfft
            IFmax = round(min(fMax/2,fMax/Fs*NFFT));
            
            SignalFrame = STFT(IFmin:IFmax,:,:);
            
            TailleFenetrage = size(SignalFrame,1);
            nCanaux = size(SignalFrame,3);
            Nbre = size(SignalFrame,2);
            SigOut = zeros(size(SignalFrame,2),nCanaux);
            
            for canal = 1:nCanaux
                SigOutInst = zeros(TailleFenetrage,1);
                CurrPhi = angle(SignalFrame(:,1,canal));
                SigOut(1) = 0;
                Phi = (unwrap(angle(SignalFrame(:,:,canal))));
                DevPhi = [zeros(TailleFenetrage,2) (Phi(:,3:end) - 2*Phi(:,2:end-1) +...
                        Phi(:,1:end-2))];
                    for n = 2:Nbre
                            SigOutInst = sqrt(abs(SignalFrame(:,n-1)).^2 + abs(SignalFrame(:,n)).^2 -2*abs(SignalFrame(:,n)).*abs(SignalFrame(:,n-1)).*cos(DevPhi(:, n)));
                            SigOut(n,canal) = sum(SigOutInst);
                    end
                SigOut(:,canal) = 1/max(abs(SigOut(:,canal))).*SigOut(:,canal);
            end
 end
        
 
 
 
