%%
%8 
% log 1/4delta^2 vs log(H^2)
skip = false;
if skip == false
    fields = fieldnames(MMML_dataset);
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    names = cell(1,length(fields));
    order = [1 3 2 4 5]; % HARDCODED order
    for i=1:numel(fields)
        %hh=figure;
        Sample = MMML_dataset.(fields{order(i)});
        Cfields = fieldnames(Sample);

        hold on
        X = ones(1, length(Cfields));
        Y = ones(1, length(Cfields));
        for j=1:length(Cfields)
            exp = Sample.(Cfields{j});
            X(j) = log((exp.lauksmT).^2);
            Y(j) = log(1/4*((exp.coef(1)).^2));
            names{i} = exp.concentration;
        end
        [X,ind] = sort(X);
        Y = Y(ind);
        %scatter(X, Y);
        plot(X, Y,'-o');
    end
    legend(names);
    xlabel('log(H^2), mT');
    ylabel('log(\delta^2/4), mm^2');
    title('log(\delta^2/4) vs log(H^2)')
end
%% 1/4delta^2 vs H^2
% 9
skip = false;
if skip == false
    fields = fieldnames(MMML_dataset);
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    names = cell(1,length(fields));
    order = [1 3 2 4 5]; % HARDCODED order
    for i=1:numel(fields)
        %hh=figure;
        Sample = MMML_dataset.(fields{order(i)});
        Cfields = fieldnames(Sample);

        hold on
        X = ones(1, length(Cfields));
        Y = ones(1, length(Cfields));
        for j=1:length(Cfields)
            exp = Sample.(Cfields{j});
            X(j) = exp.lauksmT;
            Y(j) = 1/4*((exp.coef(1)).^2);
            names{i} = exp.concentration;
        end
        [X,ind] = sort(X);
        Y = Y(ind);
        %scatter(X, Y);
        plot(X, Y,'-o');
    end
    legend(names);
    xlabel('H^2, mT');
    ylabel('\delta^2/4, mm^2');
    title('Free coefficient vs H^2')
end
%% coefficient vs H
% 10
skip = false;
if skip == false
    fields = fieldnames(MMML_dataset);
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    names = cell(1,length(fields));
    order = [1 3 2 4 5]; % HARDCODED order
    for i=1:numel(fields)
        %hh=figure;
        Sample = MMML_dataset.(fields{order(i)});
        Cfields = fieldnames(Sample);

        hold on
        X = ones(1, length(Cfields));
        Y = ones(1, length(Cfields));
        for j=1:length(Cfields)
            exp = Sample.(Cfields{j});
            X(j) = (exp.lauksmT);
            Y(j) = (exp.coef(2));
            names{i} = exp.concentration;
        end
        [X,ind] = sort(X);
        Y = Y(ind);
        %scatter(X, Y);
        plot(X, Y,'-o');
    end
    legend(names);
    xlabel('H, mT');
    ylabel('k');
    title('Linear coefficient vs H')
end

%% plot erf and delta
% 11
skip = false;
if skip == false
    %erf plot Guntars formatting
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    timestep = [40.307 - 13.931, 40.372-13.931]; % time is needed from experiment start time (absolute time of frame - exp. start)
    exp = MMML_dataset.D107_025.f24; % defaults = D107.f1 / D107_033.f16 /
    for j=1:length(timestep)
        frame = exp.delta(:,1) - exp.delta(1,1);
        frame = 1 + length(frame) - length(frame(frame > timestep(j)*1000));
        display(frame);
        x = exp.x;
        %subplot(1,2,1)
        hold on
        title([exp.concentration,' ',num2str(exp.amperi),'A/',num2str(exp.lauksmT),'mT']);
        a=exp.cs;
        a(a<0)=0; %filter <0 values concentration values
        a(a>1)=1; %filter >1 values concentration values
        plot((1:length(a(:,1)))/exp.zoom,1-a(:,frame),'Color',[1 0 0]);
        dmin=x(frame,1);
        line([dmin dmin]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
        dmax=x(frame,2);
        line([dmax dmax]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
        Dc = (dmax - dmin)/2; % delta
        Xc = dmin + Dc; % Xvidus
        plot((1:length(a(:,1)))/exp.zoom,1-(erf(((1:length(a(:,1))) - Xc)/Dc)+1)/2,'Color',[0.2 1 0]);
        %plot(delta(:,1),delta(:,2).^2,'-');
        hold on
        %uzraksti-asiim
        xlabel('{\it mm}','FontName',fname,'FontSize',fsize);
        ylabel('{\it Concentration}','FontName',fname,'FontSize',fsize);
        legend([num2str(timestep(j)),'s'],'2\delta_{min}','2\delta_{max}', 'erf',...
        'location','northeast','FontName','Times','FontSize',8);
        %legend('boxoff');
        %ja vajag pielikt papildus info - piemeram atsauci (a) un (b) uz dazadiem atteliem

        %ja vajag legendu
    end
end
skip = true;
if skip == false
    timestep = [40];
    for j=1:length(timestep)
        frame = exp.delta(:,1) - exp.delta(1,1);
        frame = 1 + length(frame) - length(frame(frame > timestep(j)*1000));
        x = exp.x;
        subplot(1,2,2)
        hold on
        title([exp.concentration,' ',num2str(exp.amperi),'A/',num2str(exp.lauksmT),'mT']);
        %a=csvread(['0_1-2_sk-',char(pnames(j)),'.dat']);
        a=exp.cs;
        a(a<0)=0; %filter <0 values concentration values
        a(a>1)=1; %filter >1 values concentration values
        plot((1:length(a(:,1)))/exp.zoom,1-a(:,frame),'Color',[0 0 1]);
        dmin=x(frame,1);
        line([dmin dmin]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
        dmax=x(frame,2);
        line([dmax dmax]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
        Dc = (dmax - dmin)/2; % delta
        Xc = dmin + Dc; % Xvidus
        plot((1:length(a(:,1)))/exp.zoom,1-(erf(((1:length(a(:,1))) - Xc)/Dc)+1)/2,'Color',[0.2 1 0]);
        %plot(delta(:,1),delta(:,2).^2,'-');
        hold on
        %uzraksti-asiim
        xlabel('{\it mm}','FontName',fname,'FontSize',fsize);
        ylabel('{\it Concentration}','FontName',fname,'FontSize',fsize);
        legend([num2str(timestep(j)),'s'],'2\delta_{min}','2\delta_{max}', 'erf',...
        'location','northeast','FontName','Times','FontSize',8);
        %legend('boxoff');
        %ja vajag pielikt papildus info - piemeram atsauci (a) un (b) uz dazadiem atteliem
        axes('Position',[0 0 1 1],'Visible', 'off'); 
        %text(0.01,0.98,'(a)','FontName',fname,'FontSize',fsize);
        %text(0.51,0.98,'(b)','FontName',fname,'FontSize',fsize);
        %ja vajag legendu
    end
end