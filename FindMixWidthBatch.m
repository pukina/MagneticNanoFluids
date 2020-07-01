%% #1: import experiment database of calculated values if these exist
% and adds function folder to path (START WITH THIS)
load('MMML_dataset_fittings.mat')
addpath('Utils');

%% #2: Save dataset into .mat file (TAKES SOME TIME ~2GB)
% UNCOMMENT TO USE
%save('MMML_dataset_fittings.mat','MMML_dataset');

%% #4: calculate concentration and delta values for selected experiments
% To recalculate specific experiment: set 'calculated' variable to 0
% ---REQUIRES TESTING---
MMML_dataset = CalcConcAndDelta(MMML_dataset);

%% #5: Check experiments done
CheckExperiments(MMML_dataset);

%% #6: Plot for each concentration delta vs time for each magnetic field
% Bez markieriem visas liknes
% ---REQUIRES TESTING---
Wrapper_PlotDeltaVsTime(MMML_dataset);

%% #7: Plot for each concentration delta vs time for each magnetic field
% ---REQUIRES TESTING---
Wrapper_PlotDeltaMarkersVsTime(MMML_dataset);

%% #8: Acquire start time for plotting linear graph
% Plots delta^2 / 4 Vs Time
% ---REQUIRES TESTING---
MMML_dataset = Wrapper_CoefficientAcquisition( MMML_dataset );

%% #9: Acquire start time for plotting linear graph (non-dim units)
% 0.13^2 top side coef / *5.7*10^-7/0.013^2
% ---REQUIRES TESTING---
Wrapper_CoefficientAcquisition_NonDim( MMML_dataset );

%% #10: Plot image grid normalized
% ---REQUIRES TESTING---
MMML_dataset = Wrapper_PictureGrid( MMML_dataset );

%% #11: Image grid each experiment in time
% ---REQUIRES TESTING---
Wrapper_ExpPictureGrid( MMML_dataset );

%% #12: Image grid rag vs ram in 4x4 or other configuration
% ---REQUIRES TESTING---
Wrapper_RagRamPictureGrid( MMML_dataset );
%% #13: Image grid RAG vs Time in 4x4 or other configuration
% ---REQUIRES TESTING---
Wrapper_RagVsTimeImgrid( MMML_dataset );
%% #14: show bounding box on image
% ---REQUIRES TESTING---
% experiment is set manually, and frame is acquired from debugger. Frame is
% image frame as sequence numinitFigure();
Wrapper_plotBoundingbox( MMML_dataset.D107_05.f1, 154 );