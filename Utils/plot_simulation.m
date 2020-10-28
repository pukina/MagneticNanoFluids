function [  ] = plot_simulation(data,concentration_keys,yname,xname,errname, Cols, symbs1, plot_errorbars,errcoef)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    names = cell(1,length(concentration_keys) * 3);
    hh=initFigure();
    hold on
    PLOTS = gobjects(1,2 * length(concentration_keys));
    legend_names = cell(1,2 * length(concentration_keys));
    for i=1:numel(concentration_keys)
        raw_indexes = data.(concentration_keys{i}).type_id;
        skip_indexes = data.(concentration_keys{i}).to_exclude;
        for j = 1:3
            marker = symbs1{i};
            name_index = i*3-1 + j-1;
            %color = Cols(name_index,:);
            if j == 1
                stage = 'estimated';
                indexes = find(raw_indexes == 0 & skip_indexes ~= 1);
                color = Cols(i,:);
                fcolor = [1,1,1];
                if plot_errorbars==true
                    err_x = 0 * data.(concentration_keys{i}).(errname)(indexes);
                end
                names{name_index} = stage;
            elseif j == 2
                stage = 'experimental';
                indexes = find(raw_indexes == 1 & skip_indexes ~= 1);
                color = Cols(i,:);
                fcolor = color;
                if plot_errorbars==true
                    err_x = data.(concentration_keys{i}).(errname)(indexes);
                end
                names{name_index} = [concentration_keys{i}]; %pielikt ,' experimental',stage , ja grib, lai to uzrâda
            else
                stage = 'simulation';
                indexes = find(raw_indexes == 2 & skip_indexes ~= 1);
                color = Cols(i,:);
                fcolor = color;
                if plot_errorbars==true
                    err_x = 0 * data.(concentration_keys{i}).(errname)(indexes);
                end
                names{name_index} = 'Rag = '; %pielikt ,' ',stage , ja grib, lai to uzrâda
            end
            %names{name_index} = [concentration_keys{i}]; %pielikt ,' ',stage , ja grib, lai to uzrâda
            x = data.(concentration_keys{i}).(xname)(indexes);
            y = data.(concentration_keys{i}).(yname)(indexes);
            
            if strcmp(stage,'experimental')
                legend_names(i*2-1) = names(name_index);
                PLOTS(i*2-1) = scatter(x,y,400,marker,...
                    'MarkerEdgeColor',color,...
                    'MarkerFaceColor',fcolor,...
                    'LineWidth',1.5);
            elseif strcmp(stage,'estimated')
                scatter(x,y,200,marker,...
                    'MarkerEdgeColor',color,...
                    'MarkerFaceColor',fcolor,...
                    'LineWidth',5);
            elseif strcmp(stage,'simulation')
                legend_names(i*2) = names(name_index);
                xstart = min(x);
                xend = max(x);
                step = (xend - xstart) / 100; % cik iedalas atzimet
                xq2 = xstart:step:xend;
                s = spline(x,y,xq2);
                plot(x,y,'o', 'Color', color) % REMOVE this to not show REAL simulation data points
                PLOTS(i*2) = plot(xq2,s,'-','Color', color); % spline points
            end

            if plot_errorbars == true && all(err_x)
                bar = errorbar(x,y, err_x*errcoef );
                bar.LineStyle = 'none';
                bar.Color = color;
            end
        end
    end
    [l, hobj, hout, mout] =legend(PLOTS, legend_names,'FontSize',20); %,'Orientation','horizontal'
    M = findobj(hobj,'type','patch');
    set(M,'MarkerSize',15);
    xlabel(xname);
    ylabel(yname);
    title([yname,' vs ',xname]);
    hold off
end

