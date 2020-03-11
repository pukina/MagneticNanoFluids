%pnames={'0A','0.6A','0.7A','0.8A','0.9A','1A','1.2A','1.3A','1.5A','1.6A','2A'};


%So sadal vajag vienmer runot!

%for j=1:length(pnames)
%path='\\Tfk-lab4\d\LASMA\29032018\1-2skidrums\0-0pl_2-00A';
path='F:\MMML\20190106-MCV-exp\D107\19';
ZOOM = 630; % AIZPILDI zoom limenis px/mm
names_all=dir(path); % !! to see all files with timestamps, open variable names_all
%%
%try new
%path='\\Tfk-lab4\d\LASMA\20072018\1_00_uz1_300A';
%\\Tfk-lab4\d\LASMA\29032018\1-2skidrums\0-0pl_2-00A %- pat labak.
Fstart = 38; % AIZPILDIT sakuma apskatas laikus un tad izveles sakuma failu
Fend = 500; % AIZPILDIT izvelas beigu failu
%path=[path0,char(pnames(j))];
names_all=dir(path); % !! to see all files with timestamps, open variable names_all
%names=names(3:length(names)-2);
names=names_all(Fstart:Fend); % izvelies no kura lidz kuram failam
%frame=[196 666 257 737];
frame=[426 1084 200 958]; % AIZPILDIT [xmin xmax ymin ymax] attelam

bws=[87,212]; % AIZPILDIT izveleties katra skidruma saturacijas vertibu krasai
delta=zeros(length(names),2);
x = zeros(length(names),2); %prieks xminmax saglabasanas, ja nevajag erf- so var nonemt
cs=zeros(frame(4)-frame(3)+1,length(names));
for i=1:length(names)
    im=imread(fullfile(path,names(i).name));%read imane
    %im2=imrotate(im,3.5);
    im3=im(frame(3):frame(4),frame(1):frame(2)); %crop image (useful area)
    cim=ConcField(double(im3),bws,1); %convert from Intensity to Concentration plot
    c=mean(cim,2); %find average concentration
    cs(:,i)=c; %save average concentration
    [~,x0]=min((c-(erf(-1)+1)/2).^2); %find -delta point
    [~,x1]=min((c-(erf(+1)+1)/2).^2); %find +delta point
    x(i,:)=[x0, x1];
    delta(i,2)=(x1-x0)/2; %calculate delta
    delta(i,1)=str2double(names(i).name(1:7)); %read time from the image name
    if mod(i,500)==0;
       display(sprintf('%d of %d',i,length(names))); %print calculation progress
    end
end
%%
csvwrite(['D107_19','.dat'],delta) %save delta values %bija 0_1-2_sk-0.95A
csvwrite(['D107_19_cs','.dat'],cs) %save concentration values
%csvwrite(['1mkl_min_',char(pnames(j)),'.dat'],delta);
%end

%%
pnames={'1_2A'};
for j=1:length(pnames)
    lim = 12000; % AIZPILDI taisnei sakuma laiks miliskendes
    lim_max = 100000; % AIZPILDI visiem datiem beigu laiks milisekundes
    %a=csvread(['0_1-2_sk-',char(pnames(j)),'.dat']);
    a=csvread(['D107_19','.dat']);
    ind_max = a(:,1) < (lim_max); % iegust indexu maximalajam laikam
    a2 = a(:,2)/ZOOM; %parveido no px uz mm
    a2 = a2(ind_max);
    a = [a(ind_max) a2];
    plot(a(:,1)/1e3,4*a(:,2).^2,'-'); %mainits uz 4 delts
    %plot(delta(:,1),delta(:,2).^2,'-');
    hold on
    ind = a(:,1)>lim; % indices of values greater than start
    x=a(ind)/1e3; % take only points which are beyond start time
    y=a(:,2); % take correspoinding delta values
    y=4*y(ind).^2; % aprekina indexetajam vertibam 4 delta ^2
    X = [ones(length(x),1) x];
    b = X\y; % aprekina koeficientues
    fprintf('Taisnes vienadojums ir:\n y=%i * x + %i\n', b(2),b(1)); %parada taisnes vienadojums linearajai regresijai
    x0 = [1.0, 0.0]; % pievieno sakuma vertibu
    X = [ones(length(a(:,1)),1) a(:,1)/1e3];
    X = [x0; X];
    yCalc3 = X*b; % aprekina taisni
    plot([0 ; a(:,1)]/1e3,yCalc3); % uzzime taisni
    %hold on
    xlabel('t, s');
    ylabel('4\delta^2, mm^2');
end

legend('1.2A D107');
%%
%plot concentration
%csvwrite(['0_0mkl-min_1_8A_3_2pal_1x','.dat'],cs)
pnames=[22,40,150,300]; % name files
for j=1:length(pnames)
    %a=csvread(['0_1-2_sk-',char(pnames(j)),'.dat']);
    a=csvread(['D107_1.036A_0.8pal_cs','.dat']);
    a(a<0)=0; %filter <0 values concentration values
    a(a>1)=1; %filter >1 values concentration values
    plot((1:length(a(:,1)))/ZOOM,1-a(:,pnames(j)),'-'); %mainits uz 4 delta
    %plot(delta(:,1),delta(:,2).^2,'-');
    hold on
    xlabel('mm');
    ylabel('C, %');
