function [ output_args ] = plotDeltaMarkersVsTime(concentration, used_exp)
%plotDeltaVsTime plots delta vs time given specific concentration handle
%   Detailed explanation goes here
    experiments = fieldnames(concentration);
    plot_exp_count = length(used_exp);
    names = cell(1,plot_exp_count);
    PLOTS = gobjects(1,plot_exp_count);
    order = zeros(1,plot_exp_count);
    
    %formatting
    Cols=[230,159,0;86,180,233;0,158,115;240,228,66;0,114,178;213,94,0;204,121,167]/255; % color format
    symbs1={'o';'*';'d';'^';'p';'v'};
    symbs={'y-';'b-';'g-';'c-';'m-';'r-'};
    leg=cell(plot_exp_count,1);
    legpl=zeros(plot_exp_count,1);   
    
    for j=1:plot_exp_count
        i=used_exp(j);
        exp = concentration.(experiments{i});
        delta=exp.delta;
        %subtract startime from all values so resulting values are from 0
        %to end
        delta(:,1) = delta(:,1)- delta(1,1);
        %adjust deltas to zoom
        delta(:,2) = delta(:,2) / exp.zoom;
        
        %PLOTS(j)=plot(delta(:,1)/1e3,delta(:,2),'-'); %mainits uz 4 delts
        plot(delta(1:end,1)/1e3,2*delta(1:end,2),'-','LineWidth',1,...
        'HandleVisibility','off','Color',Cols(j,:));
        plot(delta(1:50:end,1)/1e3,2*delta(1:50:end,2),char(symbs1(j)),...
        'LineStyle','none','MarkerSize',7,'MarkerEdgeColor',Cols(j,:));
        xlabel('t, s');
        ylabel('2\delta^, mm');
        % will be later used to sort by Amps
        order(j)=exp.amperi;
        % name displayed in legend
        names{j}=strcat(num2str(exp.amperi,'%.2f'),'A / ',num2str(exp.lauksmT,'%.2f'),'mT');
        leg(j)={sprintf('%.1f Oe',exp.amperi*59.1)};
    end

    for j=1:plot_exp_count
        legpl(j)=plot(110,110,[char(symbs1(j)),'-'],'LineWidth',1,...
            'MarkerSize',7,'MarkerEdgeColor',Cols(j,:),'Color',Cols(j,:));
    end
    
    
    
    
    
    % get order of experiments sorted by amperage
    [~, order] = sort(order,'ascend');
    % sorts legend by Amp order
    %set(gca,'Children',PLOTS(order));
    %legend(PLOTS(order),names(order));
    axis([0 200 0 1])
    hLeg=legend(legpl,leg,'location','northwest','Box','off');

end

