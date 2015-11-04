clear all
clc

%% Algo de correction de la duree des notes suivant un decoupage en mesure 4:4
% Suite a la generation des probabilites de chaque duree de note
% (generatePeigneGaussienne), on determine en cas de conflit la duree la
% plus probable de la note a traiter.

generatePeigneGaussienne;

dureesMesurees = [1.2 2.6 6.3 7.22 14.7]';
[matriceProbaDuree] = determinationDurees(dureesMesurees, peigneGaussienne, abscisse);

%% fonction affectation probas

% out = zeros(length(dureesMesurees), 5);
% 
% out(:, 1) = dureesMesurees;
% 
% out(:, 2) = floor(dureesMesurees);
% 
% for m = 1:length(dureesMesurees)
%     [c index(m)] = min(abs(abscisse-dureesMesurees(m)));
%     if(peigneGaussienne(index(m), out(m, 2)) ~= 0)
%         out(m, 3) = peigneGaussienne(index(m), out(m, 2));
%     else
%         g = 1;
%         while((peigneGaussienne(index(m), out(m, 2)) == 0) ...
%             && (out(m, 2) > 0))
%             out(m, 2) = out(m, 2) - g;
%         end
%         out(m, 3) = peigneGaussienne(index(m), out(m, 2));
%     end
% end

            
% 
% 
% out(:, 4) = floor(dureesMesurees) + 1;

% for m = 1:length(dureesMesurees)
%     [c index(m)] = min(abs(abscisse-dureesMesurees(m)));
%     if(peigneGaussienne(index(m), out(m, 4)) ~= 0)
%         out(m, 5) = peigneGaussienne(index(m), out(m, 4));
%     else
%         h = 1;
%         while((peigneGaussienne(index(m), out(m, 4)) == 0) ...
%             && (out(m, 4) < 16))
%             out(m, 4) = out(m, 4) + h;
%         end
%         out(m, 5) = peigneGaussienne(index(m), out(m, 4));
%     end
% end


