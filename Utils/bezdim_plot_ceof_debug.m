%%
%8 
% log 1/4delta^2 vs log(H^2)
skip = false;
if skip == false
    % create 4 graphs:
    % 1) (delta^2 /4) vs Ra_m
    % 2) delta^2 / Ram
    % 3) log(delta^2 / 4) vs log(Ram)
    % 4) log(delta^2) vs log(Ram)
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
        errors = ones(1, valid_exp);
        infinities = 0;
        for j=1:valid_exp
            index = valid_exp_ind(j);
            exp = Sample.(Cfields{index});
            numenator = (c*exp.lauksmT*10*0.016*0.013)^2;
            denumenator = 12*0.01*(5.7*10^(-7));
            X(j) = log( numenator / denumenator );
            if isinf(X(j))
                fprintf('%s has RAM value %g\n',Cfields{index},X(j))
                infinities = infinities + 1;
            end
            res1 = log(exp.bezdim_coef1(1));
            res2 = log(exp.bezdim_coef2(1));
            errors(j) = abs(res1 - res2) / 2;
            %Y(j) = log(exp.bezdim_coef1(2)^2);
            Y(j) = (res1+res2)/2;
            names{i} = exp.concentration;
        end
        [X,ind] = sort(X);
        Y = Y(ind);
        errors = errors(ind);
        namespaces = Cfields(ind);
        namespaces = namespaces(infinities+1:end)'
        
        X = X(infinities+1:end);
        Y = Y(infinities+1:end);
        errors = errors(infinities+1:end);
        
        %[C,ia,idx] = unique(X,'stable');
        %val = accumarray(idx,Y,[],@mean); 
        %X = C;
        %Y = val;
        %errors = accumarray(idx,errors,[],@mean);
        %errorbar(X,Y,errors)
        %scatter(X, Y);
        plot(X, Y,'-o');
        drawnow
    end
    legend(names);
    xlabel('log(Ram)');
    ylabel('log(\delta^2/4 MCV_BD), mm^2');
    title('log(\delta^2/4 MCV_BD) vs log(Ram)');
end