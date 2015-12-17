classdef GTP4writer < handle
    
    properties
        stream;
        index;
    end
    
    methods
                 % Constructeurs
        function writer = GTP4writer()
           writer.stream= [];
           index=1;
        end
        
        % Reading blocks
        function [newIndex]=writeVersion(Writer)
            csteVersion=[int8('FICHIER GUITAR PRO v4.00') zeros(1,6)];
            Writer.writeByte(1, 24)';
            Writer.writeByte(int8(csteVersion));
        end
        
        function []=writeInfo(Writer, title, subtitle, interpret, album, copyright, authorTab, instructions, notice, newIndex)
            index = Writer.index;
            
            Writer.writeStringByteSizeOfInteger(title);
            Writer.writeStringByteSizeOfInteger(subtitle);
            Writer.writeStringByteSizeOfInteger(interpret);
            Writer.writeStringByteSizeOfInteger(album);
            Writer.writeStringByteSizeOfInteger('author');
            Writer.writeStringByteSizeOfInteger(copyright);
            Writer.writeStringByteSizeOfInteger(authorTab);
            Writer.writeStringByteSizeOfInteger(instructions);
            Writer.writeInt(1);
            Writer.writeStringByteSizeOfInteger(notice);
        end
        
        function []=writeLyricks(Writer, Lyricks)
            Writer.writeInt(1);            
            Writer.writeInt(1);
            Writer.writeInt(length(Lyricks));
            Writer.writeByte(int8(Lyricks));
            for k=1:4
                Writer.writeInt(1);
                Writer.writeInt(0);
            end
        end
        
        function []=writeChannels(Writer)
            if nargin <2
                index = Writer.index;
            end
            for k=1:64
                Writer.writeInt(1);
                Writer.writeByte(1);
                Writer.writeByte(0);
                Writer.writeByte(0);
                Writer.writeByte(0);
                Writer.writeByte(0);
                Writer.writeByte(0);
                Writer.writeByte(0);
                Writer.writeByte(0);
            end
            channels=[];
            newIndex=index;
            Writer.index=index;
        end
        
        function [mesureHeader, newIndex]=writeMeasureHeaders(Writer, nMeasure)
            for k=1:nMeasure
                numerator=4;
                denominator=4; % Acquittement
                flags=zeros(1,8);
                if k==1
                    flags(8)=1;
                end
                if k==1
                    flags(7) = 1;
                end                  
                index=Writer.index;
                Writer.writeByte(bin2dec(char(flags+48)));
                if k==1
                    Writer.writeByte(numerator);
                    Writer.writeByte(denominator);
                end
            end
        end
        
        function [trackHeader, newIndex]=writeTrackHeaders(Writer, nTrack)
            nStrings=6;
            tuning=[64;59;55;50;45;40;0];
            port=1; channel=1; channelE=2;nFrets=24;capoHeight=0;
            color=[0 0 0 0];
            for k=1:nTrack
                flags=zeros(1,8);
                Writer.writeByte(bin2dec(char(flags+48)))  ;            
                %write name of the track
                trackName=strcat({'Track '},{ num2str(k)});
                Writer.writeByte(length(trackName{1}));          
                Writer.writeByte(int8(trackName{1}));
                Writer.writeByte(zeros(1, 40-length(trackName{1})));

                Writer.writeInt(nStrings);
                Writer.writeInt(tuning);
                Writer.writeInt(port);
                Writer.writeInt(channel);
                Writer.writeInt(channelE);
                Writer.writeInt(nFrets);
                Writer.writeInt(capoHeight);
                Writer.writeByte(uint8(color));
            end
        end
        
        function [idxNote]=writeMeasure(Writer, mesure, notes, idxNote)
            nBeats=find(mesure~=0, 1, 'last'); % nombre de note dans la mesure (en tenant compte que mesure peut terminer par une suite de 0 qu'il faut enlever)
            if sum(mesure(1:nBeats))<16
                nBeats=nBeats+1; % On a besoin du 0 final pour faire un silence
            end
            Writer.writeInt(nBeats);
            for k=1:nBeats                
                if k==nBeats && sum(mesure(1:nBeats))<16
                    noteTampon=Note(0, 16-sum(mesure(1:nBeats)), 0, 0);
                    Writer.writeBeat(noteTampon); 
                else
                    Writer.writeBeat(notes(idxNote));
                    idxNote=idxNote+1;
                end
            end
        end
        
        function []=writeBeat(Writer, note) 
%             flags = dec2bin(Writer.writeByte(index),8);
            isRest=(note.ton == 0);
            isNuplet=0;
            hasMixTableChange=0;
            hasEffects=0;
            hasText=0;
            hasChord=0;
            hasDot=(note.duree == 3 || note.duree == 6);
            Writer.writeByte(bin2dec(num2str([0 isRest isNuplet hasMixTableChange hasEffects hasText hasChord hasDot])));
            if sum(note.duree == [5;7;9;11;10;12;13;14;15])
                warning('Cannot yet write strange duration');
            end
            if isRest
                Writer.writeByte(2);
            end
            duration= ceil(2-log2(note.duree)); 
            Writer.writeByte(duration);  %GP4 style: -2=ronde, 0=noire, 1=croche, ...

            Writer.writeNote(note);
        end
        
        function [string, fret]=getFingerPlace(writer,note)
            midiNote=note.convertMIDI();
            for k=1:size(note.ton, 2)
                if midiNote(k)==0
                    string=-1; fret=-1;
                    break;
                end
                if midiNote(k)<33   % Si < A 2
                   string(k)=1;
                elseif midiNote(k) < 38 % Si < D 3
                  string(k)=2;
                elseif midiNote(k) < 43 % Si < g 3
                  string(k)=3;
                elseif midiNote(k) < 47 % Si < b3
                  string(k)=4;
                elseif midiNote(k) < 52 % Si < e4
                  string(k)=5;
                else
                   string(k)=6;
                end

                if midiNote(k)<47
                    fret(k)=mod(midiNote(k)-28,5);
                elseif midiNote(k) < 52
                    fret(k)=midiNote(k)-47;
                else
                    fret(k)=midiNote(k)-52;
                end
            end
        end
        
        function []=writeNote(Writer, note)
            [strings, fret]=Writer.getFingerPlace(note);
%             strings=find(tempStringFlags==1);
%             isRest=1;
            if strings == -1
                Writer.writeByte(0);
                stringFlags=zeros(1,8);
                stringFlags=bin2dec(num2str(stringFlags));
                Writer.writeByte(stringFlags);
            else
                tempStringFlags=double(dec2bin(strings,8))-48;
                stringFlags=zeros(1,8);
                stringFlags(find(sum(tempStringFlags,1)>0))=1;
                stringFlags=bin2dec(num2str(stringFlags));
                Writer.writeByte(stringFlags);
                for k=1:length(strings)% If it is not a rest we do not enter this
                    Writer.writeByte(bin2dec(num2str([0 0 1 0 0 0 0 0])));
    %                 flags = dec2bin(Writer.writeByte(),8);
                    Writer.writeByte(1);
                    Writer.writeByte(0);  % Normal

    %                 if flags(8)=='1'
    %                    duration=Writer.writeByte();
    %                    nUplet=Writer.writeByte();
    %                 end
        %             if flags(4)=='1'
        %                dynamic=Writer.writeByte();
        %             else
        %                 dynamic = 6;
        %             end
                    fretNumber=Writer.writeByte(fret(k)); 
    %                 end
    %                 if flags(1)=='1'
    %                    fingerRight=Writer.writeByte(); 
    %                    fingerLeft=Writer.writeByte(); 
    %                 end
    %                 if flags(5)=='1'
    %                     warning('Unable to write effect');
    %                 end                
                end
            end
%             if 
%             names = {'R ', 'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};
%             if exist('duration', 'var')
%                 if isRest
%                     note=Note(0, duration, [names{0} num2str(0)]);
%                 else
%                     [ton(k), octave(k)]=Writer.getTonOctave(strings(k), fretNumber);
%                     note=Note(0, duration, [names{ton+1} num2str(octave)]);
%                 end
%             else
%                 if isRest
%                     note=Note(0, 1, [names{1} num2str(0)]);
%                 else
%                     [ton(k), octave(k)]=Writer.getTonOctave(strings(k), fretNumber);
%                     note=Note(0, 1, [names{ton+1} num2str(octave)]);
%                 end
%             end
%             newIndex=Writer.index;
        end
        
        function [ton, octave]=getTonOctave(Writer, string, fret)
            switch string
                case 7  %String E2
                    if fret>=20
                        octave=4;
                    elseif fret>=8
                        octave=3;
                    else
                        octave=2;
                    end
                    ton=mod(fret+7,12)+1;
                case 6  %String A2
                    if fret>=15
                        octave=4;
                    elseif fret>=3
                        octave=3;
                    else
                        octave=2;
                    end
                    ton=mod(fret,12)+1;
                case 5  %String D3
                    if fret>=22
                        octave=5;
                    elseif fret>=10
                        octave=4;
                    else
                        octave=3;
                    end
                    ton=mod(fret+5,12)+1;
                case 4  %String G3
                    if fret>=17
                        octave=5;
                    elseif fret>=5
                        octave=4;
                    else
                        octave=3;
                    end
                    ton=mod(fret-2,12)+1;            
                case 3  %String B3
                    if fret>=13
                        octave=5;
                    elseif fret>=1
                        octave=4;
                    else
                        octave=3;
                    end
                    ton=mod(fret+9,12)+1;           
                case 2  %String E4
                    if fret>=20
                        octave=6;
                    elseif fret>=8
                        octave=5;
                    else
                        octave=4;
                    end
                    ton=mod(fret+7,12)+1; 
            end
        end
        
        % writing methods
%         function [index]=write(Writer, index, integer)
%             if nargin <2
%                 index = Writer.index;
%             end
%             integer = int8(Writer.stream(index));
%             index=index(end)+1;
%             Writer.index=index;
%         end
        
       function [integer, index]=writeIntLen(Writer, index, len)
            if nargin <3
                len=index;
                index = Writer.index;                
            end
            integer = int8(Writer.stream(index:4:index+4*len-1));
            index=index+4*len;
            Writer.index=index;
        end     
        function [integer, index]=writeInt(Writer, index, integer)
            if nargin <3
                integer=index;
                index = Writer.index;
            end
            for k=1:length(integer)
                Writer.stream(index) = int8(integer(k));
                index=index+4;
            end
            Writer.index=index;
        end
%        function [integer, index]=writeByteLen(Writer, index, len)
%             if nargin <3
%                 len=index;
%                 index = Writer.index;                
%             end
%             integer = int8(Writer.stream(index:index+len-1));
%             index=index+len;
%             Writer.index=index;
%        end     
        
        function [integer, index]=writeByte(Writer, index, integer)
            if nargin <3
                integer=index;
                index = Writer.index;
            end
            for k=1:length(integer)
                Writer.stream(index) = int8(integer(k));
                index=index+1;                
            end
            Writer.index=index;
        end
        
        function [index]=writeBoolean(Writer, index, boolen)
            if nargin <3
                boolen=index;
                index = Writer.index;
            end
            Writer.stream(index) = int8(boolen);
            index=index+1;
            Writer.index=index;
        end
        
        function []=writeString(Writer, index, string)
            if nargin <3
                string=index;
                index = Writer.index;                
            end
            len = length(string);
            if len <= 0
                Writer.writeByte(0);
            else
                Writer.writeByte(int8(length(string)));
                Writer.writeByte(int8(string));
%                 [data, newIndex]=Writer.write(index:(index+double(len)));
%                 [string]=char(data');
%                 newIndex=newIndex(end);
%                 Writer.index=newIndex;
            end
        end
        
        function []=writeStringByteSizeOfInteger(Writer, index, string)
            if nargin <3
                string = index;
                index = Writer.index;
            end
           Writer.writeInt(index, length(string)+1);
           Writer.writeString(string);
%            Writer.write(); 
%            [string, newIndex]=Writer.writeString(newIndex, len-1);
%            newIndex=newIndex(end);
%            Writer.index=newIndex;
        end
    end
end