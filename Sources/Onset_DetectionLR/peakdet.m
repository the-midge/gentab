function maxtab=peakdet(v, delta, FsSF, x)
%PEAKDET Detect peaks in a vector
%        [MAXTAB, MINTAB] = PEAKDET(V, DELTA) finds the local
%        maxima and minima ("peaks") in the vector V.
%        MAXTAB and MINTAB consists of two columns. Column 1
%        contains indices in V, and column 2 the found values.
%      
%        With [MAXTAB, MINTAB] = PEAKDET(V, DELTA, X) the indices
%        in MAXTAB and MINTAB are replaced with the corresponding
%        X-values.
%
%        A point is considered a maximum peak if it has the maximal
%        value, and was preceded (to the left) by a value lower by
%        DELTA.

% Eli Billauer, 3.4.05 (Explicitly not copyrighted).
% This function is released to the public domain; Any use is allowed.
seuil=delta;  %à mettre en argument
Fs=44100;
ecartmin=0.0625*FsSF; %Cette valeur par défaut correspond au temps d'une double-croche à 240 bps à mettre en argument

maxtab = [];
ecart = [];
v = v(:); % Just in case this wasn't a proper vector

if nargin < 4
  x = (1:length(v))';
else 
  x = x(:);
  if length(v)~= length(x)
    error('Input vectors v and x must have same length');
  end
end
  
if (length(delta(:)))>1
  error('Input argument DELTA must be a scalar');
end



mn = Inf; mx = -Inf;
mnpos = NaN; mxpos = NaN;
mxi=0;
lastmxpos=-Inf;
lookformax = 1;

for i=1:length(v)
  this = v(i);
  if this > mx, mx = this; mxpos= x(i); mxi=i; end
  if this < mn, mn = this; mnpos = x(i); end
  
  if lookformax
    if this < mx-delta
        %Avant de l'ajouter au vérifie qu'on respecte un certain seuil
        if(mx>seuil)
          %Avant de l'ajouter on vérifie qu'on respecte un certain écart avec le précédent pic
            if(mxpos-lastmxpos>ecartmin)
            ecart=[ecart; mxpos-lastmxpos];
            maxtab = [maxtab ; mxpos mx];
            mn = this; mnpos = x(i);
            lookformax = 0;
            lastmxpos=mxpos; 
           end
      end
    end  
  else
    if this > mn+delta
      mx = this; mxpos = x(i);
      lookformax = 1;
    end
  end
end