function [ Concentration, save_flag ] = CoefficientAcquisition2( Concentration )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    save_flag = false;
    nonullet_kvadratisko = false; %vai nullçt gala grafiku
    nonullet_deltu = false; %vai nullçt input grafiku
    if nonullet_kvadratisko ==true && nonullet_deltu==true
        msg = 'Vienlaicigi nevar nonullet pec abam metodem.';
        error(msg) 
    end
    
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
        if nonullet_deltu == true
            a(:,2) = a(:,2) - a(1,2); % NONULLEEE LIKNI
        else
            sakuma_delta = a(1,2);
        end
        a(:,2) = a(:,2) /exp.zoom; %parveido no px uz mm
        
        plot_free = false;
        free_slope = 0;
        free_coef = 0;
        
        plot_manual = false;
        manual_lim_min = 0;
        manual_lim_max = 100000;
        
        t = a(:,1);
        deltas = a(:,2);
        time_coefficient = 1 / 1000; % 1000 for ms to s
        delta_ceoffficient = 1 / 4;
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
            if nonullet_kvadratisko == true
                y = y - (sakuma_delta/ exp.zoom)^2 * delta_ceoffficient; % NONULLEEE LIKNI
            end
            X = [ones(length(x),1) x];
            % ---- NEW ABOVE------
            
            
%             ind_max = a(:,1) < (lim_max); % iegust indexu vertibam kuras parsniedz maksimalo laiku
%             % iegust datu dalu liknes aprekinasanai
%             a2 = a(:,2);
%             a2 = a2(ind_max); % atstâj tikai vertibas lidz max laikam
%             a2 = [a(ind_max) a2];
% 
%             % taisnes aprekins
%             ind = a2(:,1)>lim; % indices of values greater than start
%             x=a2(ind)/1e3; % take only points which are beyond start time
%             a2(:,2) = a2(:,2) - a2(1,2); % y values start from 0
%             y=a2(:,2); % take correspoinding delta values
%             y=1/4*y(ind).^2; % aprekina indexetajam vertibam 4 delta ^2
%             X = [ones(length(x),1) x];
            
            
            s = fitoptions('Method','LinearLeastSquares');
                   %'Lower',[10,1],...
                   %'Upper',[500,10000],...
                   %'Startpoint',[100,186.5]);%,...
                   %'Weights',(1./d_a_b_exp.^2));
            h=fittype({'x','1'}, 'coefficients',{'a','b'});
            [cfun,gof,tx]=fit(X(:,2),y,h,s);
            C = confint(cfun, 0.99);
            Coef_error = (C(2,2)-C(1,2)) /2;
            Slope_error = (C(2,1)-C(1,1)) /2;
            
            b = X\y; % aprekina koeficientus
            fprintf('Taisnes vienadojums ir:\n y=%i * x + %i\n', b(2),b(1)); %parada taisnes vienadojums linearajai regresijai
            
            x0 = [1.0, 0.0]; % pievieno sakuma vertibu
            xend = [1, data(end,1) * time_coefficient];
            X = [ones(length(data(:,1)),1) data(:,1) * time_coefficient];
            X = X;
            X = [x0; X; xend];
            
            yCalc3 = X*b; % aprekina taisni
            % --- NEW ABOVE -----
            
