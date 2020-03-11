concentrations = fieldnames(MMML_dataset);
hh =initFigure();

% for i=1:numel(concentrations)
%     Sample = MMML_dataset.(concentrations{i});
%     experiments = fieldnames(Sample);
%     for j=1:length(experiments)
%         exp = Sample.(experiments{j});
%  
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
        exp = MMML_dataset.(concentrations{i}).(experiments{j});
        
        delta =exp.delta;
        delta(:,2) = (delta(:,2) / exp.zoom).^2 / 4;
        delta(:,1) = (delta(:,1) - delta(1,1))/1000;
        
        times = delta(:,1);
        
        delta(:,2) = smooth(delta(:,2),7,'sgolay');
        dydx = gradient(delta(:,2)) ./ gradient(delta(:,1));
        u = mean(dydx(100:end-5));
        dev = std(dydx(100:end-5));
        dydx = (dydx - u) / dev;
        threshold = 3;
        markers = find(dydx(1:end-5)>threshold);
        d = diff(markers);
        d(d~=1)=0;
        measurements = regionprops(logical(d), 'Area', 'PixelIdxList');
        [sortedAreas, sortIndexes] = sort([measurements.Area], 'Descend');
 
        p1 = subplot(1,3,1);
        %plot(delta(:,2))
        %hold on
        s = struct();
        s.org = exp;
        plotDeltaVsTime(s);
        title([(concentrations{i}),'/', experiments{j}]);
        for m=1:length(sortedAreas)
            if sortedAreas(m) > 0 && sortedAreas(m) < 10
                for n=1:length(measurements(sortIndexes(m)).PixelIdxList)
                    index = markers(measurements(sortIndexes(m)).PixelIdxList(n));
                    line([times(index) times(index)],[0, delta(index,2)], 'Color',[.3 .3 .3]);
                end
            end
        end
        hold off
        subplot(1,3,2);
        plot(dydx)
        title('dy/dx');
        hold on
        line([0 length(dydx)],[threshold, threshold], 'Color',[.9 .2 .2]);
        
        subplot(1,3,3);
        plot(gradient(dydx))
        title('d^2y/dx^2');
        
        
%         waitforbuttonpress;
%         clf(hh,'reset')
%     end
% end

        prompt = ['SPACE to get to next expexriment\n'...
                  'ENTER to chose 2 timepoints for displaying erf\n'...
                  'ESCAPE to stop exuction\n'];
        fprintf(prompt); 
        while true
            if waitforbuttonpress
                value = double(get(gcf,'CurrentCharacter'));
                % if space or right arrow key was pressed then next
                if value == 32 || value == 29
                    fprintf('NEXT\n');
                    j = j+1;
                    break
                % if enter key then get values for plotting
                elseif value == 13
                    fprintf('ENTER\n');
                    subplot(p1)
                    hold on
                    [x1,~] = ginput(1);
                    [ frame1, x1, y1 ] = acquireTimeFrame(exp, x1);
                    try
                        delete(h1);
                    end
                    h1 = line([x1 x1], [0 (y1/exp.zoom)^2/4], 'Color',[0 1 0]); % main line
                    
                    [x2,~] = ginput(1);
                    [ frame2, x2,y2 ] = acquireTimeFrame(exp, x2);
                    try
                        delete(h2);
                    end
                    h2 = line([x2 x2], [0 (y2/exp.zoom)^2/4], 'Color',[0 1 0]); % main line
                    
                    try
                        delete(h3);
                    end
                    
                    if x2 < x1
                        [frame2, frame1] = deal(frame1, frame2);
                        [h2, h1] = deal(h1,h2);
                        [x2, x1] = deal(x1,x2);
                        [y2, y1] = deal(y1,y2);
                    end
                    
                    
                    steps = frame2-frame1;
                    step = (x2 - x1) / steps;
                    newX = (x1:step:x2);

                    step = (y2-y1)/steps;
                    newY = ((y1:step:y2)/exp.zoom).^2/4;
                    newY(2:end-1) = newY(2:end-1)' + randn(length(newY)-2,1)/20000;
                    %h3 = plot(newX,newY);
                    %h3 = line([x1 x2], [(y1/exp.zoom)^2/4 (y2/exp.zoom)^2/4], 'Color',[0 1 0]); % main line
                    
                    s = struct();
                    exp = MMML_dataset.(concentrations{i}).(experiments{j});
                    newdelta = exp.delta;
                    newdelta(frame1:frame2,2) = sqrt(newY*4)*exp.zoom;
                    exp.delta = newdelta;
                    s.org = exp;
                    cla(p1);
                    plotDeltaVsTime(s);
                    prompt = 'Press s to SAVE and keep changes\n';
                    fprintf(prompt); 

                    
                    
                    
                % if ESC key then end
                elseif value == 27
                    return
                % left key is go back
                elseif value == 28
                    j = j -1;
                    break
                % next concentration if up arrow
                elseif value == 30
                    i = min(i+1, length(concentrations));
                    Concentration = MMML_dataset.(concentrations{i});
                    experiments = fieldnames(Concentration);
                    j = 1;
                    break
                % previous conectration if down arrow
                elseif value == 31
                    i = max(i-1, 1);
                    Concentration = MMML_dataset.(concentrations{i});
                    experiments = fieldnames(Concentration);
                    j = 1;
                    break
                % save current experiment
                elseif value == 115
                    MMML_dataset.(concentrations{i}).(experiments{j}) = exp;
                    fprintf('SAVED\n');
                else
                    fprintf('Wrong key pressed\n');
                end
            % if mouse click was used    
 
            else
                %clickedAx = gca;
            end        
        end
        clf(hh,'reset')
    end
    i = i+1;
end