function [ Concentration ] = CoefficientAcquisition( Concentration )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    Cfields = fieldnames(Concentration);
    names = cell(1,length(Cfields));
    PLOTS = gobjects(1,length(Cfields));
    order = zeros(1,length(Cfields));
    for j=1:length(Cfields)
        exp = Concentration.(Cfields{j});
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
                Concentration.(Cfields{j}) =  exp;
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
                Concentration.(Cfields{j}) =  exp;
                %save('MMML_dataset.mat','MMML_dataset');
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


