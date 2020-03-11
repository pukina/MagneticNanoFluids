function [ ] = trueplotErf(exp, timesteps)
%
%   plot erf and delta
    lineformat = [{'-g'},{'--b'},{':r'},{'-.k'}]; % line parameters
    widths = [1,1.5,2,1.5]; % line widths
    H = gobjects(1,4);
    max_x = 0;
    for j=1:length(timesteps)
        frame = exp.delta(:,1) - exp.delta(1,1);
        frame = length(frame) - length(frame(frame > timesteps(j)*1000)); % no +1 needed
        display(frame);
        cs=exp.cs;
        x = exp.x;
        %subplot(1,2,1)
        title([exp.concentration,' ',num2str(exp.amperi),'A/',num2str(exp.lauksmT),'mT']);
        cs(cs<0)=0; %filter <0 values concentration values
        cs(cs>1)=1; %filter >1 values concentration values
        id = (j-1)*2 + 1;
        frt = lineformat(id);        
        %H(id) = plot((1:length(cs(:,1)))/exp.zoom,cs(:,frame),frt{:},'LineWidth',widths(id));
        H(id) = scatter((1:length(cs(:,1)))/exp.zoom,cs(:,frame));
        
        hold on
        id = j*2;
        frt = lineformat(id);
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
        s = strcat('2\delta_{', num2str(timesteps(j),'%0.0f'),'s}');
        text(Xc/exp.zoom,l*j,s,...
        'VerticalAlignment','bottom','HorizontalAlignment','center','FontName','Times','FontSize',14);
        mm = (1:length(cs(:,1)))/exp.zoom;
        num = (1:length(cs(:,1))) - Xc;
        erffit = (erf(num/Dc)+1) /2;
        H(id) = plot(mm, erffit, frt{:},'LineWidth',widths(id));
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
    xlabel('{\it mm}','FontName','Times','FontSize',16);
    ylabel('{\it Concentration}','FontName','Times','FontSize',14);

    ax = gca;
    ax.FontSize = 12;
    ax.XTick = [0:0.1:max_x];
    ax.YTick = [0 0.2 0.4 0.6 0.8 1.0];
    names = cell(4,1);
    for j=1:length(timesteps)
        names{2*j - 1} = [num2str(timesteps(j)),'s'];
        names{2*j} = [num2str(timesteps(j)),'s fitted'];
    end
    legend([H(1:length(timesteps)*2)],names{1:length(timesteps)*2},...
    'location','northeast','FontName','Times','FontSize',8);


end