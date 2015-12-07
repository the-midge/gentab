function [ s ] = salience(p, deltaP, BetaP, B, kpo, Z )
%salience.m
%   

kph = @(p, h, beta) kpo(p)+B*log2(h)+B/2*log2(1+(h.^2-1)*beta);
J= @(k, mh, beta, h) sqrt(Z(ceil(k + B*mh + (B/2*log2(1+(h.^2-1)*beta))),:));  % Une colonne par instant
H=13;

s=zeros(H, size(Z, 2));
for h=1:H
%     switch h
%         case 1
%             M=2;
%         case 2
%             M=1;
%         otherwise
%             M=0;
%     end
M=2;
    container=zeros(2*M+1, size(Z, 2));
    for Mh=-M:M
        if(kph(p, h, BetaP)+deltaP + B*Mh + (B/2*log2(1+(h.^2-1)*BetaP)))>0 &&  (kph(p, h, BetaP)+deltaP + B*Mh + (B/2*log2(1+(h.^2-1)*BetaP)))<size(Z,1) 
            container(Mh+M+1,:)=J(kph(p, h, BetaP)+deltaP, Mh, BetaP, h);
        end
    end
    s(h, :)=max(container);
end

s=sum(sum(s));
end

