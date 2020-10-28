function [  ] = plot_mcv(data,concentration_keys,yname,xname,errname, Cols, symbs1, plot_errorbars,errcoef,pink)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    names = cell(1,length(concentration_keys) * 2);
    hh=initFigure();
    hold on
    PLOTS = gobjects(1,length(concentration_keys));
    legend_names = cell(1,length(concentration_keys));
    for i=1:numel(concentration_keys)
        raw_indexes = data.(concentration_keys{i}).experimental;
        for j = 1:2
            marker = symbs1{i};
            name_index = i*2-1 + j-1;
            %color = Cols(name_index,:);
            if j - 1 == 0
                stage = 'estimated';
                indexes = find(raw_indexes == 0);
                color = Cols(name_index,:);
                fcolor = [1,1,1];
                if plot_errorbars==true
                    err_x = 0 * data.(concentration_keys{i}).(errname)(indexes);
                end
            else
                stage = 'experimental';
                if pink == true
                    indexes = find(raw_indexes >= 1);
                else
                    indexes = find(raw_indexes == 1);
                end
                color = Cols(name_index,:);
                fcolor = color;
                if plot_errorbars==true
                    err_x = data.(concentration_keys{i}).(errname)(indexes);
                end
            end
            names{name_index} = [concentration_keys{i}]; %pielikt ,' ',stage , ja grib, lai to uzrâda
            x = data.(concentration_keys{i}).(xname)(indexes);
            y = data.(concentration_keys{i}).(yname)(indexes);
            
            if strcmp(stage,'experimental')
                legend_names(i) = names(name_index);
                PLOTS(i) = scatter(x,y,400,marker,...
                    'MarkerEdgeColor',color,...
                    'MarkerFaceColor',fcolor,...
                    'LineWidth',1.5);
            else
                scatter(x,y,250,marker,...
                    'MarkerEdgeColor',color,...
                    'MarkerFaceColor',fcolor,...
                    'LineWidth',5);
            end

            if plot_errorbars == true
                bar = errorbar(x,y, err_x*errcoef );
                bar.LineStyle = 'none';
                bar.Color = color;
            end
        end
    end
    [l, hobj, hout, mout] =legend(PLOTS, legend_names,'FontSize',22,'Orientation','horizontal'); %,'Orientation','horizontal'
    M = findobj(hobj,'type','patch');
    set(M,'MarkerSize',19);
    xlabel(xname);
    ylabel(yname);
    title([yname,' vs ',xname]);
    hold off
end

