classdef GTP4reader < handle
    
    properties
        stream;
        index;
    end
    
    methods
                 % Constructeurs
        function reader = GTP4reader(stream)
           reader.stream= stream;
        end
        
        % Reading blocks
        function [version, newIndex]=readVersion(Reader)
            [version, newIndex]=Reader.readByteLen(2, 30);
            version=deblank(char(version'));
%             newIndex=newIndex+10;
%             [~, newIndex]=Reader.readIntLen(newIndex,8);
            Reader.index=newIndex;
        end
        
        function [title, subtitle, interpret, album, copyright, authorTab, instructions, notice, newIndex]=readInfo(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            [title, idx]=Reader.readStringByteSizeOfInteger(index);
            [subtitle, idx]=Reader.readStringByteSizeOfInteger(idx);
            [interpret, idx]=Reader.readStringByteSizeOfInteger(idx);
            [album, idx]=Reader.readStringByteSizeOfInteger(idx);
            [authorTab, idx]=Reader.readStringByteSizeOfInteger(idx);
            [copyright, idx]=Reader.readStringByteSizeOfInteger(idx);
            [authorTab, idx]=Reader.readStringByteSizeOfInteger(idx);
            [instructions, idx]=Reader.readStringByteSizeOfInteger(idx);
            [~, idx]=Reader.readInt(idx);
            [notice, idx]=Reader.readStringByteSizeOfInteger(idx);
            instructions='';
            subtitle='';
            newIndex=idx;
            Reader.index=idx;
        end
        
        function [Lyricks, newIndex]=readLyricks(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            [~, index]=Reader.readInt();            
            [~, index]=Reader.readInt();
            [len, index]=Reader.readInt();
            [Lyricks, index]=Reader.readString(index, len-1);
            index=index+32;
%             [~, index]=Reader.readStringByteSizeOfInteger(index);
%             [~, index]=Reader.readStringByteSizeOfInteger(index);

            newIndex=index;
            Reader.index=index;
        end
        
        function [channels, newIndex]=readChannels(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            for k=1:64
                [~, index]=Reader.readByteLen(index, 12);
            end
            index=index+3;
            channels=[];
            newIndex=index;
            Reader.index=index;
        end
        
        function [mesureHeader, newIndex]=readMeasureHeaders(Reader, index, nMeasure)
            if nargin <3
                nMeasure=index;
                index = Reader.index;
            end
            for k=1:nMeasure
                numerator=0;
                denominator=0; % Acquittement
                flags = dec2bin(Reader.readByte(index),8);
                if flags(8) == '1'
                    numerator = Reader.readByte();
                end
                if flags(7) == '1'
                    denominator = Reader.readByte();
                end
                if flags(5) == '1'
                    repeatClose = Reader.readByte();
                end
                if flags(4) == '1'
                    repeatAlternative = Reader.readByte();
                end
                if flags(3) == '1'
%                     marker = Reader.readMarker();
                end
                if flags(2) == '1'
%                     Reader.readByte();
%                     Reader.readByte();
                end                    
                index=Reader.index;
                mesureHeader(k,:) = [numerator, denominator];
            end
            newIndex=Reader.index;
        end
        
        function [trackHeader, newIndex]=readTrackHeaders(Reader, index, nTrack)
            if nargin <3
                nTrack=index;
                index = Reader.index;
            end
            Reader.readByte(index);
            for k=1:nTrack
                flags = dec2bin(Reader.readByte(),8);
                isBanjo=(flags(6) == '0');
                is12strings=(flags(7) == '0');
                isdrums=(flags(8) == '0');
                isspecial= isBanjo || is12strings || isdrums;
                if isspecial
                    error('cannot read banjo tracks, 12 strings tracks or drums tracks');
                end               
                %read name of the track
                trackName=Reader.readByteLen(40);
                trackName   = deblank(char(trackName'));
                nStrings    =Reader.readInt();
                tuning      =Reader.readIntLen(7);
                port        =Reader.readInt();
                channel     =Reader.readInt();
                channelE    =Reader.readInt();
                nFrets      =Reader.readInt();
                capoHeight  =Reader.readInt();
                color       =Reader.readByteLen(4);
                trackHeader(k,:) = {{trackName};...
                                    tuning    ;...
                                    color     ;...
                                    [nStrings  ;...
                                    port      ;...
                                    channel   ;...
                                    channelE  ;...
                                    nFrets    ;...
                                    capoHeight]};
            end
            newIndex=Reader.index;
        end
        
        function [measure, newIndex]=readMeasure(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            nBeats = Reader.readInt(index);
            for k=1:nBeats
                if Reader.index>length(Reader.stream)
                    break;
                end
                beat(k)=Reader.readBeat(); 
            end
            measure=beat;
        end
        
        function [beat, newIndex]=readBeat(Reader, index)
            if nargin <2
                index = Reader.index;
            end
 
            flags = dec2bin(Reader.readByte(index),8);
            isRest=(flags(2) == '1');
            isNuplet=(flags(3) == '1');
            hasMixTableChange=(flags(4) == '1');
            hasEffects=(flags(5) == '1');
            hasText=(flags(6) == '1');
            hasChord=(flags(7) == '1');
            hasDot=(flags(8) == '1');
            if isRest
                rest=Reader.readByte();
                if rest~=2
                    warning('Value of beat at Reader.index is not a rest as it should be');
                end
            end
            duration=Reader.readByte();  %GP4 style: -2=ronde, 0=noire, 1=croche, ...
            if isNuplet
                nUplet=Reader.readInt();
            end
            if hasChord
                % TODO read a chord diagram
                error('A chord diagram has been detected, but current version cannot read it');
            end
            if hasText
                text=Reader.readStringByteSizeOfInteger();
            end
            if hasEffects
                % TODO read an effect
                error('An effect has been detected, but current version cannot read it');
            end
            if hasMixTableChange
                % TODO read a MixTableChange
                error('A MixTableChange has been detected, but current version cannot read it');
            end
            
            note=Reader.readNote();
            note.duree=2^(-(duration)+2);
            if hasDot
                note.duree=note.duree*1.5;
            end
            note.conversionDuree(note.duree);
            beat=note; % for now
            newIndex=Reader.index;
        end
        
        function [note, newIndex]=readNote(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            stringFlags=str2num(dec2bin(Reader.readByte(index),8)')';
            strings=find(stringFlags==1);
            isRest=1;
            for k=1:sum(stringFlags)
                flags = dec2bin(Reader.readByte(),8);
                if flags(3)=='1'
                    type = Reader.readByte();
%                     Reader.readByte();  % Normal
                    isRest=0;
                end
                if flags(8)=='1'
                   duration=Reader.readByte();
                   nUplet=Reader.readByte();
                end
                if flags(4)=='1'
                   dynamic=Reader.readByte();
                else
                    dynamic = 6;
                end
                if flags(3)=='1'
                   fretNumber=Reader.readByte(); 
                end
                if flags(1)=='1'
                   fingerRight=Reader.readByte(); 
                   fingerLeft=Reader.readByte(); 
                end
                if flags(5)=='1'
                    warning('Unable to read effect');
                end                
            end
            names = {'R ', 'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};
            if exist('duration', 'var')
                if isRest
                    note=Note(0, duration, [names{0} num2str(0)]);
                else
                    [ton(k), octave(k)]=Reader.getTonOctave(strings(k), fretNumber);
                    note=Note(0, duration, [names{ton+1} num2str(octave)]);
                end
            else
                if isRest
                    note=Note(0, 1, [names{1} num2str(0)]);
                else
                    [ton(k), octave(k)]=Reader.getTonOctave(strings(k), fretNumber);
                    note=Note(0, 1, [names{ton+1} num2str(octave)]);
                end
            end
            newIndex=Reader.index;
        end
        
        function [ton, octave]=getTonOctave(Reader, string, fret)
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
        
        % Reading methods
        function [integer, index]=read(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            integer = int8(Reader.stream(index));
            index=index(end)+1;
            Reader.index=index;
        end
        
       function [integer, index]=readIntLen(Reader, index, len)
            if nargin <3
                len=index;
                index = Reader.index;                
            end
            integer = int8(Reader.stream(index:4:index+4*len-1));
            index=index+4*len;
            Reader.index=index;
        end     
        function [integer, index]=readInt(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            integer = int8(Reader.stream(index));
            index=index+4;
            Reader.index=index;
        end
       function [integer, index]=readByteLen(Reader, index, len)
            if nargin <3
                len=index;
                index = Reader.index;                
            end
            integer = int8(Reader.stream(index:index+len-1));
            index=index+len;
            Reader.index=index;
       end     
        
        function [integer, index]=readByte(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            integer = int8(Reader.stream(index));
            index=index+1;
            Reader.index=index;
        end
        
        function [boolen, index]=readBoolean(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            boolen=(Reader.stream(index) == 1);
            index=index+1;
            Reader.index=index;
        end
        
        function [string, newIndex]=readString(Reader, index, len)
            if nargin <3
                len=index;
                index = Reader.index;                
            end
            if len <= 0
                newIndex=index;
                Reader.index=index;
                string='';
            else
                [data, newIndex]=Reader.read(index:(index+double(len)));
                [string]=char(data');
                newIndex=newIndex(end);
                Reader.index=newIndex;
            end
        end
        
        function [string, newIndex]=readStringByteSizeOfInteger(Reader, index)
            if nargin <2
                index = Reader.index;
            end
            Reader.readInt(index);
           [len, newIndex] = Reader.read(); 
           [string, newIndex]=Reader.readString(newIndex, len-1);
           newIndex=newIndex(end);
           Reader.index=newIndex;
        end
    end
end