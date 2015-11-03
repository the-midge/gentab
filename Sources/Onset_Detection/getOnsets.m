 function SigOut = getOnsets(STFT,fMin, fMax, Fs, NFFT)
            %This function returns a vector of length nFrames, containing
            % an onset detection in the signal between frequencies fMin and
            % fMax. It uses the complex spectral difference method.
           
            IFmin = max(1,round(fMin/Fs*NFFT)); % fs*nfft
            IFmax = round(min(fMax/2,fMax/Fs*NFFT));
            
            SignalFrame = STFT(IFmin:IFmax,:);
            
            TailleFenetrage = size(SignalFrame,1);
            NbreSamble = size(SignalFrame,2);

            SigOut(1) = 0;
            Phi = (unwrap(angle(SignalFrame(:,:))));
            DevPhi = [zeros(TailleFenetrage,2) (Phi(:,3:end) - 2*Phi(:,2:end-1) + Phi(:,1:end-2))];
            for n = 2:NbreSamble
                    SigOutInst = sqrt(abs(SignalFrame(:,n-1)).^2 + abs(SignalFrame(:,n)).^2 -2*abs(SignalFrame(:,n)).*abs(SignalFrame(:,n-1)).*cos(DevPhi(:, n)));
                    SigOut(n) = sum(SigOutInst);
            end
            SigOut = 1/max(abs(SigOut(:)))*SigOut';            
 end
        
 
 
 
