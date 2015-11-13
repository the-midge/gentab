function [ result ] = sumInRange( x, low, high )
%sumInRange.m
    index_low = int32(low);
    index_high = int32(high);
    if high == 1
        index_high = length(x)-1;
    end
    if high > length(x)-1
        index_high = length(x)-1;
    end
    if low < 1
        index_low = 0;
    end

    result = sum(x(1+index_low:1+index_high));

end

