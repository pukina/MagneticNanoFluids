function [ c ] = AcquireConcentrationValue( sample )
%UNTITLED6 Summary of this function goes here
    c = char(sample);
    if length(c)>4
        c =  str2num(c(6:end));
        decimals = length(num2str(c));
        c = c/(10^decimals);
    else
        c = 1;
    end
end