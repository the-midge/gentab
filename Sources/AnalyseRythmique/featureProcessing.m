currTempo=temposCandidats(tau);
ecartAutoriseBPM=8;

Pt2=    sumInRange(C,currTempo/2-ecartAutoriseBPM,currTempo/2+ecartAutoriseBPM);
Pt=     sumInRange(C, currTempo-ecartAutoriseBPM, currTempo+ecartAutoriseBPM);
P2t=    sumInRange(C,2*currTempo-ecartAutoriseBPM,2*currTempo+ecartAutoriseBPM); %Pb: on srt de C

nbCroches=length(find(durees==2));
nbNoires=length(find(durees==4));
nbDoubleCroches=length(find(durees==1));
nbReste = length(find(durees~=1 & durees~=2 & durees~=4));
nbConcurrents = length(temposCandidats);

features = [ nbConcurrents
             currTempo
             nbCroches 
             nbNoires 
             nbDoubleCroches 
             nbReste 
             mean(probasMax(:,tau))
             nbCroches./(nbNoires+nbDoubleCroches+nbReste)
             ];