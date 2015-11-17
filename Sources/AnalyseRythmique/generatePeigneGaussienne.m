%%
    % probabilitesInitialesV2 est issu de la publication
    % ViitKE03-melodies.pdf
    probabilitesInitialesV2 = [0.02;0.107;0.012;0.079;0.0005;0.01;0.0005;0.0201;0;0;0;0.0005;0;0;0;0.006];
%                               1     2   3        4   5     6       7     8   9 10 11 12   13 14 15 16
   % probabilitesInitialesV2 = probabilitesInitialesV2*1/sum(probabilitesInitialesV2);
    %probabilitesInitiales = probabilitesInitialesV2;    
    facteursReferences = (0.25:0.25:4)'; % facteur multiplicatif par rapport à la noire=1 (ronde=4, croche = 0.5)

        probabilitesInitiales = [0.15;0.3;0.05;0.2;0.05;0.1;0.02;0.05;0;0;0;0.05;0;0;0;0.03];
    %                             1     2   3   4   5   6   7       8 9 10 11 12 13 14 15 16
    %% Calcul des intervalles
    edgeHistogramme = [0];
    decalage = 0;
    for k=1:length(facteursReferences)-1
        if(probabilitesInitiales(k+1) == 0)
            decalage=decalage+1;
        else
            edgeHistogramme(k+1)= getBarycentre(facteursReferences(k-decalage), facteursReferences(k+1), probabilitesInitiales(k+1), probabilitesInitiales(k-decalage)); %la probabilité d'un point est donnée à l'autre point car il y a une notion dinverse
             if decalage>0
                while (decalage>0)
                    edgeHistogramme(k-decalage+1)=edgeHistogramme(k+1);   
                    decalage=decalage-1;
                end
            end
        end
        k=k+1;
    end
    edgeHistogramme(k+1) = 5;



%%
edgeHistogramme=edgeHistogramme'*4;
centres=facteursReferences*4;

facteur= 10e3;

MIN = facteur;
MAX = 2*facteur*centres(end);

largeurs_droites=floor((edgeHistogramme(2:end)-centres)*facteur/2)*2*2;
largeurs_droites(largeurs_droites<=0)=2;
largeurs_droites([(9:11),(13:15)])=2;
largeurs_seuil_droit=zeros(size(largeurs_droites));
largeurs_seuil_droit(largeurs_droites<facteur)=facteur-largeurs_droites(largeurs_droites<facteur);

largeurs_gauches=floor((centres-edgeHistogramme(1:end-1))*facteur/2)*2*2;
largeurs_gauches([(9:11),(13:15)])=2;
largeurs_gauches(largeurs_gauches<=0)=2;
largeurs_seuil_gauche=zeros(size(largeurs_gauches));
largeurs_seuil_gauche(largeurs_gauches<facteur)=facteur-largeurs_gauches(largeurs_gauches<facteur);

seuilMinimal=0.01;
for k = 1:16
win_gauche=gausswin(largeurs_gauches(k)*2, 3);
win_droite=gausswin(largeurs_droites(k)*2, 3);
peigneGaussienne(:,k)=[zeros(MIN+centres(k)*facteur-largeurs_gauches(k)-largeurs_seuil_gauche(k),1); ones(largeurs_seuil_gauche(k),1)*seuilMinimal; win_gauche(1:largeurs_gauches(k)); win_droite(largeurs_droites(k)-1:end); ones(largeurs_seuil_droit(k),1)*seuilMinimal; zeros(MAX+MIN-centres(k)*facteur-largeurs_droites(k)-largeurs_seuil_droit(k),1)];
end
peigneGaussienne=bsxfun(@rdivide, peigneGaussienne, sum(peigneGaussienne,2));
abscisse = (1:length(peigneGaussienne))/facteur-1;
% Visualisation
%plot(abscisse,    peigneGaussienne), grid on, axis([0 20 0 1]);