%loadTrainingData.m

addpath('..\..\Onset_Detection');
addpath('..\..\Segmentation');
addpath('..\..\Utils');
addpath('..');
% La base Ismir-2006 contient 20 morceaux;
for ech = [1:20]
    [tempoExp(ech), x, Fs]=loadTrain2006data(ech);
    OnsetDetection;
    close all;
    [segments, bornes]=segmentation(x, length(sf), sampleIndexOnsets, Fs);
    [tempoDet(ech), features(:, ech)] = AnalyseRythmiquePourApprentissage(sf, bornes, FsSF, Fs, 0);
end