%% plot images

% define max subimage height and width
h = 50;
w = 30;
% define distance between images
dxs = 0.04;
dys = 0.04;
dxx=0.005;
dyy=0.005;
dx = 0;
dy = 0;
% define required timestamps
t = [1 5 10 20 30 40 60 90 150]*1000;

fields = fieldnames(MMML_dataset);
% for each concentration
for i=1:numel(fields)
    hh=figure;
    set(hh, 'Units', 'centimeters')
    set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
    set(hh, 'Position', [0 10 13.5 7])
    fsize=10;
    msize=7;
    fname='Times';
    Sample = MMML_dataset.(fields{i});
    Cfields = fieldnames(Sample);
    % create placeholder matrix
    %imp = zeros(length(t)*(h+dy)+dy, length(Cfields)*(w+dx)+dx);
    
    %PLOTS = gobjects(1,length(Cfields));
    % acquire order of experiments
    Names = cell(1,length(Cfields));
    order = zeros(1,length(Cfields));
    for j=1:length(Cfields)
        exp = MMML_dataset.(fields{i}).(Cfields{j});
        order(j)=exp.amperi;
        Names{j}=strcat(num2str(exp.amperi,'%.2f'),'A\n',num2str(exp.lauksmT,'%.2f'),'mT');
    end
    %point
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
        exp = MMML_dataset.(fields{i}).(Cfields{order(j)});
        path = strcat('E:\Dati\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
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
            %im2=imrotate(im,3.5);
            im = im(frame(3):frame(4),frame(1):frame(2)); %crop image (useful area)
            im = mat2gray(im,[bws(1),bws(2)]);
            %im = mat2gray(im,[0,257]);
            im = imresize(im,0.25);
            %im(im>1) =1;
            %im(im<0) =0;
            %xstart = length(imp(:,1))-(1 + (m-1)*h + m*dy);
            %xend = length(imp(:,1)) - (m*h+m*dy);
            %ystart= 1 + (order(j)-1)*w + order(j)*dx;
            %yend=order(j)*w+order(j)*dx;
            %imp(xend:xstart,ystart:yend)=im;
            %index = (j-1)*length(t)+(m-1) + 1;
            %subplot(length(t),25,index),imshow(im);
            
            h=axes('Position',[dxs+dxx*(j-1) + dx*(j-1), dys+dyy*(m-1) + dy*(m-1), dx, dy]);
            %break
            imshow(im,'Border','tight');
            
            %break
        end
        %break
    end
    %[~, order] = sort(order,'ascend');
    %set(gca,'Children',PLOTS(order));
    %legend(PLOTS(order),names(order));
    %title((fields{i}));
    %hh=figure;
    %set(hh,'Units','centimeters');
    %set(hh,'PaperPositionMode','auto');
    %set(hh,'Position',[10 5 18 8]);

    %imshow(imp,'Border','tight');
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
end