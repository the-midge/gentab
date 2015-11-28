function harmonicTemplates = KLGLOTTModel(pitchs,Fs)
            nPitchs = length(pitchs);
            P=2^11;
            harmonicTemplates = zeros(P,nPitchs);
            AV = 1;
            Oq = 0.05;
            for index = 1:nPitchs
                %build glottal pulse pattern
                T = round(Fs/pitchs(index));
                HH = zeros(T,1);
                t = 1:round(T*Oq);
                HH(t) = ((27*AV)/(4*T*Oq^2)*(t-1).^2-(27*AV)/(4*T^2*Oq^3)*(t-1).^3);
                nRepeat = ceil(P/T);
                H = repmat(HH, nRepeat,1);
                H = H(1:P);
                H = H - mean(H);
                F = abs(fft(hann(P).*H,P));
                harmonicTemplates(:,index) = F(:)/sum(abs(F));
            end      
