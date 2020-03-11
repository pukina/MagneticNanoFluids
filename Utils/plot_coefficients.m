%%
%8 
% log 1/4delta^2 vs log(H^2)
skip = false;
if skip == false
    % create 4 graphs:
    % 1) (delta^2 /4) vs Ra_m
    % 2) delta^2 / Ram
    % 3) log(delta^2 / 4) vs log(Ram)
    % 4) log(delta^2) vs log(Ram)
    concentrations = fieldnames(MMML_dataset);
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    names = cell(1,length(concentrations));
    order = [1 3 2 4 5]; % HARDCODED order
    for i=1:numel(concentrations)
        %hh=figure;
        Sample = MMML_dataset.(concentrations{order(i)});
        Cfields = fieldnames(Sample);
        c = char(concentrations(i));
        if length(c)>4
            c =  str2num(c(6:end));
            decimals = length(num2str(c));
            c = c/(10^decimals);
            fprintf('Concentration %s is : %g\n',char(concentrations(i)), c);
        else
            c = 1;
            fprintf('Concentration %s is : %g\n',char(concentrations(i)), c);
        end
        valid_exp = 0;
        valid_exp_ind = [];
        for j=1:length(Cfields)
            exp = Sample.(Cfields{j});
            if isfield(exp,'validity')
                if exp.validity
                    valid_exp = valid_exp + 1;
                    valid_exp_ind = [valid_exp_ind, j];
                end
            else
                valid_exp_ind = [valid_exp_ind, j];
                valid_exp = valid_exp + 1;
            end
        end
        hold on
        X = ones(1, valid_exp);
        Y = ones(1, valid_exp);
        for j=1:valid_exp
            index = valid_exp_ind(j);
            exp = Sample.(Cfields{index});
            X(j) = log(exp.lauksmT^2);
            res = exp.coef(1)^2;
            Y(j) = log((exp.coef(1)^2));
            names{i} = exp.concentration;
        end
        [X,ind] = sort(X);
        Y = Y(ind);
        %scatter(X, Y);
        plot(X, Y,'-o');
    end
    legend(names);
    xlabel('log(H^2)');
    ylabel('log(\delta^2/4 MCV), mm^2');
    title('log(\delta^2/4 MCV) vs log(H^2)');
