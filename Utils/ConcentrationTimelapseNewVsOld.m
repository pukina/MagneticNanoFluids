%m = 10;

x = exp.x;
delta = exp.delta;
cs = exp.cs;


Xs = (1:length(cs(:,1))) /  exp.zoom;

modelfun = @(b,X)((erf((X -(b(2)/2 + b(1) /2))   /   (b(2) /2 - b(1)/2)       )        +1)      /2);

[~,x0]=min((cs-(erf(-1)+1)/2).^2); %find -delta point
[~,x1]=min((cs-(erf(+1)+1)/2).^2); %find +delta point
C = cs(:,m);
times = exp.delta(:,1) - exp.delta(1,1);
figure
for m=1:length(cs(1,:))
    C = cs(:,m);
    plot(Xs, C)
    t = (erf(-1)+1)/2; % target = 0.0786
    tol = 0.02;
    
    indices = (csn(:,m)>1-t-tol) & (csn(:,m) < 1-t+tol) |...
                ((csn(:,m)>t-tol) & (csn(:,m) < t+tol));
    X = Xs(indices);
    c = C(indices);
%     X = [Xs(csn(:,m)>t-tol & csn(:,m) < t+tol) Xs(csn(:,m)>1-t-tol & csn(:,m) < 1-t+tol)];
%     c = [C(csn(:,m)>t-tol & csn(:,m) < t+tol); C(csn(:,m)>1-t-tol & csn(:,m) < 1-t+tol)];
%     X = [Xs(C>0.05 & C < 0.11) Xs(C>0.89 & C < 0.95)];
%     c = [C(C>0.05 & C < 0.11); C(C>0.89 & C < 0.95)];
    %X = [Xs(1:x0), Xs(x1:end)];
    %c = [C(1:x0); C(x1:end)];

    myfit = nlinfit(X',c,modelfun, [x0(m)/exp.zoom x1(m)/exp.zoom]);
    vals = round(myfit * exp.zoom);

    b(1) = myfit(1);
    b(2) = myfit(2);
    hold on
    l1 = line([x0(m) x0(m)]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
    l2 = line([x1(m) x1(m)]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
    l3 = line([vals(1) vals(1)]/exp.zoom, [0 1], 'Color',[.6 .0 .6]);
    l4 = line([vals(2) vals(2)]/exp.zoom, [0 1], 'Color',[.6 .0 .6]);
    plot(Xs, ((erf((Xs -(b(2)/2 + b(1) /2))/(b(2) /2 - b(1)/2))+1)/2))
    ylim([0 1])
    title(sprintf('%g of %g',times(m)/1000,times(end)/1000));
    drawnow
    hold off
end