end
legend('3 - 0014178','40 - 0016617','150 - 0023872','300 - 0033776');
%%
%erf plot
csvwrite(['D107_19','.dat'],cs)
pnames=[40];
for j=1:length(pnames)
    hold on
    %a=csvread(['0_1-2_sk-',char(pnames(j)),'.dat']);
    a=csvread(['D107_19','.dat']);
    a(a<0)=0; %filter <0 values concentration values
    a(a>1)=1; %filter >1 values concentration values
    plot((1:length(a(:,1)))/1010,1-a(:,pnames(j)),'Color',[1 0 0]);
    dmin=x(pnames(j),1);
    line([dmin dmin]/1010, [0 1], 'Color',[.8 .8 .8]);
    dmax=x(pnames(j),2);
    line([dmax dmax]/1010, [0 1], 'Color',[.8 .8 .8]);
    Dc = (dmax - dmin)/2; % delta
    Xc = dmin + Dc; % Xvidus
    plot((1:length(a(:,1)))/1010,1-(erf(((1:length(a(:,1))) - Xc)/Dc)+1)/2,'Color',[0.2 1 0]);
    %plot(delta(:,1),delta(:,2).^2,'-');
    hold on
    xlabel('mm');
    ylabel('C, %');
end
legend('40 - 0016617','2dmin - 129','2dmax - 368', 'erf function');
%%
%erf plot Guntars formatting
csvwrite(['D107_19','.dat'],cs)
hh=figure;
set(hh, 'Units', 'centimeters')
set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
set(hh, 'Position', [0 10 13.5 7])
fsize=10;
msize=7;
fname='Times';
pnames=[40];
for j=1:length(pnames)
    subplot(1,2,1)
    hold on
    %a=csvread(['0_1-2_sk-',char(pnames(j)),'.dat']);
    a=csvread(['D107_19','.dat']);
    a(a<0)=0; %filter <0 values concentration values
    a(a>1)=1; %filter >1 values concentration values
    plot((1:length(a(:,1)))/ZOOM,1-a(:,pnames(j)),'Color',[1 0 0]);
    dmin=x(pnames(j),1);
    line([dmin dmin]/ZOOM, [0 1], 'Color',[.8 .8 .8]);
    dmax=x(pnames(j),2);
    line([dmax dmax]/ZOOM, [0 1], 'Color',[.8 .8 .8]);
    Dc = (dmax - dmin)/2; % delta
    Xc = dmin + Dc; % Xvidus
    plot((1:length(a(:,1)))/ZOOM,1-(erf(((1:length(a(:,1))) - Xc)/Dc)+1)/2,'Color',[0.2 1 0]);
    %plot(delta(:,1),delta(:,2).^2,'-');
    hold on
    %uzraksti-asiim
    xlabel('{\it mm}','FontName',fname,'FontSize',fsize);
    ylabel('{\it Concentration}','FontName',fname,'FontSize',fsize);
    legend('2s','2\delta_{min}','2\delta_{max}', 'erf',...
    'location','northeast','FontName','Times','FontSize',8);
    %legend('boxoff');
    %ja vajag pielikt papildus info - piemeram atsauci (a) un (b) uz dazadiem atteliem

    %ja vajag legendu
end

csvwrite(['0_0mkl-min_1_8A_3_2pal_1x','.dat'],cs)
pnames=[270];
for j=1:length(pnames)
    subplot(1,2,2)
    hold on
    %a=csvread(['0_1-2_sk-',char(pnames(j)),'.dat']);
    a=csvread(['0_0mkl-min_1_8A_3_2pal_1x','.dat']);
    a(a<0)=0; %filter <0 values concentration values
    a(a>1)=1; %filter >1 values concentration values
    plot((1:length(a(:,1)))/1010,1-a(:,pnames(j)),'Color',[0 0 1]);
    dmin=x(pnames(j),1);
    line([dmin dmin]/1010, [0 1], 'Color',[.8 .8 .8]);
    dmax=x(pnames(j),2);
    line([dmax dmax]/1010, [0 1], 'Color',[.8 .8 .8]);
    Dc = (dmax - dmin)/2; % delta
    Xc = dmin + Dc; % Xvidus
    plot((1:length(a(:,1)))/1010,1-(erf(((1:length(a(:,1))) - Xc)/Dc)+1)/2,'Color',[0.2 1 0]);
    %plot(delta(:,1),delta(:,2).^2,'-');
    hold on
    %uzraksti-asiim
    xlabel('{\it mm}','FontName',fname,'FontSize',fsize);
    ylabel('{\it Concentration}','FontName',fname,'FontSize',fsize);
    legend('17s','2\delta_{min}','2\delta_{max}', 'erf',...
    'location','northeast','FontName','Times','FontSize',8);
    %legend('boxoff');
    %ja vajag pielikt papildus info - piemeram atsauci (a) un (b) uz dazadiem atteliem
    axes('Position',[0 0 1 1],'Visible', 'off'); 
    text(0.01,0.98,'(a)','FontName',fname,'FontSize',fsize);
    text(0.51,0.98,'(b)','FontName',fname,'FontSize',fsize);
    %ja vajag legendu
end
