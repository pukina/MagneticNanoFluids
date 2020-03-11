% script for normalizing concentration and delta values
concentrations = fieldnames(MMML_dataset);
for i=1:numel(concentrations)
    Sample = MMML_dataset.(concentrations{i});
    experiments = fieldnames(Sample);
    for j=1:length(experiments)
        exp = Sample.(experiments{j});
        fprintf('Current experiment: %s\n',experiments{j}); % Print current experiment
        cs = exp.cs;
        delta = exp.delta;
        x = exp.x;
        % normalize concentration values
        %x = [min(cs,[],1);max(cs,[],1)];
        %b = bsxfun(@minus,cs,x(1,:));
        %cs = bsxfun(@rdivide,b,diff(x,1,1));
        
        % values which are lower at the start are probably not correct
        %for m=1:length(cs(1,:))
        %    [val, idx] = max(1-cs(:,m));
        %    cs(1:idx,m)=1-val;
        %end
        [~,x0]=min((cs-(erf(-1)+1)/2).^2); %find -delta point
        [~,x1]=min((cs-(erf(+1)+1)/2).^2); %find +delta point
        res = (x1 - x0)/2;
        delta(:,2) = res;
        x(:,1) = x0;
        x(:,2) = x1;
        %MMML_dataset.(concentrations{i}).(experiments{j}).cs = cs;
        %MMML_dataset.(concentrations{i}).(experiments{j}).delta = delta;
        MMML_dataset.(concentrations{i}).(experiments{j}).x = x;
    end
end