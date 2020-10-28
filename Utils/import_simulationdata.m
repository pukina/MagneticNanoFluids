function [Ram_exp1,delta_MC_BD_exp1,deltaresolutionBD1,to_exclude,type_id,plot_meaning] = import_simulationdata(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [RAM_EXP1,DELTA_MC_BD_EXP1,DELTARESOLUTIONBD1,TO_EXCLUDE,TYPE_ID,PLOT_MEANING]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [RAM_EXP1,DELTA_MC_BD_EXP1,DELTARESOLUTIONBD1,TO_EXCLUDE,TYPE_ID,PLOT_MEANING]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [Ram_exp1,delta_MC_BD_exp1,deltaresolutionBD1,to_exclude,type_id,plot_meaning] = importfile('D107_ram.csv',3, 28);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2020/07/22 11:03:32

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 3;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,-1.0,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,-1.0,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
Ram_exp1 = dataArray{:, 1};
delta_MC_BD_exp1 = dataArray{:, 2};
deltaresolutionBD1 = dataArray{:, 3};
to_exclude = dataArray{:, 4};
type_id = dataArray{:, 5};
plot_meaning = dataArray{:, 6};


