function [ output_args ] = plotDeltaSquaredVsTime(concentration)
%plotDeltaVsTime plots delta vs time given specific concentration handle
%   Detailed explanation goes here
    experiments = fieldnames(concentration);
    names = cell(1,length(experiments));
    PLOTS = gobjects(1,length(experiments));
    order = zeros(1,length(experiments));
    for j=1:length(experiments)
        exp = concentration.(experiments{j});
        delta=exp.delta;
        %subtract startime from all values so resulting values are from 0
        %to end
        delta(:,1) = delta(:,1)- delta(1,1);
        %adjust deltas to zoom
        delta(:,2) = delta(:,2) / exp.zoom;
        
        PLOTS(j)=plot(delta(:,1)/1e3,1/4*delta(:,2).^2,'-'); %mainits uz 4 delts
        xlabel('t, s');
        ylabel('\delta^2/4, mm^2');
        % will be later used to sort by Amps
        order(j)=exp.amperi;
        % name displayed in legend
        names{j}=strcat(num2str(exp.amperi,'%.2f'),'A / ',num2str(exp.lauksmT,'%.2f'),'mT');
    end
    % get order of experiments sorted by amperage
    [~, order] = sort(order,'ascend');
    % sorts legend by Amp order
    set(gca,'Children',PLOTS(order));
    legend(PLOTS(order),names(order));

end

