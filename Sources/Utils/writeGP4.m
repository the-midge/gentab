close all 
FID = fopen('D:\GenTab\Sources\DATA\testGP4.gp4', 'w');
% lenVersion=fwrite(FID, 1);
% version=fwrite(FID, lenVersion, 'uint8=>char')'
% [title, subTitle, interpret, copyright, authorTab, instructions, notice, lyricks]=writeInfo(FID)
% fwrite(FID,15);
% tempo=fwrite(FID,1)
% fwrite(FID,3);
% key=fwrite(FID,1, 'int8')
% fwrite(FID,32);
% nbTrack=fwrite(FID,1)
% nbMeasures=fwrite(FID,1)
% stream = fwrite(FID);
writer = GTP4writer();
writer.writeVersion();
title='Title';
subtitle='';
interpret='interpret';
album='album';
copyright='copyright';
authorTab='tabAuthor';
instructions='';
notice='comments or notice';
Lyricks='Lyricks';
tempo=120;
key=0;
octave=0;
tripletFeel=0;
nMeasures=4;
nTracks=1;
measureHeaders=[4 4];
trackHeaders=[];
writer.writeInfo(title, subtitle, interpret, album, copyright, authorTab, instructions, notice);
writer.writeBoolean(tripletFeel);
writer.writeLyricks(Lyricks);
writer.writeInt(tempo);
writer.writeByte(key);
writer.writeByte(octave);
load channels
writer.writeByte(channels);
writer.writeInt(nMeasures);
writer.writeInt(nTracks);
writer.writeMeasureHeaders(nMeasures);
writer.writeTrackHeaders(nTracks);
idxNote=1;
for k=1:nMeasures
    [idxNote]=writer.writeMeasure(mesures(k,:), notesDet, idxNote);
end
fclose(FID);