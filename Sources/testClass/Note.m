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
    %   * 1  <=>  La  (A)
    %   * 2  <=>  Si  (B)
    %   * 4  <=>  Do  (C)
    %   * 6  <=>  Re  (D)
    %   * 8  <=>  Mi  (E)
    %   * 9  <=>  Fa  (F)
    %   * 11 <=>  Sol (G)
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
        % Constructeur
        function note = Note(ind, dur, ton, oct)
            if nargin == 4
            	note.indice = ind;
                note.duree = dur;
                conversionDuree(note, note.duree);
                note.ton = ton;
                conversionTon(note, note.ton);
                note.octave = oct;
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
                case 6
                    note.dureestr = 'noire pointee';
                case 8
                    note.dureestr = 'blanche';
                case 12
                    note.dureestr = 'blanche pointee';
                case 16
                    note.dureestr = 'ronde';
                otherwise
                    disp('erreur Duree note');  
            end
        end
        
        function note = conversionTon(note, ton)
            switch ton
                case 1
                    note.tonstr = 'A ';
                case 2
                    note.tonstr = 'A#';    
                case 3
                    note.tonstr = 'B ';
                case 4
                    note.tonstr = 'C ';
                case 5
                    note.tonstr = 'C#';
                case 6
                    note.tonstr = 'D ';
                case 7
                    note.tonstr = 'D#';
                case 8
                    note.tonstr = 'E ';
                case 9
                    note.tonstr = 'F ';    
                case 10
                    note.tonstr = 'F#';
                case 11
                    note.tonstr = 'G ';
                case 12
                    note.tonstr = 'G#';
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

