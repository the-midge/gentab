function [ note ] =determinationNote_HPS_Harmonic_method_combined(segment, Fs)

tabNomNotes=['E '; 'F '; 'F#'; 'G '; 'G#'; 'A '; 'A#'; 'B '; 'C '; 'C#'; 'D '; 'D#'];

segment=segment.*hamming(length(segment));

if(length(segment)<2^19)
segFftWin=fft(segment.*hann(length(segment)), 2^12);  
else
segFftWin=fft(segment.*hann(length(segments)));
end

y=length(segFftWin);
axe_freq = (0:y/2-1)*Fs/y;
segFftWin=abs(segFftWin(1:(length(segFftWin)/2)));
%figure,plot(axe_freq,segFftWin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Test sur la fft%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
[m n]=max(segFftWin);
pic_max_freq=axe_freq(n)
[l v]=findpeaks(segFftWin, 'SORTSTR', 'descend','MinPeakHeight',0.1*m); %seuil qui détermine nombre pics
vec_freq=axe_freq(v)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Technique pour regarder les harmoniques prépondérantes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         

    
tableNotes_2=generateTableNotes(false);   
tableNotes_2=tableNotes_2(:,:,3);
tableNotes_2=tableNotes_2(:);
vec_freq=axe_freq(v);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%% On attribue aux pics les notes correspondants aux fréquences de ceux-ci
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         

for i=1:length(vec_freq)
   indice(i)=findClosest(tableNotes_2, vec_freq(i));
   b(i)=mod(indice(i),12);
   if b(i)==0
       b(i)=12;
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
%% On regarde la note correspondant à la fréquence du pic maximum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freq_fond_max=findClosest(tableNotes_2,pic_max_freq);
note_freq_amp_max=mod(freq_fond_max,12);



indice=indice(1:length(vec_freq));
b=b(1:length(vec_freq))
uniqueX = unique(b)

    
countOfX = hist(b,uniqueX)
indexToRepeatedValue = (countOfX~=1)
[vl id]=find(indexToRepeatedValue==0)

%%


beta=uniqueX(indexToRepeatedValue)
is_here=find(beta==note_freq_amp_max);
o=isempty(is_here);

if (size(vl,2)~=size(uniqueX,2) && o==0) % Si il y a différentes harmoniques qui se répètent et si note_freq_amp_max est contenu dans ces harmoniques

%%

%beta=uniqueX(indexToRepeatedValue)

%%
nombre_harmoniques = countOfX(indexToRepeatedValue) % nombre de fois qu'une note-harmonique est présente

if (size(nombre_harmoniques,2)>1) % si il y a plusieurs harmoniques de plusieurs fréquences
    if size(unique(nombre_harmoniques),2)==1 % si il y a le même nombre d'harmoniques différentes : ex 220 440 150 300
        for i=1:length(beta)
            k(i,:)=find(b==beta(i));
            somme(i)=sum(l(k(i)));
        end
        somme
        [val1,ind1]=max(somme)
        beta(ind1)
        note_harmoniques_prepond=beta(ind1)
    % Cas où il y a le même nombre d'harmoniques
    % prendre la somme des amplitudes des harmoniques et prendre
    % l'harmonqique qui a la plus grande somme
    else % si il y a : 110 220 330 150 300, on prend l'harmonique prépondérante, donc 110 220 330 et on prend la note correspondante
     % Cas où il y a plus d'harmoniques d'une note
    % prendre la note ayant le plus grand nombre d'harmoniques
    [val ind]=max(countOfX)
    note_harmoniques_prepond=uniqueX(ind)
    end
else  % si il y a la des harmoniques correspondant à une seul fréq fondamentale
    note_harmoniques_prepond=uniqueX(indexToRepeatedValue) % harmonique prépondérante
end




else
   [valouz indouz]=max(l);
   hh=v(indouz);
   vec_freq=axe_freq(hh);
   grand_indiciouz=findClosest(tableNotes_2,vec_freq);
   note_harmoniques_prepond=mod(grand_indiciouz,12);
   if note_harmoniques_prepond==0
       note_harmoniques_prepond==12;
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%% Si cette note correspond à la note ayant le plus d'harmoniques
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if (note_freq_amp_max==note_harmoniques_prepond || note_freq_amp_max==note_harmoniques_prepond-1 || note_freq_amp_max==note_harmoniques_prepond+1)% si le pic en fréquence correspond à la note correspondant à l'harmonique prépondérante
   indicemax_freq=pic_max_freq/2; % on tombe dans le cas où c'est l'harmonique inférieure
    % sinon il faut prendre l'harmonique contenue dans le vec_freq la plus
    % proche de la freq
else
    indicemax_freq=pic_max_freq/3;
end    


    
if indicemax_freq<81
    indicemax_freq=indicemax_freq*2;
end   
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
% %% Recherche de la frÈquence la plus proche dans la table de notes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         

tableNotes=generateTableNotes(false);   % GÈnËre dans une table, les frÈquences des notes de E2 ? E6 (plus d'autres infos)
tableNotes(:,:,3);
A = reshape(tableNotes(:,:,3),1,[]);
g=findClosest(A, indicemax_freq);

if (mod(g,12)==0)
    h=12;
else   
h=mod(g,12);
end
if (indicemax_freq>63.5 && indicemax_freq<127)
    octave=2;
end
if (indicemax_freq>127 && indicemax_freq<244.5)
    octave=3;
end
if (indicemax_freq>244.5 && indicemax_freq<508)
    octave=4;
end
if (indicemax_freq>508 && indicemax_freq<1014)
octave=5;
end
if (indicemax_freq>1014 && indicemax_freq<2000)
octave=6;
end

note=[tabNomNotes(h,:)  num2str(octave)];

end