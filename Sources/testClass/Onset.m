classdef Onset
    % la classe Note stocke les différentes informations suivantes :
    %
    % - l'indice de l'onset qui correspond au debut de l'attaque
    % - la duree correspondante de la note jouee
    % - la note jouee
    % - l'octave correpondantes de la note jouee
    
    properties
        indice;
        duree;
        note;
        octave;
    end
    
    methods
        % Constructeur
        function onset = Onset(ind, dur, not, oct)
            onset.indice = ind;
            onset.duree = dur;
            onset.note = not;
            onset.octave = oct;
        end
            
        % setter
        function onset = setIndice(ind)
            onset.indice = ind;
        end
         function onset = setDuree(dur)
            onset.duree = dur;
         end
         function onset = setNote(not)
            onset.note = not;
         end
         function onset = setOctave(oct)
            onset.octave = oct;
         end
         function onset = infoNote(onset)
             disp([num2str(onset.indice), '    ', num2str(onset.duree), '    ', num2str(onset.note), '    ', num2str(onset.octave)]) 
         end
    end
end

