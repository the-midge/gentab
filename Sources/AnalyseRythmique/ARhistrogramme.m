ecart=diff(bornes)/Fs;

probabilitesInitiales = [0.15;0.3;0.05;0.2;0.03;0.1;0.02;0.05;0;0;0;0.05;0;0;0;0.05];
 facteursReferences = (0.25:0.25:4)';
 
 edgeHistogramme = [0];
 

 decalage = 0;
for k=1:length(facteursReferences)-1
     if(probabilitesInitiales(k+1) == 0)
         decalage=decalage+1;
     else
         edgeHistogramme(k+1)= getBarycentre(facteursReferences(k-decalage), facteursReferences(k+1), probabilitesInitiales(k+1), probabilitesInitiales(k-decalage)); %la probabilité d'un point est donnée à l'autre point car il y a une notion dinverse
         if decalage>0
             while (decalage>=0)
                 edgeHistogramme(k-decalage)=edgeHistogramme(k+1);
                 decalage=decalage-1;
             end
         end
%          edgeHistogramme(k+1) = sum(probabilitesInitiales(k:k+1).*facteursReferences(k:k+1))/sum(probabilitesInitiales(k:k+1));
     end
     k=k+1;
 end
 
 edgeHistogramme(k+1) = 5;


determinationTempoV2
tempo=tempo/2;
ecartRef=60/tempo;
figure(1), clf
[pop, centres] = histc(ecart, edgeHistogramme*ecartRef);
bar(edgeHistogramme*ecartRef, pop, 'histc')
hold on
scatter(edgeHistogramme*ecartRef, [0; probabilitesInitiales]*max(pop)/2)
figure(2), clf
plot(repmat(edgeHistogramme*ecartRef, length(ecart), 1)); hold on;
stem(ecart, 'b');
stem(centres, 'r');