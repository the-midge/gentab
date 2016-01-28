FID = fopen(out, 'w');
mesures=mesures';
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
key=0;
octave=0;
tripletFeel=0;
nMeasures=size(mesures,2);
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
len=fwrite(FID, writer.stream);
if len~=length(writer.stream)
    error('Erreur à l''écriture');
end

fclose(FID);