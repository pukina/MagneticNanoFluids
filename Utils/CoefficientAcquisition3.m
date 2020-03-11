function [ Concentration ] = CoefficientAcquisition3( Concentration )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    Cfields = fieldnames(Concentration);
    names = cell(1,length(Cfields));
    PLOTS = gobjects(1,length(Cfields));
    order = zeros(1,length(Cfields));
    for j=1:length(Cfields)
        exp = Concentration.(Cfields{j});
        if isfield(exp,'bezdim_coef_lim0')
            lim = exp.bezdim_coef_lim1(1);
            lim_max = exp.bezdim_coef_lim1(2);
            b = exp.bezdim_coef1;
        elseif isfield(exp,'coef_lim')
            lim = exp.coef_lim(1);
            lim_max = exp.coef_lim(2);
        else
            lim = 0; % inicialize taisnes laiku
            lim_max = 1000*1000; % inicialize max taisnes laiku 1000s *1000 ms/s
        end
        accepted = false;
        counter = 0; % skaita
        a=exp.delta; % get deltas
        a(:,1) = a(:,1)- a(1,1); % normalize time values to first frame
        a(:,2) = a(:,2)/exp.zoom; %parveido no px uz mm
        
        t = a(:,1);
        deltas = a(:,2);
        time_coefficient = 5.7*10^(-7) / (1000 * (0.013^2)); % 1000 for ms to s
        delta_ceoffficient = 1 / (4 * 0.13^2);
        while accepted == false
            ind_max = t < (lim_max); % iegust indexu vertibam kuras parsniedz maksimalo laiku
            % iegust datu dalu liknes aprekinasanai
            delta_max = deltas(ind_max); % atstâj tikai vertibas lidz max laikam
            data = [a(ind_max) delta_max];

            % taisnes aprekins
            ind_min = data(:,1)>lim; % indices of values greater than start
            x = data(ind_min) * time_coefficient; % take only points which are beyond start time
            y = data(:,2); % take correspoinding delta values
            y =(y(ind_min).^2) * delta_ceoffficient; % aprekina indexetajam vertibam 4 delta ^2 /0.13^2
            X = [ones(length(x),1) x];
            X = X;
            
            s = fitoptions('Method','LinearLeastSquares');
                   %'Lower',[10,1],...
                   %'Upper',[500,10000],...
                   %'Startpoint',[100,186.5]);%,...
                   %'Weights',(1./d_a_b_exp.^2));
            h=fittype({'x','1'}, 'coefficients',{'a','b'});
            [cfun,gof,tx]=fit(X(:,2),y,h,s);
            C = confint(cfun, 0.99);
            Coef_error = (C(2,2)-C(1,2)) /2
            Slope_error = (C(2,1)-C(1,1)) /2
            
            b = X\y; % aprekina koeficientus
            fprintf('Taisnes vienadojums ir:\n y=%i * x + %i\n', b(1),b(2)); %parada taisnes vienadojums linearajai regresijai
            
            x0 = [1.0, 0.0]; % pievieno sakuma vertibu
            xend = [1, data(end,1) * time_coefficient];
            X = [ones(length(data(:,1)),1) data(:,1) * time_coefficient];
            X = X;
            X = [x0; X; xend];
            
            yCalc3 = X*b; % aprekina taisni
            [y_fit,delta_error] = polyval(p,X(:,2),S);
            
            


            % Uzzimet abus grafikus - delta^2 vs t un taisnes vienadojumu
            plot(data(:,1) * time_coefficient, (data(:,2).^2) * delta_ceoffficient,'-','Color',[230,159,0]/255); % originalais 1/4*delta^2 / 0.13^2 grafiks 
            hold on
            plot([0 ; data(:,1) ; data(end,1)] * time_coefficient, yCalc3,'--k'); % uzzime taisni
            plot([0 ; data(:,1) ; data(end,1)] * time_coefficient, y_fit,'b--'); % uzzime taisni
            plot(X(:,2),y_fit+Coef_error,'m--',X(:,2),y_fit-Coef_error,'m--')
            hold off
            xlabel('t*5.7^10_-7 / 0.013^2'); % BEZDIMENSIONALS
            ylabel('\delta^2/(4*0.13^2)'); % BEZDIMENSIONALS
            if isfield(exp,'validity')
                validity = exp.validity;
            else
                validity = 1;
            end
            title([exp.concentration, ',', num2str(exp.amperi), 'A/' , num2str(exp.lauksmT),'mT/', 'Validity', num2str(validity)]);
            order(j)=exp.amperi;
            names{j}=strcat(num2str(exp.amperi*59.1,'%.1f'),' Oe');
            legend(names(j),'fitted');
            legend('boxoff');
            prompt = ('Is this fit acceptable? Write "yes" or "y" if good. To adjust press enter. "no" or "n" show orginal.\n');
            prompt = [prompt,'"save" stores current values and exits. PLEASE WAIT FOR SAVING LARGE DATASETS\n'];
            
            x = input(prompt,'s');
            %x  = 'yes';
            if strcmp(x, 'yes') || strcmp(x, 'y')
                accepted = true;
                exp.bezdim_coef_lim1(1) = lim;
                exp.bezdim_coef_lim1(2) = lim_max;
                exp.bezdim_coef1 = b; % coeff, slope
                exp.bezdim_coef1_errors = [Coef_error, Slope_error]; % slope error, coef error
                exp.validity = validity;
                Concentration.(Cfields{j}) =  exp;
            elseif strcmp(x, 'no') || strcmp(x, 'n')
                if isfield(exp,'bezdim_coef_lim1')
                    lim = exp.bezdim_coef_lim1(1);
                    lim_max = exp.bezdim_coef_lim1(2);
                elseif isfield(exp,'coef_lim1')
                    lim = exp.coef_lim1(1);
                    lim_max = exp.coef_lim1(2);
                else
                    lim = 0; % inicialize taisnes laiku
                    lim_max = 1000*1000; % inicialize max taisnes laiku 1000s *1000 ms/s
                end
            elseif strcmp(x, 'save')
                exp.bezdim_coef_lim1(1) = lim;
                exp.bezdim_coef_lim1(2) = lim_max;
                exp.bezdim_coef1 = b;
                exp.validity = validity;
                Concentration.(Cfields{j}) =  exp;
                %save('MMML_dataset.mat','MMML_dataset');
                return
            elseif strcmp(x, 'invalid')
                exp.validity = 0;
            elseif strcmp(x, 'valid')
                exp.validity = 1;
            else
                prompt = 'Write start time in seconds [s].\n';
                seconds_value = input(prompt) * 0.013^2 / (5.7*10^(-7));
                lim = 1000 * seconds_value;
                prompt = 'Write end time in seconds [s].\n';
                seconds_value = input(prompt) * 0.013^2 / (5.7*10^(-7));
                lim_max = 1000 * seconds_value;
            end
        end
        
    %break
    end
    

