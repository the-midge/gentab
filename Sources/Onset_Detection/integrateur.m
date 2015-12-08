function [ y ] = integrateur( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
y(1)=0;
idxCgt=1;
for k=2:length(x)
    if x(k)+y(k-1)<=0
        y(k)=0;
    else
        y(k)=x(k)+y(k-1);
    end
    if x(k)-x(k-1) ==2  % Changement dans la fonction à intégrer (passe positif)
        y(idxCgt:k)=y(idxCgt:k)./max(y(idxCgt:k));
        idxCgt=k;
    end
end
y(idxCgt:k)=y(idxCgt:k)./max(y(idxCgt:k));
end

