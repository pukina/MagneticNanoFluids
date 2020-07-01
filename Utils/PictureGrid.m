function [ name, Koncentracija, signal ] = PictureGrid( Koncentracija,omitted, t, configuration, ConcentrationString, izmers )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here    
%   Plot picture grid with same scale

    % ja grib hardcoded izmçru piemçram 1x1mm tad noòemt komentâru zemâk!
    % Size is in mm
    max_box = [izmers(1) izmers(1) -1];
    
%    fprintf('Current concentration sample: %s\n',koncentracijas{i}); % Print current conectration sample
    eksperimenti = fieldnames(Koncentracija);
    % acquire order of experiments
    Names = cell(1,length(eksperimenti));
    order = zeros(1,length(eksperimenti));
    

    % iziet cauri visiem eksperimentiem un sarindo tos secigi pec amperiem
    % un saglaba secibu mainigajâ 'order'
    for j=1:length(eksperimenti)
        exp = Koncentracija.(eksperimenti{j});
        if j == 1
        % Iegust koncentraciju
            c = AcquireConcentrationValue(ConcentrationString);
            fprintf('Concentration %s is : %g\n',char(ConcentrationString), c);
        end
        if ismember(str2num(exp.subpath), omitted)
            order(j)=NaN;
        else
            order(j)=exp.amperi;
            if strcmp(configuration, 'Oe')
                Names{j}=strcat(num2str(exp.lauksmT*10,'%.1f'),' Oe'); % jalabo ja vajag mainit X ass labels
                config_name = 'field';
            elseif strcmp(configuration, 'Ram')
                RAM = (exp.lauksmT*10*c*0.016)^2 * 0.013^2 / (12*0.01*5.7*10^(-7));
                Names{j}=strcat(num2str(RAM,'%.0f')); % jalabo ja vajag mainit X ass labels
                config_name = 'Ram';
            end
            %{j}=strcat(num2str(exp.amperi,'%.2f'),'A\n',num2str(exp.lauksmT*10,'%.2f'),'Oe'); % jalabo ja vajag mainit X ass labels
        end
    end
    % iegust secibu kâdâ sâkumâ iegûtie eksperimenti ir jaanalizç
    [values, order] = sort(order,'ascend');        
    values = (values(~isnan(values)));
    %Calculate fraction of each subimage
    n = length(values);
    v = length(t);
    dxs = 0.03; % sakuma atstarpe x asij no 0 punkta
    dys = 0.06; % sakuma atstarpe y asij no 0 punkta
    dxx = 0.003; % atstarpe starp secigiem atteliem
    dyy = 0.005;
    dx=(1 - dxs - (n)*dxx)/n; % aprekina garuma proporciju vienam attelam
    dy=(1 - dys - (v)*dyy)/v;

    % each experiment
    for j=1:length(values)
        exp = Koncentracija.(eksperimenti{order(j)});
        path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
        %%% Sakt experimenta apstradi deltam un koncentracijam
        % Prieksapstrade
        %panemts no Guntara
        names_all=dir(path);
        Fstart = exp.frames(1); % Experiment start frame
        Fend = exp.frames(2); % Experiment end frame
        names = names_all(Fstart:Fend); % izvelies no kura lidz kuram kadram
        % get vector of timestamp for each frame from experiment start time
        times = zeros(1,length(names));
        for m=1:length(names)
            times(m) = str2double(names(m).name(1:7)); % parveido nosaukumus uz laikiem
        end
        times = times - times(1); % normalize laiku lai sakas ar 0
        % find indexes of required images
        ind = zeros(1, length(t)); %visu indexu (timestamps) matrica
        for m=1:length(ind)
            id = min(find(times>t(m))); %minimialâ indeksa(laika) vçrtîba, kas ir vistuvâkâ pieprasîtajam- pirmâ vçrt,kas pârsniedz.
            if isempty(id); % ja nav tada laika kadra
                id = NaN;
            end
           ind(m) = id;
        end

        zoom = exp.zoom;
        frame=[exp.bbox(1) exp.bbox(2) exp.bbox(3) exp.bbox(4)]; % [xmin xmax ymin ymax] attela kadrejumam
        x_dim = frame(2) - frame(1); % garums pikseïos
        y_dim = frame(4) - frame(3);
        bws=[exp.bws(1) exp.bws(2)]; % izveleties katra skidruma saturacijas vertibu krasai [min max]
        % katram laika periodam uzzimet kadru
        cur_box = [x_dim / zoom , y_dim / zoom]; %esoða kadra izmçri mm x un y asis

        scale_x = max_box(1) / cur_box(1); % cik reiþu lielâks ir nepiecieðamais kadrs
        scale_y = max_box(2) / cur_box(2);

        background = (bws(1) + (bws(2)-bws(1))/2)/257; % krasa backgroundam attçlu paddingam

        placex = round(scale_x * x_dim); % aprekina nepiecieðamo attelâ izmçru pikseïos
        placey = round(scale_y * y_dim);
        
        
        if isfield(exp,'nobide_imgrid')
            nobide_x =  exp.nobide_imgrid(2);
            nobide_y =  exp.nobide_imgrid(2);
        else
            nobide_x =  izmers(2);
            nobide_y =  izmers(3);
        end
            
        if isfield(exp,'grid_angle')
            adjustment_angle = exp.grid_angle;
        else
            adjustment_angle =0;
        end
        
        while true
            xmid = x_dim /2 + frame(1) +nobide_x; %vidus izmçri anotetajam bounding box pret pilnâ attela sakuma koordinçtu
            % get y coordinate of transition line for 1st image
            cs = exp.cs(:,1);
            ymid = exp.bbox(3) + length(find(cs<0.5)) + nobide_y;
            %ymid = y_dim/2 + frame(3);
            
            
            for m=1:length(t)
                % ja neeksistç tâds indekss tad nezîmç
                if isnan(ind(m))
                    continue
                end

                im=imread(fullfile(path,names(ind(m)).name));%read image


                xstart = max(1, floor(xmid - placex/2)); % sakuma koordinâta x asij. Vienmçr > 1. 
                xend = min(size(im,2), floor(xmid + placex/2)); % beigu koordinâta x asij. Vienmçr mazâka par attçla dimensiju.
                padx = max(0, placex -(xend-xstart)); % cik papildus pikseïi vajadzîgi kopâ. 
                padx_right = min(size(im,2), xend+padx) - xend; % vispirms pikseïu vieno no labâs puses cik var.
                padx_left = padx - padx_right; % atlikuðos no kreisâs puses
                xend = xend+padx_right; % modificçts beigu punkts
                xstart = max(1, xstart-padx_left); %modificçts jaunais sakuma punkts

                %Y koordinâtçm netiek modificçts
                ystart = max(1, floor(ymid - placey/2)); % 
                yend = min(size(im,1), floor(ymid + placey/2)); % 
                
                % pad frame with pixels so angle can be adjusted without
                % problems
                y_end_free = size(im,1) - yend;
                x_end_free = size(im,2) - xend;
                padding_free = min([y_end_free x_end_free, (ystart - 1), (xstart -1)]);
                p = min(padding_free, 400);
                
                im = im(ystart-p:yend+p, xstart-p:xend+p); % no pilna attela paòem izraudzîto kadru
                % rotate and crop image
                im = imrotate(im,adjustment_angle,'bilinear','crop');
                im = im(p+1:end-p, p+1:end-p);
                % izveido attçla template ar nepiecieðamajâm dimensijâm un
                % background krâsâ
                placeholder=ones(max(placey,size(im,1)), max(placex,size(im,2))) * background;
                im = mat2gray(im,[bws(1),bws(2)]); % normalizç kadra pikseïus lai bûtu kontrasts

                %uzlieku offsetus kadra sakuma un beigu punktam
                offsetx = max(0,floor((size(placeholder,2) - size(im,2))/2));
                offsety = max(0,floor((size(placeholder,1) - size(im,1))/2));
                % ievieto kadru placeholderî
                placeholder(1+ offsety:size(im,1)+offsety, 1+ offsetx:size(im,2)+offsetx)=im;
                % mainigo parsaukðana çrtîbai
                im = placeholder;
                %im = imresize(im,0.1); %scalo par koeficientu attelu
                im = imresize(im, [300,300]); % resize attelu uz noteiktam dimensijam, piem 150x150
                

                h=axes('Position',[dxs+dxx*(j-1) + dx*(j-1), dys+dyy*(m-1) + dy*(m-1), dx, dy]); % vieta kur attçlu novietot
                %break
                imshow(im,'Border','tight'); % uzzimç attçlu
                drawnow
                %break
            end
            %break
            prompt = ('Is this angle acceptable? [Default: 0 degrees] Write "y" if good. To adjust enter degrees.\n');
            prompt = [prompt,'To adjust X or Y offset type: "xoff" or "yoff". "end" to save results. \n'];
            if exist('response_1','var')
                if strcmp(response_1, 'yoff')
                    response_1 = 'yoff';
                elseif strcmp(response_1, 'xoff')
                    response_1 = 'xoff';
                else
                    response_1 = input(prompt,'s');
                end
            else
                response_1 = input(prompt,'s');
            end
            
            %x  = 'yes';
            if isfield(exp,'grid_angle') && isfield(exp,'nobide_imgrid')
                break
            elseif strcmp(response_1, 'y') || strcmp(response_1, 'end')
                % SAVE RESULT PLZZZZZ
                Koncentracija.(eksperimenti{order(j)}).grid_angle = adjustment_angle;
                if exist('nobide_imgrid','var')
                    Koncentracija.(eksperimenti{order(j)}).nobide_imgrid = nobide_imgrid;
                end
                if strcmp(response_1, 'end')
                    signal = true;
                    name = 'EARLY_STOPPING';
                    return
                else
                    signal = false;
                end
                break
            elseif strcmp(response_1, 'yoff')
                prompt = ('Currently adjusting Y offset. To save type "y" and adjust other params. To change it enter new offset number.\n');
                prompt = [prompt,'For original press "n". .\n'];
                response_2 = input(prompt,'s');
                if strcmp(response_2, 'y')
                    nobide_imgrid = [nobide_y, nobide_x];
                    response_1 = '';
                elseif strcmp(response_2, 'n')
                    nobide_y = izmers(3);
                    %nobide_imgrid = [nobide_y, nobide_x];
                else
                    nobide_y = str2num(response_2);
                end
            elseif strcmp(response_1, 'xoff')
                prompt = ('Currently adjusting X offset. To save type "y" and adjust other params. To change it enter new offset number.\n');
                prompt = [prompt,'For original press "n". .\n'];
                response_2 = input(prompt,'s');
                if strcmp(response_2, 'y')
                    nobide_imgrid = [nobide_y, nobide_x];
                    response_1 = '';
                elseif strcmp(response_2, 'n')
                    nobide_x = izmers(2);
                    %nobide_imgrid = [nobide_y, izmers(2)];
                else
                    nobide_x = str2num(response_2);
                end
            else
                adjustment_angle =  str2num(response_1);
            end
        end
    end
    % No Guntara: lai uzzimçtu asis
    % Eksperimentu Amperi un teslas X asî
    hc=axes('Position',[0 0 1 1],'Visible','off');
    for k=1:length(values)
        text(dxs + (k-0.5)*dx + dxx*(k-0.5),0.01,sprintf(Names{order(k)}),...
        'VerticalAlignment','bottom','HorizontalAlignment','center','FontName','Times','FontSize',10);
    end
    % Eksperimenta kadra laiks
    for k=1:length(t)
        text(0.01, dys + (k-0.5)*dy + dyy*(k-0.5),[sprintf('%g ',t(k)/1000),'s'],...
        'VerticalAlignment','top','HorizontalAlignment','center','FontName','Times','FontSize',10,...
        'Rotation',90);
    end
    hold off

    res = zeros(1,length(values));
    % subpaths of unique experiments
    for k=1:length(values)
        res(k) = str2num(Koncentracija.(eksperimenti{order(k)}).subpath);
    end
    res=sprintf('%d ', res);
    fprintf('Subpaths of %s displayed experiments in fallowing order: %s\n',exp.concentration, res); % Print current conectration sample
    
    if c == 1
        rag = 4657;
    elseif c == 0.67
        rag = 3031;
    elseif c == 0.5
        rag = 2225;
    elseif c == 0.33
        rag = 1412;
    elseif c == 0.25
        rag = 718;
    end
        
    %name = strcat('Rag_',num2str(rag,'%.0f'),'_',config_name_,'_',)
    name = sprintf('Rag_%.0f_%s_%ix%imm_v1', rag, config_name, izmers(1), izmers(1));
end
