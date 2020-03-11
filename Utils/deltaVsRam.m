%%
% delta vs RAM
skip = false;
if skip == false
    % create 4 graphs:
    % 1) (delta^2 /4) vs Ra_m
    % 2) delta^2 / Ram
    % 3) log(delta^2 / 4) vs log(Ram)
    % 4) log(delta^2) vs log(Ram)
    xlabels = {'Ra_m', 'Ra_m','log(Ra_m)','log(Ra_m)','Ra_m^2'};
    ylabels = {'\delta^2/4, mm^2','\delta^2, mm^2','log(\delta^2/4), mm^2','log(\delta^2), mm^2','\delta^2, mm^2'};
    for g=1:5
        concentrations = fieldnames(MMML_dataset);
        hh=figure;
        set(hh, 'Units', 'centimeters')
        set(hh,'PaperUnits', 'centimeters','PaperSize', [12, 7]);
        set(hh, 'Position', [0 10 13.5 7])
        fsize=10;
        msize=7;
        fname='Times';
        names = cell(1,length(concentrations));
        order = [1 3 2 4 5]; % HARDCODED order
        for i=1:numel(concentrations)
            %hh=figure;
            Sample = MMML_dataset.(concentrations{order(i)});
            Cfields = fieldnames(Sample);
            c = char(concentrations(i));
            if length(c)>4
                c =  str2num(c(6:end));
                decimals = length(num2str(c));
                c = c/(10^decimals);
            else
                c = 1;
            end
            if g == 1
                fprintf('Concentration %s is : %g\n',char(concentrations(i)), c);
            end
            valid_exp = 0;
            valid_exp_ind = [];
            for j=1:length(Cfields)
                exp = Sample.(Cfields{j});
                if isfield(exp,'validity')
                    if exp.validity
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
            for j=1:valid_exp
                index = valid_exp_ind(j);
                exp = Sample.(Cfields{index});
                RAM = (exp.lauksmT*10*c*0.016)^2 * 0.013^2 / (12*0.01*5.7*10^(-7));
                if g==3 || g ==4
                    RAM = log(RAM);
                elseif g ==5
                    RAM = RAM^2;
                end
                X(j) = RAM;
                res = exp.coef(1)^2;
                if g==1 || g ==3
                   res = res / 4; 
                end
                if g ==3 || g ==4
                   res = log(res); 
                end
                    
                Y(j) = res;
                names{i} = strcat('Ra_g= ',exp.concentration);
            end
            [X,ind] = sort(X);
            Y = Y(ind);
            %scatter(X, Y);
            plot(X, Y,'-o');
        end
        legend(names);
        xlabel(char(xlabels(g)));
        ylabel(char(ylabels(g)));
        %title('log(\delta^2/4) vs log(H^2)')
    end
end