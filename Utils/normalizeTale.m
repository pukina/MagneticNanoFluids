function [ exp ] = normalizeTale( exp )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    cs = exp.cs;
    reference = cs(:,1);
    [~, topidx ]= max(reference);
    [~, botidx ]= min(reference);
    
    for m=1:length(cs(1,:))
        %[val, idx] = min(cs(:,m));
        %cs(1:idx,m)=val;
        vals = cs(1:botidx,m) - reference(1:botidx);
        vals(vals<0)=0;
        cs(1:botidx,m) = vals;
        
        vals = reference(topidx:end) - cs(topidx:end,m);
        vals(vals<0)=0;
        cs(topidx:end,m) = 1 - vals;
        %[val, idx] = max(cs(:,m));
        %cs(idx:end,m)=val;
    end
    %recalculate deltas
    delta = exp.delta;
    x = exp.x;
    [~,x0]=min((cs-(erf(-1)+1)/2).^2); %find -delta point
    [~,x1]=min((cs-(erf(+1)+1)/2).^2); %find +delta point
    delta(:,2) = (x1 - x0)/2;
    x(:,1) = x0;
    x(:,2) = x1;
    exp.cs = cs;
    exp.delta = delta;
    exp.x = x;

end

