function [ exp ] = normalizeData( exp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    cs = exp.cs;
    a = [min(cs(:,1),[],1);max(cs(:,1),[],1)];
    b = bsxfun(@minus,cs,a(1,:));
    cs = bsxfun(@rdivide,b,diff(a,1,1));
    exp.cs = cs;
    %recalculate deltas
    delta = exp.delta;
    x = exp.x;
    [~,x0]=min((cs-(erf(-1)+1)/2).^2); %find -delta point
    [~,x1]=min((cs-(erf(+1)+1)/2).^2); %find +delta point
    delta(:,2) = (x1 - x0)/2;
    x(:,1) = x0;
    x(:,2) = x1;
    exp.delta = delta;
    exp.x = x;

end

