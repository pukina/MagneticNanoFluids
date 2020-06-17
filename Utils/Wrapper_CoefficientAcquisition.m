function [ MMML_dataset ] = Wrapper_CoefficientAcquisition( MMML_dataset )
%Wrapper_CoefficientAcquisition acquire start time for plotting linear graph
%   acquire start time for plotting linear graph
    hh=initFigure();
    concentrations = fieldnames(MMML_dataset);
    for i=1:numel(concentrations)
        [MMML_dataset.(concentrations{i}), save_flag] = CoefficientAcquisition2(  MMML_dataset.(concentrations{i}) );
        if save_flag == true
            return
        end
    end

end

