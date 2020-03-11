function [ output_args ] = imagesNormalized( Concentration, t )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
    Cfields = fieldnames(Concentration);
    % acquire order of experiments
    Names = cell(1,length(Cfields));
    order = zeros(1,length(Cfields));
    for j=1:length(Cfields)
        exp = Concentration.(Cfields{j});
        order(j)=exp.amperi;
        Names{j}=strcat(num2str(exp.amperi,'%.2f'),'A\n',num2str(exp.lauksmT,'%.2f'),'mT');
    end
    [~, order] = sort(order,'ascend');
    %Calculate fraction of each subimage
    n = length(order);
    v = length(t);
    dxs = 0.03;
    dys = 0.06;
    dxx = 0.003;
    dyy = 0.005;
    dx=(1 - dxs - (n)*dxx)/n;
    dy=(1 - dys - (v)*dyy)/v;

    % each experiment
    for j=1:length(Cfields)
        exp = Concentration.(Cfields{order(j)});
        path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
        %%% Sakt experimenta apstradi deltam un koncentracijam
        % Prieksapstrade
        names_all=dir(path);
        Fstart = exp.frames(1); % Experiment start frame
        Fend = exp.frames(2); % Experiment end frame
        names = names_all(Fstart:Fend); % izvelies no kura lidz kuram kadram
        % get vector of timestamp for each frame from experiment start time
        times = zeros(1,length(names));
        for m=1:length(names)
            times(m) = str2double(names(m).name(1:7));
        end
        times = times - times(1);
        % find indexes of required images
        ind = zeros(1, length(t));
        for m=1:length(ind)
            id = min(find(times>t(m)));
            if isempty(id);
                id = NaN;
            end
           ind(m) = id;
        end

        frame=[exp.bbox(1) exp.bbox(2) exp.bbox(3) exp.bbox(4)]; % [xmin xmax ymin ymax] attela kadrejumam
        bws=[exp.bws(1) exp.bws(2)]; % izveleties katra skidruma saturacijas vertibu krasai [min max]
        for m=1:length(t)
            if isnan(ind(m))
                continue
            end
            im=imread(fullfile(path,names(ind(m)).name));%read imane
            im = im(frame(3):frame(4),frame(1):frame(2)); %crop image (useful area)
            im = mat2gray(im,[bws(1),bws(2)]);
            im = imresize(im,0.25);
            h=axes('Position',[dxs+dxx*(j-1) + dx*(j-1), dys+dyy*(m-1) + dy*(m-1), dx, dy]);
            imshow(im,'Border','tight');
            drawnow;
        end
    end
    hc=axes('Position',[0 0 1 1],'Visible','off');
    for i=1:length(Cfields)
        text(dxs + (i-0.5)*dx + dxx*(i-0.5),0.01,sprintf(Names{order(i)}),...
        'VerticalAlignment','bottom','HorizontalAlignment','center','FontName','Times','FontSize',10);
    end
    for i=1:length(t)
        text(0.01, dys + (i-0.5)*dy + dyy*(i-0.5),[sprintf('%d ',t(i)/1000),'s'],...
        'VerticalAlignment','top','HorizontalAlignment','center','FontName','Times','FontSize',10,...
        'Rotation',90);
    end
    hold off
    %break


