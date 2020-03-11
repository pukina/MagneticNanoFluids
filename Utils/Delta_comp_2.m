
indexes = [1, 50];
%exp = MMML_dataset.D107.f6;
exp = MMML_dataset.D107_033.f7;
for i=1:length(indexes)
    index = indexes(i);
    cs = exp.cs;
    subplot(2,length(indexes),1+(i-1)*2);
    plot(1-cs(:,index)); % original
    hold on
    dmin=exp.x(index,1);
    line([dmin dmin], [0 1], 'Color',[.3 .3 .3]);
    dmax=exp.x(index,2);
    line([dmax dmax], [0 1], 'Color',[.3 .3 .3]);
    [~,x0]=min((cs(:,index)-(erf(-1)+1)/2).^2); %find -delta point
    [~,x1]=min((cs(:,index)-(erf(+1)+1)/2).^2); %find +delta point
    delta = (x1 - x0)/2;
    Xc = dmin + delta;
    len = length(cs(:,index));
    plot(1:len, 1-(erf(((1:len) - Xc)/delta)+1)/2);
    hold off

    subplot(2,length(indexes),2+(i-1)*2);
    [val, idx] = max(1-cs(:,index));
    cs(1:idx,index)=1-val;
    plot(1-cs(:,index));
    hold on
    [~,x0]=min((cs(:,index)-(erf(-1)+1)/2).^2); %find -delta point
    [~,x1]=min((cs(:,index)-(erf(+1)+1)/2).^2); %find +delta point
    delta = (x1 - x0)/2;
    Xc = x0 + delta;
    plot(1:len, 1-(erf(((1:len) - Xc)/delta)+1)/2);
    line([x0 x0], [0 1], 'Color',[.3 .3 .3]);
    line([x1 x1], [0 1], 'Color',[.3 .3 .3]);
    hold off
end