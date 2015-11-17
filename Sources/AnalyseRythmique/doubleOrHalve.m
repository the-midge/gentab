energy_total=sum(C);

features = [sumInRange(C,tempo+4,length(C))/energy_total; 
            sumInRange(C,1,tempo-4)/energy_total];
features=[features;1-sum(features)];
features=[features;sumInRange(C,tempo/2-10,tempo/2+10)/energy_total];
features=[features;sumInRange(C, 1*tempo-10, 1*tempo+10)/energy_total;sumInRange(C,2*tempo-10,2*tempo+10)/energy_total]; %Pb: on srt de C
features=[features;1-sum(features(4:6))];
if(length(temposCandidats)>1)
	features=[features;temposCandidats(2)/tempo];
else
    features=[features;0];
end
if(length(temposCandidats)>2)
	features=[features;temposCandidats(3)/tempo];
else
    features=[features;0];
end
features=[features;
            length(find(C>0));
            tempo];

%%   4.2) Prise de décision
mult=1;
% Valeurs déterminés par apprentissage (Cf Percival...pdf)
mins = [ 0.0, 0.0, 0.0507398, 0.0, 0.0670043, 0.0, -4.44089e-16, 0.0, 0.0, min_lag-1, 41.0, 0];
maxs = [ 0.875346, 0.932996, 1.0, 0.535128, 1.0, 0.738602, 0.919375, 3.93182, 4.02439, 93.0, 178.0, 0];
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