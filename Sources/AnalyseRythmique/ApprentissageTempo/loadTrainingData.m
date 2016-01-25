%loadTrainingData.m

addpath('..\..\Onset_Detection');
addpath('..\..\Segmentation');
addpath('..\..\Utils');
addpath('..');
%%
tempoExp=zeros(88,1);
tempoDet=zeros(88,1);
features=[]; %zeros(7,88);
C=zeros(180, 88);
%% La base Mirex-2006 contient 17 morceaux;
tic
h1 = waitbar(0,'Calcul...');
for ech = [1:17]
    [tempoExp(ech), x, Fs]=loadTrain2006data(ech);
    OnsetDetection;
    [segments, bornes]=segmentation(x, length(oss), sampleIndexOnsets, Fs, sampleIndexOffsets(length(sampleIndexOffsets)));
    [currFeatures] = AnalyseRythmique(oss, bornes, FsOSS, Fs, sampleIndexOnsets, sampleIndexOffsets, 0);
    features=[features; currFeatures];
    waitbar(ech/88,h1,strcat(num2str(ech/88*100), '%'));
end
%% La base Mirex-2004 contient 71 morceaux
list=dir('D:\mirex-2004');
for k=1:length(list)
    files{k}=list(k).name;
end
audioIdx=regexp(files, '.wav');
audioIdx=~cellfun('isempty', audioIdx);
audioIdx=find(audioIdx==1);

for k=1:length(audioIdx)
audioFilenames{k}=files{audioIdx(k)};
[~, fileNames{k}, ext]=fileparts(audioFilenames{k});
end

for ech= 1:length(fileNames)
    [tempoExp(17+ech), x, Fs]=loadTrain2004data(fileNames{ech});
    OnsetDetection;
    [segments, bornes]=segmentation(x, length(oss), sampleIndexOnsets, Fs, sampleIndexOffsets(length(sampleIndexOffsets)));
    [currFeatures] = AnalyseRythmique(oss, bornes, FsOSS, Fs, sampleIndexOnsets, sampleIndexOffsets, 0);
    features=[features; currFeatures];
    waitbar((ech+17)/88,h1,strcat(num2str((ech+17)/88*100), '%'));
end
toc
%%
break;
features=features';
C=C';

%% Retrait des données en dehors de notre scope.
idx2Rmv = find(tempoExp<55 | tempoExp>180);
tempoExp(idx2Rmv)=[];
tempoDet(idx2Rmv)=[];
features(idx2Rmv,:)=[];
C(idx2Rmv,:)=[];
%% Retrait des données ou le tempos candidats n'est pas en rapport avec le tempo attendu
% rapports=(tempoExp./tempoDet);
% idx2Rmv = find(rapports<0.34 | ...
%                 (rapports>0.37 & rapports<0.45) | ...
%                 (rapports>0.55 & rapports<0.62) | ...
%                 (rapports>0.70 & rapports<0.95) | ...
%                 (rapports>1.06 & rapports<1.29) | ...
%                 (rapports>1.37 & rapports<1.78) | ...
%                 (rapports>2.2 & rapports<2.8) | ...
%                 (rapports>3.1));
% tempoExp(idx2Rmv)=[];
% tempoDet(idx2Rmv)=[];
% features(idx2Rmv,:)=[];
% C(idx2Rmv,:)=[];
% 
% rapportsTarget= [0.33; 0.5; 0.66; 1; 1.33; 2; 3];
% valTarget=round(log2(rapportsTarget)*2);
% targets=valTarget(findClosest(rapportsTarget, rapports));

% rapports=(tempoExp./tempoDet);
% idx2Rmv = find(rapports<0.45 | ...
%                 (rapports>0.55 & rapports<0.95) | ...
%                 (rapports>1.06 & rapports<1.78) | ...
%                 rapports>2.8);
% tempoExp(idx2Rmv)=[];
% tempoDet(idx2Rmv)=[];
% features(idx2Rmv,:)=[];
% C(idx2Rmv,:)=[];
% rapports(idx2Rmv)=[];
% rapportsTarget= [0.5; 1; 2];
% valTarget=round(log2(rapportsTarget)*1);
% targets=valTarget(findClosest(rapportsTarget, rapports));

%%  Mise en forme de targets
k=1;
l=1; % indice dans les tempos attendus
idx2rmv=[];;
targets=zeros(size(features(:,1)));
while k<=size(features, 1)
    nbCandidats=features(k,1);
    currCandidats=features(k:k+nbCandidats-1,2);
    [winner]=findClosest(currCandidats, tempoExp(l));
    if tempoExp(l)<56 || tempoExp(l)>180 || sum(isnan(features(k:k+nbCandidats-1,7)))>0
        idx2rmv=[idx2rmv; (k:k+nbCandidats-1)'];
    end
    targets(k+winner-1)=1;
    l=l+1;
    k=k+nbCandidats;
end

% tempoExp(tempoExp<56 | tempoExp>180)=[];
% tempoExp(idx2rmv)=[];
targets(idx2rmv)=[];
features(idx2rmv,:)=[];
% 
features=features';
% targets=targets+2;
% binTargets = [targets==1 targets==2 targets==3]';
