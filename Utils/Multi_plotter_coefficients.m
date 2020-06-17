%% UUID = 15 uzdevums
% delta_MCV vs RAM
skip = false;
if skip == false
    % create 4 graphs:
    % 1) (delta^2 /4) vs Ra_m
    % 2) delta^2 / Ram
    % 3) log(delta^2 / 4) vs log(Ram)
    % 4) log(delta^2) vs log(Ram)
    xlabels = {'H',...
               'H^2',...
               'log(H^2)',...
               'log(Ra_m)',...
               'H',...
               'H^2',...
               'Ra_m'};
    ylabels = {'\delta^2/4, mm^2',...
               '\delta^2, mm^2',...
               'log(\delta^2/4), mm^2',...
               'log(\delta^2/4 MCV_bd)',...
               'slope, mm^2/s',...
               'slope, mm^2/s',...
               'slope MCV_bd'};
    for g=1:7
        concentrations = fieldnames(MMML_dataset);
        hh=figure;
        set(hh, 'Units', 'pixels')
        set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
        set(hh,'Position',[100 100 1600 800]);
        fsize=10;
        msize=7;
        fname='Times';
        names = cell(1,length(concentrations));
        order = [1 3 2 4 5]; % HARDCODED order
        for i=1:numel(concentrations)
            %hh=figure;
            Sample = MMML_dataset.(concentrations{order(i)});
            Cfields = fieldnames(Sample);
            c = char(concentrations(order(i)));
            if length(c)>4
                c =  str2num(c(6:end));
                decimals = length(num2str(c));
                c = c/(10^decimals);
                fprintf('Concentration %s is : %g\n',char(concentrations(order(i))), c);
            else
                c = 1;
                fprintf('Concentration %s is : %g\n',char(concentrations(order(i))), c);
            end
            valid_exp = 0;
            valid_exp_ind = [];
            for j=1:length(Cfields)
                exp = Sample.(Cfields{j});
                if isfield(exp,'validity')
                    if exp.validity == 1
                        valid_exp = valid_exp + 1;
                        valid_exp_ind = [valid_exp_ind, j];
                    end
                else
                    valid_exp_ind = [valid_exp_ind, j];
                    valid_exp = valid_exp + 1;
                end
            end
            hold on
            X = ones(1, valid_exp);
            Y = ones(1, valid_exp);
            errors = ones(1, valid_exp);
            infinities = 0;
            for j=1:valid_exp
                index = valid_exp_ind(j);
                exp = Sample.(Cfields{index});
                
                numenator = (c*exp.lauksmT*10*0.016*0.013)^2;
                denumenator = 12*0.01*(5.7*10^(-7));
                RAM = numenator / denumenator;
                
                % X coordinate processing
                if g==1 || g==5
                    X(j) = exp.lauksmT;
                elseif g==2 || g==6
                    X(j) = (exp.lauksmT)^2;
                elseif g==3
                    X(j) = log((exp.lauksmT)^2);
                elseif g ==4
                    X(j) = log(RAM);
                elseif g==7
                    X(j) = RAM;
                end
                if isinf(X(j))
                    fprintf('%s has RAM value %g\n',Cfields{index},X(j))
                    infinities = infinities + 1;
                end
                
                if exp.coef(1) <= 0 || exp.bezdim_coef1(1) <= 0
                    fprintf('%s has negative coefficient value\n',Cfields{index})
                    X(j) = -inf;
                    exp.coef(1) = 0.00001;
                    exp.bezdim_coef1(1) = 0.00001;
                    infinities = infinities + 1;
                end
                
                % Y coordinate processing
                if g==1 || g ==2
                    Y(j) = exp.coef(1);
                    errors(j) = exp.coef_errors(1);
                elseif g ==3
                    Y(j) = log(exp.coef(1));
                    error_y = log(exp.coef(1) + exp.coef_errors(1));
                    errors(j) = abs(Y(j) - error_y);
                elseif g ==4
                    Y(j) = log(exp.bezdim_coef1(1));
                    error_y = log(exp.bezdim_coef1(1) + exp.bezdim_coef1_errors(1));
                    errors(j) = abs(Y(j) - error_y);
                elseif g ==5 || g ==6
                    Y(j) = exp.coef(2);
                    errors(j) = exp.coef_errors(2);
                elseif g ==7
                    Y(j) = exp.bezdim_coef1(2);
                    errors(j) = exp.bezdim_coef1_errors(2);
                end
                names{i} = strcat('Ra_g= ',exp.concentration);
            end
            [X,ind] = sort(X);
            Y = Y(ind);
            errors = errors(ind);
            namespaces = Cfields(ind);
            namespaces = namespaces(infinities+1:end)'
        
            X = X(infinities+1:end);
            Y = Y(infinities+1:end);
            errors = errors(infinities+1:end);
            
            %scatter(X, Y);
            %plot(X, Y,'-o');
            
            [C,ia,idx] = unique(X,'stable');
            val = accumarray(idx,Y,[],@mean); 
            X = C;
            Y = val;
            errors = accumarray(idx,errors,[],@mean);
            errorbar(X,Y,errors)
            
            %plot(X, Y,'-o');
            
        end
        legend(names);
        legend('boxoff');
        xlabel(char(xlabels(g)));
        ylabel(char(ylabels(g)));
        %title('log(\delta^2/4) vs log(H^2)')
        
        F = getframe(hh);
        jpeg_string = sprintf('E:/Darbs/MMML/matlab_data/19_12_2019/%i.jpg', g)
        %imwrite(F.cdata, jpeg_string);
        %hgexport(hh,sprintf('Results/Imgrid_grav_intime/%s.eps', name)); %ja nevajag exportu, tad izkomentçt
        %savefig(hh,sprintf('E:/Darbs/MMML/matlab_data/19_12_2019/%i.fig', g),'compact') %ja nevajag save, tad izkomentçt
    end

end