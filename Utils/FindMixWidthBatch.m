% import experiment database of calculated values if these exist
load('MMML_dataset.mat')
%%
% load experiment metadata of specific concentration from csvfile into
% database. Give additional path of experiment folder and set calculation
% flag to False.
%MMML_dataset.D107 =  acquiremeta( 'D107.csv', 'D107', '20190106-MCV-exp');
%MMML_dataset.D107_05 =  acquiremeta( '0.5D107.csv', '0.5D107', '20190106-MCV-exp');
%MMML_dataset.D107_067 =  acquiremeta( '0.67D107.csv', '0.67D107', '20190115-MCV-exp');
%MMML_dataset.D107_033 =  acquiremeta( '0.33D107.csv', '0.33D107', '20190116-MCV-exp');
%MMML_dataset.D107_025 =  acquiremeta( '0.25D107.csv', '0.25D107', '20190116-MCV-exp');
%%
%save('MMML_dataset.mat','MMML_dataset');
%%
%#3
% calculate concentration and delta values for imported experiments and 
% store in dataset
skip = false; % ja vajag izpildit tad "false", preteja gad "true"
if skip == false
    concentrations = fieldnames(MMML_dataset); %uzdod mainigo fields=koncentracijas
    for i=1:numel(concentrations) %no 1 lidz 5- mmml esosas konc.
        % take first sample
        Concentration = MMML_dataset.(concentrations{i}); %konkreta koncentracijas izvele
        fprintf('Current concentration sample: %s\n',concentrations{i}); % Print current conectration sample
        Cfields = fieldnames(Concentration); %paòem jau no konc eksperimentus pie konkr laukiem
        for j=1:numel(Cfields)
            exp = Concentration.(Cfields{j}); %konkretajaa konc panjem konkr lauku
            fprintf('Current experiment: %s\n',Cfields{j}); % Print current experiment
            if exp.calculated
                fprintf('Current experiment has been calculated already\n'); % Print current experiment
                continue
            else
                fprintf('Current experiment not calculated\n'); % Print current experiment
            end
            path = strcat('E:\Darbs\MMML\',exp.mainpath,'\',exp.concentration,'\',exp.subpath); % Create experiment path
            %%% Sakt experimenta apstradi deltam un koncentracijam
            % Prieksapstrade
            names_all=dir(path); %atgriez visus failus, kas ir tajaa direktoorija; sajaa gad cik daudz attelu ir zem viena konkr exp, tik ari atgriez-- iegust sarakstu ar vinjiem
            Fstart = exp.frames(1); % Experiment start frame
            Fend = exp.frames(2); % Experiment end frame
            names=names_all(Fstart:Fend); % no kura lidz kuram kadram, names- visi tie faili, kuri jaanalize (no kura lidz kuram att.)
            frame=[exp.bbox(1) exp.bbox(2) exp.bbox(3) exp.bbox(4)]; % [xmin xmax ymin ymax] attela kadrejumam
            bws=[exp.bws(1) exp.bws(2)]; % izveleties katra skidruma saturacijas vertibu krasai [min max]
            delta=zeros(length(names),2); %sagatavot deltu matricu
            x = zeros(length(names),2); %prieks xmin max saglabasanas, ja nevajag erf- so var nonemt
            cs=zeros(frame(4)-frame(3)+1,length(names)); % koncentraciju sagalabasana// matrica katrai pikselu rindai

            for m=1:length(names)
                im=imread(fullfile(path,names(m).name));%read imane
                %im2=imrotate(im,3.5);
                im3=im(frame(3):frame(4),frame(1):frame(2)); %crop image (useful area)
                cim=ConcField(double(im3),bws,1); %convert from Intensity to Concentration plot
                c=mean(cim,2); %find average concentration
                cs(:,m)=c; %save average concentration
                [~,x0]=min((c-(erf(-1)+1)/2).^2); %find -delta point
                [~,x1]=min((c-(erf(+1)+1)/2).^2); %find +delta point
                x(m,:)=[x0, x1];
                delta(m,2)=(x1-x0)/2; %calculate delta
                delta(m,1)=str2double(names(m).name(1:7)); %read time from the image name
                if mod(m,500)==0;
                    %break
                    display(sprintf('%d of %d',m,length(names))); %print calculation progress
                end
            end
            exp.delta = delta; % save all required values
            exp.cs = cs;
            exp.x = x;
            fprintf('Setting experiment to calculated\n');
            exp.calculated = 1; % if calculated then avoid redundant computation
            MMML_dataset.(concentrations{i}).(Cfields{j})=exp;
            %save('MMML_dataset.mat','MMML_dataset'); % save dataset so progress is not lost

        end
        %save('MMML_dataset.mat','MMML_dataset'); % save dataset so progress is not lost
    end
    save('MMML_dataset.mat','MMML_dataset'); % save dataset so progress is not lost
else
    fprintf('Calculation of concentrations and deltas SKIPPED\n');
end
%%
%4
% Check how many experiments are done
concentrations = fieldnames(MMML_dataset);
% Calculate fraction of processed samples
Cfin = 0;
Ctot = length(concentrations);
Cres = zeros(3, Ctot);
for i=1:numel(concentrations)
    % take first sample
    Concentration = MMML_dataset.(concentrations{i});
    % Calculate fraction of processed experiments for each connentration
    % sample
    Sfin = 0.0;
    Stot = length(fieldnames(MMML_dataset.(concentrations{i})));
    %fprintf('Current concentration sample: %s\n',fields{i}); % Print current conectration sample
    Cfields = fieldnames(Concentration);
    for j=1:numel(Cfields)
        exp = Concentration.(Cfields{j});
        if exp.calculated
            Sfin = Sfin + 1;
        end
    Cres(:,i) = [100*Sfin / Stot, Sfin, Stot];

   end
end
fprintf('\nSamples processed:\n');
for i=1:length(Cres(1,:))
    fprintf('Concetration sample %i is %.1f%% processed (%i of %i)\n',i,Cres(1,i),Cres(2,i),Cres(3,i)); % Print current conectration sample
end



%% Plot for each concentration delta vs time for each magnetic field
%5
skip = false;
if skip == false
    concentrations = fieldnames(MMML_dataset);
    for i=1:numel(concentrations)
        hh=initFigure();
        hold on
        Concentration = MMML_dataset.(concentrations{i});
        plotDeltaVsTime(Concentration);
        title((concentrations{i}));
        hold off
    end
else
    fprintf('Plotting of concentration delta vs time SKIPPED\n');
end

%% plot images unnormalized
%6
skip = true;
if skip == false
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

    concentrations = fieldnames(MMML_dataset);
    % for each concentration
    for i=1:numel(concentrations)
        hh=figure;
        set(hh, 'Units', 'centimeters')
        set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
        set(hh, 'Position', [0 10 13.5 7])
        fsize=10;
        msize=7;
        fname='Times';
        Concentration = MMML_dataset.(concentrations{i});
        Cfields = fieldnames(Concentration);
        % create placeholder matrix
        %imp = zeros(length(t)*(h+dy)+dy, length(Cfields)*(w+dx)+dx);

        %PLOTS = gobjects(1,length(Cfields));
        % acquire order of experiments
        Names = cell(1,length(Cfields));
        order = zeros(1,length(Cfields));
        for j=1:length(Cfields)
            exp = MMML_dataset.(concentrations{i}).(Cfields{j});
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
            exp = MMML_dataset.(concentrations{i}).(Cfields{order(j)});
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
    %hgexport(hh,'1_2-all.eps');
else
    fprintf('Plotting of experiment example images SKIPPED\n');
end
%% acquire start time for plotting linear graph
%7
skip = true;
if skip == false
    concentrations = fieldnames(MMML_dataset);
    for i=1:numel(concentrations)
        hh=figure;
        set(hh, 'Units', 'centimeters')
        set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
        set(hh, 'Position', [0 10 13.5 7])
        fsize=10;
        msize=7;
        fname='Times';
        %hold on

        Concentration = MMML_dataset.(concentrations{i});
        Cfields = fieldnames(MMML_dataset.(concentrations{i}));
        names = cell(1,length(Cfields));
        PLOTS = gobjects(1,length(Cfields));
        order = zeros(1,length(Cfields));
        for j=1:length(Cfields)
            exp = MMML_dataset.(concentrations{i}).(Cfields{j});
            if isfield(exp,'coef_lim')
                lim = exp.coef_lim(1);
                lim_max = exp.coef_lim(2);
                b = exp.coef;
            else
                lim = 0; % inicialize taisnes laiku
                lim_max = 1000*1000; % inicialize max taisnes laiku 1000s *1000 ms/s
            end
            accepted = false;
            counter = 0; % skaita
            a=exp.delta; % get deltas
            a(:,1) = a(:,1)- a(1,1); % normalize time values to first frame
            a(:,2) = a(:,2)/exp.zoom; %parveido no px uz mm
            while accepted == false
                ind_max = a(:,1) < (lim_max); % iegust indexu vertibam kuras parsniedz maksimalo laiku
                % iegust datu dalu liknes aprekinasanai
                a2 = a(:,2);
                a2 = a2(ind_max); % atstâj tikai vertibas lidz max laikam
                a2 = [a(ind_max) a2];
                
                % taisnes aprekins
                ind = a2(:,1)>lim; % indices of values greater than start
                x=a2(ind)/1e3; % take only points which are beyond start time
                y=a2(:,2); % take correspoinding delta values
                y=1/4*y(ind).^2; % aprekina indexetajam vertibam 4 delta ^2
                X = [ones(length(x),1) x];
                
                
                b = X\y; % aprekina koeficientus
                fprintf('Taisnes vienadojums ir:\n y=%i * x + %i\n', b(2),b(1)); %parada taisnes vienadojums linearajai regresijai
                x0 = [1.0, 0.0]; % pievieno sakuma vertibu
                xend = [1, a(end,1)/1000];
                X = [ones(length(a2(:,1)),1) a2(:,1)/1e3];
                X = [x0; X; xend];
                yCalc3 = X*b; % aprekina taisni
                
                % Uzzimet abus grafikus - delta^2 vs t un taisnes vienadojumu
                plot(a(:,1)/1e3,1/4*a(:,2).^2,'-'); % originalais 1/4*delta^2 grafiks
                hold on
                plot([0 ; a2(:,1) ; a(end,1)]/1e3,yCalc3); % uzzime taisni
                hold off
                xlabel('t, s');
                ylabel('\delta^2/4, mm^2');
                title([exp.concentration, ',', num2str(exp.amperi), 'A/' , num2str(exp.lauksmT),'mT']);
                order(j)=exp.amperi;
                names{j}=strcat(num2str(exp.amperi,'%.2f'),'A / ',num2str(exp.lauksmT,'%.2f'),'mT');
                prompt = ('Is this fit acceptable? Write "yes" or "y" if good. To adjust press enter. "no" or "n" show orginal.\n');
                prompt = [prompt,'"save" stores current values and exits. PLEASE WAIT FOR SAVING LARGE DATASETS\n'];
                x = input(prompt,'s');
                if strcmp(x, 'yes') || strcmp(x, 'y')
                    accepted = true;
                    exp.coef_lim(1) = lim;
                    exp.coef_lim(2) = lim_max;
                    exp.coef = b;
                    MMML_dataset.(concentrations{i}).(Cfields{j}) =  exp;
                elseif strcmp(x, 'no') || strcmp(x, 'n')
                    if isfield(exp,'coef_lim')
                        lim = exp.coef_lim(1);
                        lim_max = exp.coef_lim(2);
                    else
                        lim = 0; % inicialize taisnes laiku
                        lim_max = 1000*1000; % inicialize max taisnes laiku 1000s *1000 ms/s
                    end
                elseif strcmp(x, 'save')
                    exp.coef_lim(1) = lim;
                    exp.coef_lim(2) = lim_max;
                    exp.coef = b;
                    MMML_dataset.(concentrations{i}).(Cfields{j}) =  exp;
                    save('MMML_dataset.mat','MMML_dataset');
                    return
                else
                    prompt = 'Write start time in seconds [s].\n';
                    lim = 1000 * input(prompt);
                    prompt = 'Write end time in miliseconds [s].\n';
                    lim_max = 1000 * input(prompt);
                end
            end
        %break
        end
        %[~, order] = sort(order,'ascend');
        %set(gca,'Children',PLOTS(order));
        %legend(PLOTS(order),names(order));
        %title((fields{i}));
        %hold off
        %break
    end
    save('MMML_dataset.mat','MMML_dataset');
else
    fprintf('Acquisition of time steps for linear equation SKIPPED\n');
end

%% plot images normalized
% NEW
skip = true;
if skip == false
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

    concentrations = fieldnames(MMML_dataset);
    % for each concentration
    for i=1:numel(concentrations)
        hh=figure;
        set(hh, 'Units', 'centimeters')
        set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
        set(hh, 'Position', [0 10 13.5 7])
        fsize=10;
        msize=7;
        fname='Times';
        Concentration = MMML_dataset.(concentrations{i});
        Cfields = fieldnames(Concentration);
        % acquire order of experiments
        Names = cell(1,length(Cfields));
        order = zeros(1,length(Cfields));
        for j=1:length(Cfields)
            exp = MMML_dataset.(concentrations{i}).(Cfields{j});
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
            exp = MMML_dataset.(concentrations{i}).(Cfields{order(j)});
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
    %hgexport(hh,'1_2-all.eps');
else
    fprintf('Plotting of experiment example images SKIPPED\n');
end