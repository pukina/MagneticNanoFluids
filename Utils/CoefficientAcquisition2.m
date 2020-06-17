function [ Concentration, save_flag ] = CoefficientAcquisition2( Concentration )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    save_flag = false;
    crop_to_limits = false;
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
            ind_max = t < lim_max; % iegust indexu vertibam kuras parsniedz maksimalo laiku
            ind_min = t > lim; % indices of values greater than start
            indexes = ind_max & ind_min;       
            
            % taisnes aprekins
            x = t * time_coefficient; % take only points which are beyond start time
            y =(deltas.^2) * delta_ceoffficient; % aprekina indexetajam vertibam 4 delta ^2 /0.13^2
            
            if nonullet_kvadratisko == true
                y = y - (sakuma_delta/ exp.zoom)^2 * delta_ceoffficient; % NONULLEEE LIKNI
            end
            
            y_fit = y(indexes);
            x_fit = x(indexes);
            X_fit = [ones(length(x_fit),1) x_fit];
            
            s = fitoptions('Method','LinearLeastSquares');
                   %'Lower',[10,1],...
                   %'Upper',[500,10000],...
                   %'Startpoint',[100,186.5]);%,...
                   %'Weights',(1./d_a_b_exp.^2));
            h=fittype({'x','1'}, 'coefficients',{'a','b'});
            [cfun,gof,tx]=fit(X_fit(:,2),y_fit,h,s);
            C = confint(cfun, 0.99);
            Coef_error = (C(2,2)-C(1,2)) /2;
            Slope_error = (C(2,1)-C(1,1)) /2;
            
            b = X_fit\y_fit; % aprekina koeficientus
            fprintf('Taisnes vienadojums ir:\n y=%i * x + %i\n', b(2),b(1)); %parada taisnes vienadojums linearajai regresijai
            
            %x0 = [1.0, 0.0]; % pievieno sakuma vertibu
            %xend = [1, data(end,1) * time_coefficient];
            %X = [ones(length(data(:,1)),1) data(:,1) * time_coefficient];
            %X = X;
            %X = [x0; X; xend]
            if crop_to_limits == true
                x_plot = x_fit;
                y_plot = y_fit;
            else
                x_plot = x;
                y_plot = y;
            end
                
            X_plot = [ones(length(x_plot),1) x_plot];
            y_fited = X_plot*b; % aprekina taisni
                  
            % Uzzimet abus grafikus - delta^2 vs t un taisnes vienadojumu
            taisnes_teksts = sprintf('y=%i * x + %i\n', b(2),b(1));
            plot(x_plot, y_plot,'-','Color',[230,159,0]/255); % originalais 1/4*delta^2 / 0.13^2 grafiks            
            hold on
            
            % plot free linear equation
            if plot_free
               y_coefs = [free_coef, free_slope];
               y_free = X_plot * y_coefs';
               if exist('free_fig')
                  delete(free_fig);
                  delete(free_txt)
               end
               free_fig = plot(x_plot,y_free,'--g');
               free_text_ind = int16(length(X_plot)* 2 / 3);
               free_x_text = X_plot(free_text_ind,2);
               free_y_text = y_free(free_text_ind) / 3;
               free_taisnes_teksts = sprintf('y=%i * x + %i\n', free_slope,free_coef);
               free_txt=text(free_x_text,free_y_text,free_taisnes_teksts,'HorizontalAlignment','center','VerticalAlignment', 'bottom','rotation',30, 'Color', 'g'); % uzzime tekstu taisnei fittotajai
            end
            
            if plot_manual
                % indexi
                manual_ind_max = t < (manual_lim_max); % iegust indexu vertibam kuras parsniedz maksimalo laiku
                manual_ind_min = t  > manual_lim_min; % indices of values greater than start
                manual_indexes = manual_ind_max & manual_ind_min; 
                % x y atlase taisnes aprekinam
                manual_y_fit = y(manual_indexes);
                manual_x_fit = x(manual_indexes);
                manual_X_fit = [ones(length(manual_x_fit),1) manual_x_fit];
                % koeficenta aprekins
                man_b = manual_X_fit\manual_y_fit; % aprekina koeficientus            
                fprintf('manualas otras Taisnes vienadojums ir:\n y=%i * x + %i\n', man_b(2),man_b(1)); %parada taisnes vienadojums linearajai regresijai
                man_taisnes_teksts = sprintf('y=%i * x + %i\n', man_b(2),man_b(1));
                % taisnes aprekins
                manual_y_fitted = X_plot*man_b; % aprekina taisni
                % grafika zimesana
                if exist('manual_fig')
                    delete(manual_fig)
                    delete(man_txt)
                end
                manual_fig = plot(x_plot,manual_y_fitted,'--r','LineWidth',1);
                % teksts informativais
                man_text_ind = int16(length(X_plot) / 4);
                man_x_text = X_plot(man_text_ind,2);
                man_y_text = manual_y_fitted(man_text_ind);
                man_txt=text(man_x_text,man_y_text,man_taisnes_teksts,'HorizontalAlignment','center','VerticalAlignment', 'bottom','rotation',30, 'Color', 'r'); % uzzime tekstu taisnei fittotajai
            end
            
            % plot fit text
            text_ind = int16(length(X_plot) / 2);
            x_text = X_plot(text_ind,2);
            y_text = y_fited(text_ind);
            txt=text(x_text,y_text,taisnes_teksts,'HorizontalAlignment','center','VerticalAlignment', 'bottom','rotation',30); % uzzime tekstu taisnei fittotajai
            
            plot(x_plot, y_fited,'--k'); % uzzime taisni
            hold off
            
            % FIGURE FORMATTING
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
            prompt = [prompt,'"crop" or "c" for toggling from cropping axis to limits or vice-versa (Default: False)\n'];
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
            elseif strcmp(x, 'crop') || strcmp(x, 'c')
                crop_to_limits = not(crop_to_limits);
            else
                prompt = 'Write start time in seconds [s].\n';
                lim = 1000 * input(prompt);
                prompt = 'Write end time in seconds [s].\n';
                lim_max = 1000 * input(prompt);
            end
        end
        
    %break
    end
    

