index = 1;
folder = 'E:\Darbs\MMML\apstradati_janvara merijumi\DeltaVsTime\Smoothing';
%folder = 'E:\Darbs\MMML\apstradati_janvara merijumi\DeltaVsTime\Sakuma_koncentracija_taisne';
%folder = 'E:\Darbs\MMML\apstradati_janvara merijumi\DeltaVsTime\Tikai_normalizacija';
concentrations = fieldnames(MMML_dataset);
hh =initFigure();
hh2 = initFigure();
for i=1:numel(concentrations)
    Sample = MMML_dataset.(concentrations{i});
    experiments = fieldnames(Sample);
    for j=1:length(experiments)
        fprintf('Current experiment: %s\n',experiments{j}); % Print current experiment
        figure(hh);
        exp = Sample.(experiments{j});
        string = strcat(cellstr(concentrations{i}),'/',cellstr(experiments{j}),' original');
        cs = exp.cs;
        %index = round(length(cs(1,:))/2);
        
        subplot(1,2,1);
        plot(1-cs(:,index)); % original
        hold on
        title(string);
        dmin=exp.x(index,1);
        %line([dmin dmin], [0 1], 'Color',[.3 .3 .3]);
        dmax=exp.x(index,2);
        %line([dmax dmax], [0 1], 'Color',[.3 .3 .3]);
        x0=(cs(:,index)-(erf(-1)+1)/2).^2; %find -delta point
        x1=(cs(:,index)-(erf(+1)+1)/2).^2; %find +delta point
        x0Indices = find(x0 == min(x0));
        x1Indices = find(x1 == min(x1));
        for m=1:length(x0Indices)
            line([x0Indices(m) x0Indices(m)], [-0.2 1.2], 'Color',[.3 .3 .3]);
        end
        for m=1:length(x1Indices)
            line([x1Indices(m) x1Indices(m)], [-0.2 1.2], 'Color',[.0 .0 .9]);
        end
        delta = (dmax - dmin)/2;
        Xc = dmin + delta;
        len = length(cs(:,index));
        plot(1:len, 1-(erf(((1:len) - Xc)/delta)+1)/2);
        hold off
        
        subplot(1,2,2);
        % normalize concentration values
%         a = [min(cs,[],1);max(cs,[],1)];
%         b = bsxfun(@minus,cs,a(1,:));
%         cs = bsxfun(@rdivide,b,diff(a,1,1));
        
        % make start concentratios always declining
%         for m=1:length(cs(1,:))
%            [val, idx] = max(1-cs(:,m));
%            cs(1:idx,m)=1-val;
%         end
        
        % smooth concentrations
        for m=1:length(cs(1,:))
            cs(:,m) = smooth(cs(:,m), 5);
        end

        %recalculate deltas
        delta = exp.delta;
        x = exp.x;
        [~,x0]=min((cs-(erf(-1)+1)/2).^2); %find -delta point
        [~,x1]=min((cs-(erf(+1)+1)/2).^2); %find +delta point
        delta(:,2) = (x1 - x0)/2;
        x(:,1) = x0;
        x(:,2) = x1;
        
        % plot for adjusted concentrations and deltas for single frame
        dmin=x(index,1);
        dmax=x(index,2);
        D = (dmax - dmin)/2;
        Xc = dmin + D;
        plot(1-cs(:,index));
        hold on
        
        x0=(cs(:,index)-(erf(-1)+1)/2).^2; %find -delta point
        x1=(cs(:,index)-(erf(+1)+1)/2).^2; %find +delta point
        x0Indices = find(x0 == min(x0));
        x1Indices = find(x1 == min(x1));
        for m=1:length(x0Indices)
            line([x0Indices(m) x0Indices(m)], [-0.2 1.2], 'Color',[.3 .3 .3]);
        end
        for m=1:length(x1Indices)
            line([x1Indices(m) x1Indices(m)], [-0.2 1.2], 'Color',[.0 .0 .9]);
        end
        plot(1:len, 1-(erf(((1:len) - Xc)/D)+1)/2);
        %save figure
        frame = exp.frames(1) + index -1;
        name = strcat(char(concentrations{i}),'_',char(experiments{j}),'_frame_',num2str(frame));
        filename = strcat(folder,'\',name);
        time = (delta(index,1) - delta(1,1)) / 1000;
        string = strcat(cellstr(concentrations{i}),'/',cellstr(experiments{j}),', time=',num2str(time),'s');
        title(string);
        print(hh,filename,'-dpng');
        hold off
        
        %%%
        % plot DELTA vs TIME
        %%%
        figure(hh2);
        hold on
        test = struct();
        test.f1 = exp;
        
        test_exp = exp;
        test_exp.cs = cs;
        test_exp.delta = delta;
        test_exp.amperi = 0;
        test_exp.lauksmT = 0;
        test.f2 = test_exp;
        
        plotDeltaVsTime(test);
        
        prompt = ['Is this good? Press enter to continue\n'];
        x = input(prompt,'s');
        
        name = strcat(char(concentrations{i}),'_',char(experiments{j}),'_deltaVStime');
        filename = strcat(folder,'\',name);
        print(hh2,filename,'-dpng');
        clf(hh2,'reset')
        hold off
        
    end
end