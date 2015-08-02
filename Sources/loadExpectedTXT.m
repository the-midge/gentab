function [notesExpected, rythmeExpected]=loadExpectedTXT(filename)
FID=fopen(filename, 'r');
if(FID==-1)
    error('Impossible d''ouvrir le fichier');
end

fileLength=fread(FID, 1, '*double');
notesExpected=fread(FID, fileLength*3, '*char');
notesExpected=reshape(notesExpected, [], 3);

rythmeExp=fread(FID, inf, '*char');

rythmeExpected={};
curChar='';
mot='';
for (i=1:length(rythmeExp))
    curChar=rythmeExp(i);
    if(curChar=='\')
        rythmeExpected={rythmeExpected{:} mot}'; 
        mot='';
    else
        mot=[mot curChar];
    end
end

fclose(FID);
end