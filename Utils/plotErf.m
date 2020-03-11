function [ title_name] = plotErf(exp, timesteps)
%
%   plot erf and delta
    hold on
    legpl=zeros(2*length(timesteps),1);
    lineformat = [{'-'},{'--'},{':'},{'-.'}]; % line parameters
    colorformat = [{'g'},{'b'},{'r'},{'k'}]; % line parameters
    Cols=[230,159,0;86,180,233;0,158,115;0,114,178;213,94,0;204,121,167]/255;
    symbs1={'o';'*';'d';'^';'p';'v'};
    widths = [1,1.5,2,1.5]; % line widths
    concentration_name = char(exp.concentration);
    if strcmp(concentration_name,'D107')
        c = 1.0;
    elseif strcmp(concentration_name,'0.67D107')
        c=0.67;
    elseif strcmp(concentration_name,'0.5D107')
        c=0.5;
    elseif strcmp(concentration_name,'0.33D107')
        c=0.33;
    elseif strcmp(concentration_name,'0.25D107')
        c=0.25;
    end
    RAM = (exp.lauksmT*10*c*0.016)^2 * 0.013^2 / (12*0.01*5.7*10^(-7));
    H = gobjects(1,length(timesteps));
    max_x = 0;
    for j=1:length(timesteps)
        frame = exp.delta(:,1) - exp.delta(1,1);
        frame = length(frame) - length(frame(frame > timesteps(j)*1000)); % no +1 needed
        display(frame);
        cs=exp.cs;
        x = exp.x;
        x = fliplr(length(cs(:,1)) - x);
        %subplot(1,2,1)
        title_name = sprintf('%s_Ram_%g_time_%g_subpath_%s',char(exp.concentration),...
            RAM, timesteps(1), char(exp.subpath));
        title([exp.concentration,' ',num2str(exp.amperi),'A/',num2str(exp.lauksmT),'mT/subpath',char(exp.subpath),...
            sprintf('/RAM %g',RAM)]);
        cs(cs<0)=0; %filter <0 values concentration values
        cs(cs>1)=1; %filter >1 values concentration values
        id = (j-1)*2 + 1;
        format_line = lineformat(id);
        data_length = length(cs(:,1));
        x_axis = (1:data_length)/exp.zoom;
        y_axis = flipud(cs(1:data_length,frame));
        H(id) = plot(x_axis,y_axis,format_line{:},'LineWidth',widths(id), 'Color',Cols(id,:));
        marker_range = 1:25:data_length;
        x_axis = x_axis(marker_range);
        y_axis = y_axis(marker_range);
        plot(x_axis,y_axis,char(symbs1(2*j-1)),...
        'LineStyle','none','MarkerSize',7,'MarkerEdgeColor',Cols(id,:));
        
        id = j*2;
        format_line = lineformat(id);
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
        colors = [0 0 1;0 0 1];
        line([dmin dmax]/exp.zoom, [l*j l*j], 'Color',colors(j,:)); % main line
        line([dmin dmin+k]/exp.zoom, [l*j l*j+h], 'Color',colors(j,:)); % arrow left up
        line([dmin dmin+k]/exp.zoom, [l*j l*j-h], 'Color',colors(j,:)); % arrow left down
        line([dmax-k dmax]/exp.zoom, [l*j+h l*j], 'Color',colors(j,:)); % arrow right up
        line([dmax-k dmax]/exp.zoom, [l*j-h l*j], 'Color',colors(j,:)); % arrow right down
        s = strcat('2\delta_{', num2str(timesteps(j),'%0.0f'),'s}');
        text(Xc/exp.zoom,l*j,s,...
        'VerticalAlignment','bottom','HorizontalAlignment','center','FontName','Times','FontSize',14);
        mm = (1:length(cs(:,1)))/exp.zoom;
        num = (1:length(cs(:,1))) - Xc;
        erffit = (erf(num/Dc)+1) /2;
        H(id) = plot(mm, 1 - erffit, format_line{:},'LineWidth',widths(id),'Color',Cols(id,:));
        mm = mm(marker_range);
        erffit = erffit(marker_range);
        plot(mm,1-erffit,char(symbs1(2*j)),...
        'LineStyle','none','MarkerSize',7,'MarkerEdgeColor',Cols(id,:));
        %H(id) = plot((1:length(cs(:,1)))/exp.zoom,1-(erf(((1:length(cs(:,1))) - Xc)/Dc)+1)/2,frt{:},'LineWidth',widths(id));
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

    
    xlabel('mm','FontName','Times','FontSize',16);
    ylabel('Concentration','FontName','Times','FontSize',14);

    ax = gca;
    ax.FontSize = 12;
    ax.XTick = [0:0.1:max_x];
    ax.YTick = [0 0.2 0.4 0.6 0.8 1.0];
    names = cell(length(timesteps),1);
    for j=1:length(timesteps)
        names{2*j - 1} = [num2str(timesteps(j)),'s'];
        names{2*j} = [num2str(timesteps(j)),'s fitted'];
    end
%     hLeg = legend([H(1:length(timesteps)*2)],names{1:length(timesteps)*2},...
%     'Box','off','location','northeast','FontName','Times','FontSize',8);
%     legend('boxoff')

    for j=1:2*length(timesteps)
        id = j;
        leg(j)={sprintf('%.1f Oe',59.1)};
        legpl(j)=plot(5,2,[char(symbs1(j)),'-'],'LineWidth',1,...
            'MarkerSize',7,'MarkerEdgeColor',Cols(id,:),'Color',Cols(id,:));
    end
    axis([0 data_length/exp.zoom 0 1])
    hLeg=legend(legpl,names,'location','northeast','Box','off');
end