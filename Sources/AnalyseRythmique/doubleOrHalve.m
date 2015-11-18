ecartAutoriseBPM = 4;
features = [sumInRange(C,1,tempo-ecartAutoriseBPM-1);
            sumInRange(C,tempo+ecartAutoriseBPM+1,length(C))];
features=[features;sumInRange(C,tempo/2-ecartAutoriseBPM,tempo/2+ecartAutoriseBPM)];
features=[features;sumInRange(C, tempo-ecartAutoriseBPM, tempo+ecartAutoriseBPM);
    sumInRange(C,2*tempo-ecartAutoriseBPM,2*tempo+ecartAutoriseBPM)]; %Pb: on srt de C
% features=[features;1-sum(features(3:5))];
% if(length(temposCandidats)>1)
% 	features=[features;temposCandidats(2)/tempo];
% else
%     features=[features;0];
% end
% if(length(temposCandidats)>2)
% 	features=[features;temposCandidats(3)/tempo];
% else
%     features=[features;0];
% end
features=[features;
            length(find(C>0));
            tempo];

%%   4.2) Prise de décision
mult=1;
% Valeurs déterminés par apprentissage (Cf Percival...pdf)
mins = [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,      minBPM];
maxs = [ 1.0, 1.0, 1.0, 1.0, 1.0, maxBPM,   maxBPM];
svm_weights = [ 1.1071, -0.8404, -0.1949, -0.2892, -0.2094, 2.1781, -1.369, -0.4589, -0.8486, -0.3786, 0, 0 ];
svm_sum = 2.1748+1.95;

features_normalized = zeros(size(features));
for i = 1:length(features)
    if mins(i) ~= maxs(i)
        features_normalized(i) = ((features(i) - mins(i)) / (maxs(i) - mins(i)));
    end
end

for i = 1:length(features_normalized)
    svm_sum = svm_sum + (features_normalized(i) * svm_weights(i));
end

if svm_sum > 1.6
    if svm_sum > 1.73
        mult = 0.5;
        disp('Tempo doit être divisé par 2');
    else
        mult = 2;
        disp('Tempo doit être multiplié par 2');
    end
end
if svm_sum <0.8
    mult = 2;
    disp('Tempo doit être multiplié par 2');
end

clear ecartAutoriseBPM;