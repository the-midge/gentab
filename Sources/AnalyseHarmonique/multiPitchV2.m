Fs=48e3;

%% A. Auditory filterbank
C=70; %Nombre de filtre
c=(0:C-1)+5;  % 70 filtre de 65Hz à 5.2Hz
zeta0=2.3;
zeta1=0.39;
fc=229*(10.^((0.39*c+0.39)/21.4)-1)'; % Fréquences centrales

% échec =>
% %Resonator 1
% bc = 0.108*fc+24.7; % Bandes passantes
% bc3db=2*1.019*bc*sqrt(2^(1/4)-1);
% 
% A=exp((-bc3db*pi)/(Fs*sqrt(2.^(1/4)-1)));        %Paramètre de la bande passante
% 
% roh1=0.5*(1-A.^2);
% roh1=ones(C,1);
% costheta1=(1+A.^2)./(2*A).*cos(2*pi*fc/Fs);	%à déterminer
% costheta2=(2*A)./(1+A.^2).*cos(2*pi*fc/Fs);   %à déterminer
% roh2=(1-A.^2).*sqrt(1-costheta2.^2);     %à déterminer
% roh2=ones(C,1);
% B1=[ones(C,1) zeros(C,1) -ones(C,1)];	B1=bsxfun(@times, B1, roh1);
% A1=[ones(C,1) -A.*costheta1 A.^2];      A1=bsxfun(@times, A1, roh1);
% 
% B2=[ones(C,1)]; B2=bsxfun(@times, B2, roh2);
% A2=[ones(C,1) -A.*costheta2 A.^2]; A2=bsxfun(@times, A2, roh2);
% 
% for c=1:C
%     [H(:,c) F]=freqz(B1(c,:), A1(c,:), 2^12, Fs);
% end
% figure(1), plot(F, abs(H));

	fcoefs = MakeERBFilters(Fs,fc);
	xc = ERBFilterBank(sin(2*pi*185*linspace(295,315, Fs/(315-295))), fcoefs); % Utiliser cette ligne pour filtrer un segment
% 	resp = 20*log10(abs(fft(xc')));
% 	freqScale = (0:511)/512*16000;
% 	semilogx(freqScale(1:511),resp(1:511,:));
% % 	axis([100 16000 -60 0])
% 	xlabel('Frequency (Hz)'); ylabel('Filter Response (dB)');
    
    %% B. Neural transduction
    % Compression
    gammaCT = std(xc).^(0.33-1);
%     figure(1), clf, plot([xc(1:5,:)' bsxfun(@rdivide, xc(1:5,:), gammaCT)'])
    xc=bsxfun(@rdivide, xc, gammaCT); 
    % Half wave rectification
    xc=0.5*(xc+abs(xc));
    