%             b = X\y; % aprekina koeficientus
%             fprintf('Taisnes vienadojums ir:\n y=%i * x + %i\n', b(2),b(1)); %parada taisnes vienadojums linearajai regresijai
%             x0 = [1.0, 0.0]; % pievieno sakuma vertibu
%             xend = [1, a2(end,1)/1000];
%             X = [ones(length(a2(:,1)),1) a2(:,1)/1e3];
%             X = [x0; X; xend];
%             yCalc3 = X*b; % aprekina taisni
            taisnes_teksts = sprintf('y=%i * x + %i\n', b(2),b(1));
            
            
            % Uzzimet abus grafikus - delta^2 vs t un taisnes vienadojumu
            y_raw = (data(:,2).^2) * delta_ceoffficient;
            if nonullet_kvadratisko == true
                y_raw = y_raw - y_raw(1); % nonulle kvadratisko likni
            end
            
            plot(data(:,1) * time_coefficient, y_raw,'-','Color',[230,159,0]/255); % originalais 1/4*delta^2 / 0.13^2 grafiks 
            

            % Uzzimet abus grafikus - delta^2 vs t un taisnes vienadojumu
            %plot(a2(:,1)/1e3,1/4*a2(:,2).^2,'-','Color',[230,159,0]/255); % originalais 1/4*delta^2 grafiks
            hold on
            % plot free linear equation
            if plot_free
               y_coefs = [free_coef, free_slope];
               y_free = X * y_coefs';
               if exist('free_fig')
                  delete(free_fig);
                  delete(free_txt)
               end
               free_fig = plot(X(:,2),y_free,'--g');
               free_text_ind = int16(length(X)* 2 / 3);
               free_x_text = X(free_text_ind,2);
               free_y_text = y_free(free_text_ind) / 3;
               free_taisnes_teksts = sprintf('y=%i * x + %i\n', free_slope,free_coef);
               free_txt=text(free_x_text,free_y_text,free_taisnes_teksts,'HorizontalAlignment','center','VerticalAlignment', 'bottom','rotation',30, 'Color', 'g'); % uzzime tekstu taisnei fittotajai
            end
            if plot_manual
                manual_ind_max = a2(:,1) < (manual_lim_max); % iegust indexu vertibam kuras parsniedz maksimalo laiku
                % iegust datu dalu liknes aprekinasanai
                manual_data = a2(:,2);
                manual_data = manual_data(manual_ind_max); % atstâj tikai vertibas lidz max laikam
                manual_time = a2(:,1);
                manual_data = [manual_time(manual_ind_max) manual_data];

                % taisnes aprekins
                manual_ind_min = manual_data(:,1)>manual_lim_min; % indices of values greater than start
                manual_x = manual_data(manual_ind_min); % take only points which are beyond start time
                manual_y=manual_data(:,2); % take correspoinding delta values
                manual_y=1/4*manual_y(manual_ind_min).^2; % aprekina indexetajam vertibam 4 delta ^2
                manual_X = [ones(length(manual_x),1) manual_x  /1e3];
                man_b = manual_X\manual_y; % aprekina koeficientus
                fprintf('manualas otras Taisnes vienadojums ir:\n y=%i * x + %i\n', man_b(2),man_b(1)); %parada taisnes vienadojums linearajai regresijai
                x0 = [1.0, 0.0]; % pievieno sakuma vertibu
                manual_xend = [1, manual_data(end,1)/1000];
                manual_X = [ones(length(manual_data(:,1)),1) manual_data(:,1)/1e3];
                manual_X = [x0; manual_X; manual_xend];
                manual_y_fit = X*man_b; % aprekina taisni
                man_taisnes_teksts = sprintf('y=%i * x + %i\n', man_b(2),man_b(1));
                if exist('manual_fig')
                    delete(manual_fig)
                    delete(man_txt)
                end
                manual_fig = plot(X(:,2),manual_y_fit,'--r','LineWidth',1);
                man_text_ind = int16(length(X) / 4);
                man_x_text = X(man_text_ind,2);
                man_y_text = manual_y_fit(man_text_ind);
                man_txt=text(man_x_text,man_y_text,man_taisnes_teksts,'HorizontalAlignment','center','VerticalAlignment', 'bottom','rotation',30, 'Color', 'r'); % uzzime tekstu taisnei fittotajai
            end
            % plot fit text
            text_ind = int16(length(X) / 2);
            x_text = X(text_ind,2);
            y_text = yCalc3(text_ind);
            txt=text(x_text,y_text,taisnes_teksts,'HorizontalAlignment','center','VerticalAlignment', 'bottom','rotation',30); % uzzime tekstu taisnei fittotajai
            
            plot([0 ; data(:,1) ; data(end,1)] * time_coefficient, yCalc3,'--k'); % uzzime taisni
            %plot([0 ; a2(:,1) ; a2(end,1)]/1e3,yCalc3,'--k'); % uzzime taisni
            %plot(X(:,2),yCalc3+Coef_error,'m--',X(:,2),yCalc3-Coef_error,'m--') % uzzime error taisnes
            hold off
            xlabel('t, s');
            ylabel('\delta^2/4, mm^2');
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
            prompt = [prompt,'"free" or "f" for manually entered linear eq. and "manual" or "m" for 2nd fitted line \n'];
            x = input(prompt,'s');
            %x  = 'yes';
            if strcmp(x, 'yes') || strcmp(x, 'y')
                accepted = true;
                exp.coef_lim(1) = lim;
                exp.coef_lim(2) = lim_max;
                exp.coef = b;
                exp.coef_errors = [Coef_error, Slope_error]; % slope error, coef error
                exp.validity = validity;
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
                exp.validity = validity;
                Concentration.(Cfields{j}) =  exp;
                %save('MMML_dataset.mat','MMML_dataset');
                save_flag = true;
                return
            elseif strcmp(x, 'invalid')
                exp.validity = 0;
            elseif strcmp(x, 'valid')
                exp.validity = 1;
            elseif strcmp(x, 'free') || strcmp(x, 'f')
                prompt = 'Write y-intersect coef (b in y=ax+b).\n';
                free_coef = input(prompt);
                prompt = 'Write slope coef (a in y=ax+b).\n';
                free_slope = input(prompt);
                plot_free = true;
            elseif strcmp(x, 'manual') || strcmp(x, 'm')
                prompt = 'Write start time in seconds [s].\n';
                manual_lim_min = 1000 * input(prompt);
                prompt = 'Write end time in seconds [s].\n';
                manual_lim_max = 1000 * input(prompt);
                plot_manual=true;
            else
                prompt = 'Write start time in seconds [s].\n';
                lim = 1000 * input(prompt);
                prompt = 'Write end time in seconds [s].\n';
                lim_max = 1000 * input(prompt);
            end
        end
        
    %break
    end
    

