function [ exp ] = normalizeErffit( exp )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    fprintf('Current experiment: f%s\n',exp.subpath); % Print current experiment
    x = exp.x;
    delta = exp.delta;
    cs = exp.cs;
    Xs = (1:length(cs(:,1))) /  exp.zoom;
    [~,x0]=min((cs-(erf(-1)+1)/2).^2); %find -delta point
    [~,x1]=min((cs-(erf(+1)+1)/2).^2); %find +delta point

    lim = [min(cs,[],1);max(cs,[],1)];
    a = bsxfun(@minus,cs,lim(1,:));
    csn = bsxfun(@rdivide,a,diff(lim,1,1));
    t = (erf(-1)+1)/2; % target = 0.0786
    tol = 0.02;

    modelfun = @(b,X)((erf((X -(b(2)/2 + b(1) /2))   /   (b(2) /2 - b(1)/2)       )        +1)      /2);
    for m=1:length(cs(1,:))
        if mod(m,500)==0;
            display(sprintf('%d of %d',m,length(cs(1,:)))); %print calculation progress
            %break
        end
        indices = (csn(:,m)>1-t-tol) & (csn(:,m) < 1-t+tol) |...
        ((csn(:,m)>t-tol) & (csn(:,m) < t+tol));
        X = Xs(indices);
        C = cs(:,m);
        c = C(indices);

        myfit = nlinfit(X',c,modelfun, [x0(m)/exp.zoom x1(m)/exp.zoom]);
        vals = round(myfit * exp.zoom);

        x(m,1) = vals(1);
        x(m,2) = vals(2);
    end
    delta(:,2) = (x(:,2) - x(:,1))/2;
    exp.x = x;
    exp.delta = delta;

end