end
%% UUID = 15 uzdevums
% delta_MCV vs RAM
skip = false;
if skip == false
    % create 4 graphs:
    % 1) (delta^2 /4) vs Ra_m
    % 2) delta^2 / Ram
    % 3) log(delta^2 / 4) vs log(Ram)
    % 4) log(delta^2) vs log(Ram)
    xlabels = {'H',...
               'H^2',...
               'log(H^2)',...
               'log(Ra_m)',...
               'H',...
               'H^2',...
               'Ra_m'};
    ylabels = {'\delta^2/4, mm^2',...
               '\delta^2, mm^2',...
               'log(\delta^2/4), mm^2',...
               'log(\delta^2/4 MCV_bd)',...
               'slope, mm^2/s',...
               'slope, mm^2/s',...
               'slope MCV_bd'};
    for g=1:5
        concentrations = fieldnames(MMML_dataset);
        hh=figure;
        set(hh, 'Units', 'centimeters')
        set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
        set(hh, 'Position', [0 10 13.5 7])
        fsize=10;
        msize=7;
        fname='Times';
        names = cell(1,length(concentrations));
        order = [1 3 2 4 5]; % HARDCODED order
        for i=1:numel(concentrations)
            %hh=figure;
            Sample = MMML_dataset.(concentrations{order(i)});
            Cfields = fieldnames(Sample);
            c = char(concentrations(order(i)));
            if length(c)>4
                c =  str2num(c(6:end));
                decimals = length(num2str(c));
                c = c/(10^decimals);
                fprintf('Concentration %s is : %g\n',char(concentrations(order(i))), c);
            else
                c = 1;
                fprintf('Concentration %s is : %g\n',char(concentrations(order(i))), c);
            end
            valid_exp = 0;
            valid_exp_ind = [];
            for j=1:length(Cfields)
                exp = Sample.(Cfields{j});
                if isfield(exp,'validity')
                    if exp.validity
                        valid_exp = valid_exp + 1;
                        valid_exp_ind = [valid_exp_ind, j];
                    end
                else
                    valid_exp_ind = [valid_exp_ind, j];
                    valid_exp = valid_exp + 1;
                end
            end
            hold on
            X = ones(1, valid_exp);
            Y = ones(1, valid_exp);
            errors = ones(1, valid_exp);
            for j=1:valid_exp
                index = valid_exp_ind(j);
                exp = Sample.(Cfields{index});
                
                numenator = (c*exp.lauksmT*10*0.016*0.013)^2;
                denumenator = 12*0.01*(5.7*10^(-7));
                RAM = numenator / denumenator;
                
                % X coordinate processing
                if g==1 || g==5
                    X(j) = exp.lauksmT;
                elseif g==2 || g==6
                    X(j) = (exp.lauksmT)^2;
                elseif g==3
                    X(j) = log((exp.lauksmT)^2);
                elseif g ==4
                    X(j) = log(RAM);
                elseif g==7
                    X(j) = RAM;
                end
                if isinf(X(j))
                    fprintf('%s has RAM value %g\n',Cfields{index},X(j))
                    infinities = infinities + 1;
                end
                
                % Y coordinate processing
                if g==1 || g ==2
                    Y(j) = exp.coef(1);
                    errors(j) = exp.coef_errors(1);
                elseif g ==3
                    Y(j) = log(exp.coef(1));
                    errors(j) = log(exp.coef_errors(1));
                elseif g ==4
                    Y(j) = log(exp.bezdim_coef1(1));
                    errors(j) = log(exp.bezdim_coef1_errors(1));
                elseif g ==5 || g ==6
                    Y(j) = exp.coef(2);
                    errors(j) = exp.coef_errors(2);
                elseif g ==7
                    Y(j) = exp.bezdim_coef1(2);
                    errors(j) = exp.bezdim_coef1_errors(2);
                end
                names{i} = strcat('Ra_g= ',exp.concentration);
            end
            [X,ind] = sort(X);
            Y = Y(ind);
            errors = errors(ind);
            namespaces = Cfields(ind);
            namespaces = namespaces(infinities+1:end)'
        
            X = X(infinities+1:end);
            Y = Y(infinities+1:end);
            errors = errors(infinities+1:end);
            
            %scatter(X, Y);
            plot(X, Y,'-o');
            
            %[C,ia,idx] = unique(X,'stable');
            %val = accumarray(idx,Y,[],@mean); 
            %X = C;
            %Y = val;
            %errors = accumarray(idx,errors,[],@mean);
            %errorbar(X,Y,errors)
            
        end
        legend(names);
        legend('boxoff');
        xlabel(char(xlabels(g)));
        ylabel(char(ylabels(g)));
        %title('log(\delta^2/4) vs log(H^2)')
    end
end
%% 1/4delta^2 vs H^2
% 9
skip = false;
if skip == false
    concentrations = fieldnames(MMML_dataset);
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    names = cell(1,length(concentrations));
    order = [1 3 2 4 5]; % HARDCODED order
    for i=1:numel(concentrations)
        %hh=figure;
        Sample = MMML_dataset.(concentrations{order(i)});
        Cfields = fieldnames(Sample);
        
        valid_exp = 0;
        valid_exp_ind = [];
        for j=1:length(Cfields)
            exp = Sample.(Cfields{j});
            if isfield(exp,'validity')
                if exp.validity
                    valid_exp = valid_exp + 1;
                    valid_exp_ind = [valid_exp_ind, j];
                end
            else
                valid_exp_ind = [valid_exp_ind, j];
                valid_exp = valid_exp + 1;
            end
        end

        hold on
        X = ones(1, valid_exp);
        Y = ones(1, valid_exp);
        for j=1:valid_exp
            index = valid_exp_ind(j);
            exp = Sample.(Cfields{index});
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
    concentrations = fieldnames(MMML_dataset);
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    names = cell(1,length(concentrations));
    order = [1 3 2 4 5]; % HARDCODED order
    for i=1:numel(concentrations)
        %hh=figure;
        Sample = MMML_dataset.(concentrations{order(i)});
        Cfields = fieldnames(Sample);
        valid_exp = 0;
        valid_exp_ind = [];
        for j=1:length(Cfields)
            exp = Sample.(Cfields{j});
            if isfield(exp,'validity')
                if exp.validity
                    valid_exp = valid_exp + 1;
                    valid_exp_ind = [valid_exp_ind, j];
                end
            else
                valid_exp_ind = [valid_exp_ind, j];
                valid_exp = valid_exp + 1;
            end
        end
        hold on
        X = ones(1, valid_exp);
        Y = ones(1, valid_exp);
        for j=1:valid_exp
            index = valid_exp_ind(j);
            exp = Sample.(Cfields{index});
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

