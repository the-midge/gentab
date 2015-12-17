close all 
FID = fopen('D:\GenTab\Sources\DATA\template.gp4');
stream = fread(FID);
reader = GTP4reader(stream);
[version, ~]=reader.readVersion();
[title, subtitle, interpret, album, copyright, authorTab, instructions, notice, newIndex]=reader.readInfo();
[tripletFeel, ~]=reader.readBoolean();
[Lyricks, ~]=reader.readLyricks();
[tempo,~]=reader.readInt();
[key,~]=reader.readByte();
[octave,~]=reader.readByte();
[channels, newIndex]=reader.readChannels();
[nMeasures,newIndex]=reader.readInt(newIndex);
[nTracks,newIndex]=reader.readInt(newIndex);
[measureHeaders, ~]=reader.readMeasureHeaders(newIndex, nMeasures);
[trackHeaders, ~]=reader.readTrackHeaders(nTracks);
notes=[];
for k=1:nMeasures
    temp=reader.readMeasure();
    for l=1:length(temp)
        notes=[notes temp(l)];
    end
end
fclose(FID);