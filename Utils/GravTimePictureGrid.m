function [ name ] = GravTimePictureGrid( MMML_dataset,used,concentrations_to_plot, t, izmers, RAM_range)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here    
%   Plot picture grid with same scale
    ragString = [{'Ra_g='}, {''},{''}];
    ramString = [{'Ra_m='}, {''},{''},{''}];
    %HARDCODED Ram intervals

    %Calculate fraction of each subimage
    n = length(concentrations_to_plot); % images per x axis
    v = length(t); % columns
    
    dxs = 0.05; % sakuma atstarpe x asij no 0 punkta
    dys = 0.05; % sakuma atstarpe y asij no 0 punkta
    dxx = 0.01; % atstarpe starp secigiem atteliem
    dyy = 0.05;
    dx=(1 - dxs - (v)*dxx)/v; % aprekina garuma proporciju vienam attelam
    dy=(1 - dys - (n)*dyy)/n;
    
    dati = zeros(1, length(concentrations_to_plot));
    order = dati;
    concentrations = fieldnames(MMML_dataset);
    concentrations = concentrations(concentrations_to_plot);
    for i=1:numel(concentrations)
        order(i)= AcquireConcentrationValue(concentrations(i));
    end
    [values, order] = sort(order,'ascend');
       
       
       
    % for each concentration
    for i=1:numel(concentrations)
        Concentration = MMML_dataset.(concentrations{order(i)});
        concentration_order = used.(concentrations{order(i)});
        bbox_konfiguracija = izmers.(concentrations{order(i)});
        fprintf('%s\n',concentrations{order(i)})
        for j=1:length(concentration_order)
            exp_string = strcat('f',num2str(concentration_order(j)));
            exp = Concentration.(exp_string);
            % ja grib hardcoded izmçru piemçram 1x1mm tad noòemt komentâru zemâk!
            % Size is in mm
            
            max_box = [bbox_konfiguracija(1) bbox_konfiguracija(1) -1];
            c = values(i);
            RAM = (exp.lauksmT*10*c*0.016)^2 * 0.013^2 / (12*0.01*5.7*10^(-7));
            fprintf('%f_Current concentration sample: %s_%s with c = %.2f and Ram = %f\n',max_box(1), exp.concentration, exp.subpath, c,RAM)
            % each experiment
            path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
            %%% Sakt experimenta apstradi deltam un koncentracijam
            % Prieksapstrade
            [names, ind, xmid, ymid,placex, placey, background , bws] = readBBoxProperties(exp ,path, t, [bbox_konfiguracija(2), bbox_konfiguracija(3)],max_box);
            m = 1;
            for n=1:length(t)
                % ja neeksistç tâds indekss tad nezîmç
                if isnan(ind(n))
                    continue
                end

                im = readImg(path, names, ind(n), xmid, placex, ymid, placey, background, bws);

                xcoordinate = dxs+dxx*(n-1) + dx*(n-1);
                ycoordinate = dys+dyy*(i-1) + dy*(i-1);
                h=axes('Position',[xcoordinate, ycoordinate, dx, dy]); % vieta kur attçlu novietot
                imshow(im,'Border','tight'); % uzzimç attçlu
                
                if i==1
                    hc=axes('Position',[0 0 1 1],'Visible','off');
                    text(xcoordinate + 0.5*(dxx+dx), 0.05,[sprintf('%g ',t(n)/1000),'s'],...
                    'VerticalAlignment','top','HorizontalAlignment','center','FontName','Times','FontSize',10,...
                    'Rotation',0);
                end
                drawnow
            end
        end
    % Concentracijas Rag
    Rag = getRag(values(i));
    hc=axes('Position',[0 0 1 1],'Visible','off');
    text(0.01, dys + (i-0.7)*dy + dyy*(i-0.7),[sprintf('%s%g ',char(ragString(i)),Rag)],...
    'VerticalAlignment','top','HorizontalAlignment','center','FontName','Times','FontSize',10,...
    'Rotation',90);
    end
    
    name = sprintf('Ram_%g-%g_%.1fx%.1fmm_v1',RAM_range(1),RAM_range(2), bbox_konfiguracija(1), bbox_konfiguracija(1));
end
