%% Plot for each concentration delta vs time for each magnetic field
normalize = false;
straightenTales = false;
properfit = false;
showadjusted =false;

concentrations = fieldnames(MMML_dataset);
hh=initFigure();
%hh2 = initFigure();
i = 1;
while i <= length(concentrations);
%for i=1:numel(concentrations)
    Concentration = MMML_dataset.(concentrations{i});
    experiments = fieldnames(Concentration);
    
    j = 1;
    while j <= length(experiments)
        if j < 1
            i = max(1, i - 1);
            Concentration = MMML_dataset.(concentrations{i});
            experiments = fieldnames(Concentration);
            j = length(experiments);
        end
            
    %for j=1:length(experiments)
        exp = Concentration.(experiments{j});
        orgexp = exp;
        exp.amperi = 999.0; 
        
        if normalize
        % normalize concentration values
            exp = normalizeData( exp );
        end
        
        if straightenTales
            exp = normalizeTale( exp );
        end
        
        if properfit
            exp = normalizeErffit( exp );
        end
        
        adjustedExp = struct();
        if showadjusted
            adjustedExp.exp = exp;
        end
        adjustedExp.exporg = orgexp;
        p1 = subplot(2,3,[1 4]);
        hold on
        plotDeltaVsTime(adjustedExp);
        title([(concentrations{i}),'/', experiments{j}]);
        hold off
        prompt = ['SPACE to get to next expexriment\n'...
                  'ENTER to chose 2 timepoints for displaying erf\n'...
                  'ESCAPE to stop exuction\n'];
        fprintf(prompt); 
        while true
            if waitforbuttonpress
                value = double(get(gcf,'CurrentCharacter'));
                % if space or right arrow key was pressed then do nothing
                if value == 32 || value == 29
                    fprintf('NEXT\n');
                    j = j+1;
                    break
                % if enter key then get values for plotting
                elseif value == 13
                    %subplot(2,3,[1 4])
                    subplot(p1);
                    fprintf('Click on figure to select two sample points to compare\n');
                    
                    [x1,~] = ginput(1);
                    [ frame1, x1, y1 ] = acquireTimeFrame(exp, x1);
                    try
                        delete(h1);
                    end
                    h1 = line([x1 x1], [0 (y1/exp.zoom)], 'Color',[0 0 0]); % main line
                    
                    [x2,~] = ginput(1);
                    [ frame2, x2,y2 ] = acquireTimeFrame(exp, x2);
                    try
                        delete(h2);
                    end
                    h2 = line([x2 x2], [0 (y2/exp.zoom)], 'Color',[0 0 0]); % main line
                    
                    
                    p2 = subplot(2,3,[2 5]);
                    cla(p2);
                    
                    if x2 < x1
                        [frame2, frame1] = deal(frame1, frame2);
                        [h2, h1] = deal(h1,h2);
                        [x2, x1] = deal(x1,x2);
                    end
                    
                    plotErf(exp, [x1 x2])
                    

                    
                    p3 = subplot(2,3,3);
                    cla(p3);
                    plotBoundingbox(exp, frame1);
                    title(num2str(frame1));
                    
                    p4 = subplot(2,3,6);
                    cla(p4);
                    plotBoundingbox(exp, frame2);
                    title(num2str(frame2));
                    
                elseif value == 27
                    return
                % left key;
                elseif value == 28
                    j = j -1;
                    break
                % next concentration
                elseif value == 30
                    i = min(i+1, length(concentrations));
                    Concentration = MMML_dataset.(concentrations{i});
                    experiments = fieldnames(Concentration);
                    j = 1;
                    break
                elseif value == 31
                    i = max(i-1, 1);
                    Concentration = MMML_dataset.(concentrations{i});
                    experiments = fieldnames(Concentration);
                    j = 1;
                    break
                else
                    fprintf('Wrong key pressed\n');
                end
            else
                %clickedAx = gca;
                try
                    if ismember(gca,[p3, p4])
                        [x,y] = ginput(1);
                        subplot(p3);
                        try
                            delete([r1, t1, r2, t2, h3]);
                        end
                        [r1, t1] = acquirePixelValues(exp,frame1,round(x),round(y));
                        subplot(p4);
                        [r2, t2] = acquirePixelValues(exp,frame2,round(x),round(y));

                        % plot line one erf
                        subplot(p2)
                        x = ( exp.bbox(4) -round(y) ) / exp.zoom;
                        h3 = line([x x], [0 1], 'Color',[1 0 0]); % main line
                    end
                end
            end        
        end
        clf(hh,'reset')
    end
    i = i+1;
end