%% slope vs RAM
% 
skip = false;
if skip == false
    concentrations = fieldnames(MMML_dataset);
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    names = cell(1,length(concentrations));
    order = [1 3 2 4 5]; % HARDCODED order
    for i=1:numel(concentrations)
        %hh=figure;
        Sample = MMML_dataset.(concentrations{order(i)});
        Cfields = fieldnames(Sample);
        c = char(concentrations(i));
        if length(c)>4
            c =  str2num(c(6:end));
            decimals = length(num2str(c));
            c = c/(10^decimals);
        else
            c = 1;
        end
        if g == 1
            fprintf('Concentration %s is : %g\n',char(concentrations(i)), c);
        end
        valid_exp = 0;
        valid_exp_ind = [];
        for j=1:length(Cfields)
            exp = Sample.(Cfields{j});
            if isfield(exp,'validity')
                if exp.validity
                    valid_exp = valid_exp + 1;
                    valid_exp_ind = [valid_exp_ind, j];
                end
            else
                valid_exp_ind = [valid_exp_ind, j];
                valid_exp = valid_exp + 1;
            end
        end
        hold on
        X = ones(1, valid_exp);
        Y = ones(1, valid_exp);
        for j=1:valid_exp
            index = valid_exp_ind(j);
            exp = Sample.(Cfields{index});
            RAM = (exp.lauksmT*10*c*0.016)^2 * 0.013^2 / (12*0.01*5.7*10^(-7));
            X(j) = RAM;
            Y(j) = (exp.coef(2));
            names{i} = strcat('Ra_g= ',exp.concentration);
        end
        [X,ind] = sort(X);
        Y = Y(ind);
        %scatter(X, Y);
        plot(X, Y,'-o');
    end
    legend(names);
    xlabel('Ra_m');
    ylabel('slope');
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
    timestep = [10, 40]; % time is needed from experiment start time (absolute time of frame - exp. start)
    exp = MMML_dataset.D107.f1; % defaults = D107.f1 / D107_033.f16 /
    lineformat = [{'-g'},{'--b'},{':r'},{'-.k'}]; % line parameters
    widths = [1,1.5,2,1.5]; % line widths
    H = gobjects(1,4);
    max_x = 0;
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
        id = (j-1)*2 + 1;
        frt = lineformat(id);        
        H(id) = plot((1:length(a(:,1)))/exp.zoom,1-a(:,frame),frt{:},'LineWidth',widths(id));
        % plot vertical lines for delta
        dmin=x(frame,1);
        line([dmin dmin]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
        dmax=x(frame,2);
        line([dmax dmax]/exp.zoom, [0 1], 'Color',[.3 .3 .3]);
        Dc = (dmax - dmin)/2; % delta
        Xc = dmin + Dc; % Xvidus
        % plot horizontal line
        k = max(exp.x(:,2))*0.015;
        h = 0.015;
        l = 0.06;
        colors = [.3 .3 .3; 1 0 0];
        line([dmin dmax]/exp.zoom, [l*j l*j], 'Color',colors(j,:)); % main line
        line([dmin dmin+k]/exp.zoom, [l*j l*j+h], 'Color',colors(j,:)); % arrow left up
        line([dmin dmin+k]/exp.zoom, [l*j l*j-h], 'Color',colors(j,:)); % arrow left down
        line([dmax-k dmax]/exp.zoom, [l*j+h l*j], 'Color',colors(j,:)); % arrow right up
        line([dmax-k dmax]/exp.zoom, [l*j-h l*j], 'Color',colors(j,:)); % arrow right down
        s = strcat('2\delta_{', num2str(timestep(j),'%0.0f'),'s}');
        text(Xc/exp.zoom,l*j,s,...
        'VerticalAlignment','bottom','HorizontalAlignment','center','FontName','Times','FontSize',14);
        id = j*2;
        frt = lineformat(id);
        H(id) = plot((1:length(a(:,1)))/exp.zoom,1-(erf(((1:length(a(:,1))) - Xc)/Dc)+1)/2,frt{:},'LineWidth',widths(id));
        %plot(delta(:,1),delta(:,2).^2,'-');
        hold on
        %legend('boxoff');
        %ja vajag pielikt papildus info - piemeram atsauci (a) un (b) uz dazadiem atteliem

        %ja vajag legendu
        if max(exp.x(:,2))
            max_x = max(exp.x(:,2));
        end
    end
    %xticks([-3*pi -2*pi -pi 0 pi 2*pi 3*pi])
    %uzraksti-asiim
    xlabel('{\it mm}','FontName',fname,'FontSize',16);
    ylabel('{\it Concentration}','FontName',fname,'FontSize',14);

    ax = gca;
    ax.FontSize = 12;
    ax.XTick = [0:0.1:max_x];
    ax.YTick = [0 0.2 0.4 0.6 0.8 1.0];
    legend([H(1), H(2) H(3) H(4)],[num2str(timestep(1)),'s'],[num2str(timestep(1)),'s fitted']...
        ,[num2str(timestep(2)),'s'],[num2str(timestep(2)),'s fitted'],...
        'location','northeast','FontName','Times','FontSize',8);
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
%% THIS PLOTS CONCENTRATIONS
% UUID = 5 with 2 timesteps
% UUID = 19B with 1 timestep
timesteps = [10]; % time is needed from experiment start time (absolute time of frame - exp. start)
exp = MMML_dataset.D107_05.f1; % defaults = D107.f1 / D107_033.f16 /
hh=initFigure();
plotErf(exp,timesteps);

%%
%8 
% log 1/4delta^2 vs log(H^2)
skip = false;
if skip == false
    % create 4 graphs:
    % 1) (delta^2 /4) vs Ra_m
    % 2) delta^2 / Ram
    % 3) log(delta^2 / 4) vs log(Ram)
    % 4) log(delta^2) vs log(Ram)
    concentrations = fieldnames(MMML_dataset);
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    names = cell(1,length(concentrations));
    order = [1 3 2 4 5]; % HARDCODED order
    for i=1:numel(concentrations)
        %hh=figure;
        Sample = MMML_dataset.(concentrations{order(i)});
        Cfields = fieldnames(Sample);
        c = char(concentrations(i));
        if length(c)>4
            c =  str2num(c(6:end));
            decimals = length(num2str(c));
            c = c/(10^decimals);
            fprintf('Concentration %s is : %g\n',char(concentrations(i)), c);
        else
            c = 1;
            fprintf('Concentration %s is : %g\n',char(concentrations(i)), c);
        end
        valid_exp = 0;
        valid_exp_ind = [];
        for j=1:length(Cfields)
            exp = Sample.(Cfields{j});
            if isfield(exp,'validity')
                if exp.validity
                    valid_exp = valid_exp + 1;
                    valid_exp_ind = [valid_exp_ind, j];
                end
            else
                valid_exp_ind = [valid_exp_ind, j];
                valid_exp = valid_exp + 1;
            end
        end
        hold on
        X = ones(1, valid_exp);
        Y = ones(1, valid_exp);
        for j=1:valid_exp
            index = valid_exp_ind(j);
            exp = Sample.(Cfields{index});
            numenator = (exp.lauksmT*10*0.016*0.013).^2;
            denumenator = 12*0.01*(5.7*10^(-7));
            X(j) = log( numenator / denumenator );
            fprintf('%g',c)
            res = exp.bezdim_coef1(1)^2
            Y(j) = log(exp.bezdim_coef1(1)^2);
            names{i} = exp.concentration;
        end
        [X,ind] = sort(X);
        Y = Y(ind);
        %scatter(X, Y);
        plot(X, Y,'-o');
    end
    legend(names);
    xlabel('log(H^2)');
    ylabel('log(\delta^2/4), mm^2');
    title('log(\delta^2/4) vs log(H^2)');
end