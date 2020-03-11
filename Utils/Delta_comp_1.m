index = 50;
concentrations = fieldnames(MMML_dataset);
hh =figure;
for i=1:numel(concentrations)
    Sample = MMML_dataset.(concentrations{i});
    experiments = fieldnames(Sample);
    for j=1:length(experiments)
        exp = Sample.(experiments{j});
        string = strcat(cellstr(concentrations{i}),'/',cellstr(experiments{j}));
        cs = exp.cs;
        subplot(1,2,1);
        plot(1-cs(:,index)); % original
        hold on
        title(string);
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
        
        subplot(1,2,2);
        [val, idx] = max(1-cs(:,index));
        cs(1:idx,index)=1-val;
        plot(1-cs(:,index));
        hold on
        title(string);
        [~,x0]=min((cs(:,index)-(erf(-1)+1)/2).^2); %find -delta point
        [~,x1]=min((cs(:,index)-(erf(+1)+1)/2).^2); %find +delta point
        delta = (x1 - x0)/2;
        Xc = x0 + delta;
        plot(1:len, 1-(erf(((1:len) - Xc)/delta)+1)/2);
        line([x0 x0], [0 1], 'Color',[.3 .3 .3]);
        line([x1 x1], [0 1], 'Color',[.3 .3 .3]);
        hold off
        prompt = ['Is this good? Press enter to continue\n'];
        x = input(prompt,'s');
    end
end