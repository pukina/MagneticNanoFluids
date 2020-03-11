function [ ] = Wrapper_CoefficientAcquisition_NonDim( MMML_dataset )
%Wrapper_CoefficientAcquisition_NonDim acquire start time for plotting linear graph (non-dimensional)
%   acquire start time for plotting linear graph 
%   in non dimensional units (0.13^2 top side coef / *5.7*10^-7/0.013^2)

    hh=initFigure();
    concentrations = fieldnames(MMML_dataset);
    for i=1:numel(concentrations)
        MMML_dataset.(concentrations{i}) = CoefficientAcquisition3(  MMML_dataset.(concentrations{i}) );
    end

end

