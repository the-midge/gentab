classdef Note < handle
    % la classe Note stocke les différentes informations suivantes :
    %
    % - l'indice de l'onset qui correspond au debut de l'attaque
    %
    % - la duree correspondante de la note jouee (double croche = plus
    %   courte unité de temps)
    %   * 1  <=> double croche
    %   * 2  <=> croche
    %   * 3  <=> croche pointee
    %   * 4  <=> noire
    %   * 6  <=> noire pointee
    %   * 8  <=> blanche
    %   * 12 <=> blanche pointee
    %   * 16 <=> ronde
    %
    % - le ton de la note jouee
    %   * 0  <=>  Silence (R)
    %   * 1  <=>  La      (A)
    %   * 3  <=>  Si      (B)
    %   * 4  <=>  Do      (C)
    %   * 6  <=>  Re      (D)
    %   * 8  <=>  Mi      (E)
    %   * 9  <=>  Fa      (F)
    %   * 11 <=>  Sol     (G)
    %
    % - l'octave correpondantes de la note jouee
    
    properties
        indice;
        duree;
        ton;
        octave;
        dureestr;
        tonstr;
    end
    
    methods
        % Constructeurs
        function note = Note(ind, dur, ton, oct)
            if nargin == 4
            	note.indice = ind;
                note.duree = dur;
                conversionDuree(note, note.duree);
                note.ton = ton;
                note.tonstr='';
                conversionTon(note, note.ton);
                if(ton == 0)
                    note.octave = 0;
                else
                    note.octave = oct;
                end
            elseif nargin == 3
                % prototype devient Note(ind, dur, {tonstr octave})
            	note.indice = ind;
                note.duree = dur;
                conversionDuree(note, note.duree);
                note.tonstr = ton(1:2);
                note.octave = str2num(ton(3));
                if length(ton)>3
                    for i=2:length(ton)/3 %La chaine à une longueur d'un multiple de 3 (3 caractères par "note")
                        note.tonstr(i,:) = ton(i*3-3+(1:2));
                        note.octave(i) = str2num(ton(i*3-3+3));
                    end
                end
                conversionTonstr(note, note.tonstr);
            else
                disp('nombre argument pour Note(ind, dur, ton, oct) incorrect')
            end            
        end
        
        function note = conversionDuree(note, dur)
            switch dur
                case 1
                    note.dureestr = 'double croche';
                case 2
                    note.dureestr = 'croche';
                case 3
                    note.dureestr = 'croche pointee';
                case 4
                    note.dureestr = 'noire';
                case 5
                    note.dureestr = 'noire+double croche';
                case 6
                    note.dureestr = 'noire pointee';
                case 7
                    note.dureestr = 'noire double pointee';
                case 8
                    note.dureestr = 'blanche';
                case 9
                    note.dureestr = 'blanche+double croche';
                case 10
                    note.dureestr = 'blanche+croche';
                case 11
                    note.dureestr = 'blanche+croche pointee';
                case 12
                    note.dureestr = 'blanche pointee';
                case 13
                    note.dureestr = 'blanche pointee+double croche';
                case 14
                    note.dureestr = 'blanche pointee+croche';
                case 15
                    note.dureestr = 'blanche pointee+croche pointee';
                case 16
                    note.dureestr = 'ronde';
                otherwise
                    disp('erreur Duree note');  
            end
        end
        
        function note = conversionTonstr(note, tonstr)
            names = {'R ', 'A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#'};
            for i=1:length(tonstr)/2
                for j=1:13
                   if strcmp(names{j}, tonstr(i,:)) ~= 0
                      note.ton(i)=j-1; % note attendue
                   end
                end
            end
        end
        
        function note = conversionTon(note, ton)
        for i=1:length(ton)
            switch ton(i)
                case 0
                    note.tonstr(i,1:2) = 'R '; % rest
                case 1
                    note.tonstr(i,1:2) = 'A ';
                case 2
                    note.tonstr(i,1:2) = 'A#';    
                case 3
                    note.tonstr(i,1:2) = 'B ';
                case 4
                    note.tonstr(i,1:2) = 'C ';
                case 5
                    note.tonstr(i,1:2) = 'C#';
                case 6
                    note.tonstr(i,1:2) = 'D ';
                case 7
                    note.tonstr(i,1:2) = 'D#';
                case 8
                    note.tonstr(i,1:2) = 'E ';
                case 9
                    note.tonstr(i,1:2) = 'F ';    
                case 10
                    note.tonstr(i,1:2) = 'F#';
                case 11
                    note.tonstr(i,1:2) = 'G ';
                case 12
                    note.tonstr(i,1:2) = char('G#');
                otherwise
%                     disp('Erreur Ton note');
            end
        end
        end
        
         function note = infoNoteHuman(note)
             disp([num2str(note.indice), '    ', note.dureestr]);
             for i=1:length(note.octave)
                disp(['    ', note.tonstr(i,:), num2str(note.octave(i))]) ;
             end
         end
         
         function note = infoNote(note)
             disp([num2str(note.indice), '    ', num2str(note.duree)]);
             for i=1:length(note.octave)
                disp(['    ', num2str(note.ton(i)), num2str(note.octave(i))]) ;
             end
         end
         
         function midiNote= convertMIDI(note)
             if note.ton==0
                 midiNote=0;
             else
                 midiNote=mod(-5+note.ton,12)+note.octave*12;
                 midiNote(midiNote<0)=0;
             end
         end
    end       
end

