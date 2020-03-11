s = struct();
data = [{'Amperi'},{'Lauks_mT'}, {'deltas'},{'t'},{'tbd'},{'validity'}];
fields = fieldnames(MMML_dataset);
for i=1:numel(fields)
    Sample = MMML_dataset.(fields{i});
    Cfields = fieldnames(Sample);
    
    results = ones(length(Cfields), length(data), 'double');
    for j=1:length(Cfields)
        exp = Sample.(Cfields{j});
        % ðeit ir maìija
        results(j,1) = exp.amperi;
        results(j,2) = exp.lauksmT;
        results(j,3) = (exp.delta(1,2)/(exp.zoom));
        tbd = (exp.delta(1,2)/(exp.zoom*1000))^2/(4*5.7*10^(-7));
        results(j,4) = tbd;
        results(j,5) = (tbd * (0.13 * 10^(-3))^2) / (5.7 * 10^(-7));
        if isfield(exp,'validity')
            if exp.validity == 0
                results(j,6) = 0;
            end
        end
        
        %fprintf('Experiments: %s, Zoom ir %i\n',exp.concentration, exp.zoom);
    end
    s.(fields{i})=results;
end
results