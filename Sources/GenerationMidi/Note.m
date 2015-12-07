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
    %   * 2  <=>  Si      (B)
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
                conversionTon(note, note.ton);
                if(ton == -1)
                    note.octave = 0;
                else
                    note.octave = oct;
                end
            elseif nargin == 3
                % prototype devient Note(ind, dur, [tonstr octave])
            	note.indice = ind;
                note.duree = dur;
                conversionDuree(note, note.duree);
                note.tonstr = ton(1:2);
                conversionTonstr(note, note.tonstr);
                note.octave = str2num(ton(3));
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
            names = {'R ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#', 'A ', 'A#', 'B '};
            for j=1:13
               if strcmp(names{j}, tonstr) ~= 0
                  note.ton=j; % note attendue
               end
            end
        end
        
        function note = conversionTon(note, ton)
            switch ton
                case -1
                    note.tonstr = 'R '; % rest
                case 0
                    note.tonstr = 'C ';
                case 1
                    note.tonstr = 'C#';
                case 2
                    note.tonstr = 'D ';
                case 3
                    note.tonstr = 'D#';
                case 4
                    note.tonstr = 'E ';
                case 5
                    note.tonstr = 'F ';    
                case 6
                    note.tonstr = 'F#';
                case 7
                    note.tonstr = 'G ';
                case 8
                    note.tonstr = 'G#';
                case 9
                    note.tonstr = 'A ';
                case 10
                    note.tonstr = 'A#';    
                case 11
                    note.tonstr = 'B ';
                otherwise
                    disp('Erreur Ton note');
            end
        end
        
         function note = infoNoteHuman(note)
             disp([num2str(note.indice), '    ', note.dureestr, '    ', note.tonstr, num2str(note.octave)]) 
         end
         
         function note = infoNote(note)
             disp([num2str(note.indice), '    ', num2str(note.duree), '    ', num2str(note.ton), num2str(note.octave)]) 
         end
    end       
end

