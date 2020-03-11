m = 10;
x = exp.x;
delta = exp.delta;
cs = exp.cs;
Xs = (1:length(cs(:,1))) /  exp.zoom;
C = cs(:,m);
modelfun = @(b,X)((erf((X -(b(2)/2 + b(1) /2))   /   (b(2) /2 - b(1)/2)       )        +1)      /2);

[~,x0]=min((cs(:,1)-(erf(-1)+1)/2).^2); %find -delta point
[~,x1]=min((cs(:,1)-(erf(+1)+1)/2).^2); %find +delta point
    
figure
for m=1:length(cs(1,:))
    C = cs(:,m);
    plot(Xs, C)
    dia = 10;
    x0_min = max(1, x0-dia);
    x1_min = x1-dia;
    x0_max = min(x1_min - 1, x0+dia);
    x1_max = min(x1+dia, length(cs(:,1)));

    X = [Xs(x0_min:x0_max), Xs(x1_min:x1_max)];
    c = [C(x0_min:x0_max); C(x1_min:x1_max)];
    %X = [Xs(1:x0), Xs(x1:end)];
    %c = [C(1:x0); C(x1:end)];

    myfit = nlinfit(X',c,modelfun, [x0/exp.zoom x1/exp.zoom]);
    vals = round(myfit * exp.zoom);
    
    x0 = round(vals(1));
    x1 = round(vals(2));

    b(1) = myfit(1);
    b(2) = myfit(2);
    hold on
    l1 = line([x0 x0]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
    l2 = line([x1 x1]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
    plot(Xs, ((erf((Xs -(b(2)/2 + b(1) /2))/(b(2) /2 - b(1)/2))+1)/2))
    ylim([0 1])
    drawnow
    hold off
end