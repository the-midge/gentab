function [ INDICE ] = findClosest(SRC, WHAT)
%[ INDICE ] = findClosest(SRC, WHAT)
%   return the INDICE in vector SRC of its value which is the closest to
%   WHAT
    sizeW=size(WHAT);
    
    if(sizeW==[1,1])   %If WHAT is a scalar
        INDICE=find(abs(SRC-WHAT)==min(abs(SRC-WHAT)));
    elseif(size(sizeW)==[1,2])    %%If WHAT is a Matrix
        INDICE=zeros(sizeW);
        for(i=(1:sizeW(1)))
            for(j=(1:sizeW(2)))
                INDICE(i,j)=find(abs(SRC-WHAT(i,j))==min(abs(SRC-WHAT(i,j))));
            end
        end
    end                
end

