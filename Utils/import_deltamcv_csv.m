function [folderis,mt,oe,oe_kv,delta_kv4,sakuma_pacelums,stdev,ram,delta,delta_mc_bd,slope,slope_stdev,delta_res,delta_res_bd,experimental] = import_deltamcv_csv(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [FOLDERIS,MT,OE,DELTA_KV4,DELTA_KV4_0,STDEV,RAM,DELTA_KV4_BD,DELTA_BD,EXPERIMENTAL]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [FOLDERIS,MT,OE,DELTA_KV4,DELTA_KV4_0,STDEV,RAM,DELTA_KV4_BD,DELTA_BD,EXPERIMENTAL]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [folderis,mt,oe,delta_kv4,delta_kv4_0,stdev,ram,delta_kv4_bd,delta_bd,experimental] = importfile('D107.csv',3, 20);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2020/06/18 00:50:34

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
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%   column12: double (%f)
%   column13: double (%f)
%   column14: double (%f)
%   column15: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
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
folderis = dataArray{:, 1};
mt = dataArray{:, 2};
oe = dataArray{:, 3};
oe_kv = dataArray{:, 4};
delta_kv4 = dataArray{:, 5};
sakuma_pacelums = dataArray{:, 6};
stdev = dataArray{:, 7};
ram = dataArray{:, 8};
delta = dataArray{:, 9};
delta_mc_bd = dataArray{:, 10};
slope = dataArray{:, 11};
slope_stdev = dataArray{:, 12};
delta_res = dataArray{:, 13};
delta_res_bd = dataArray{:, 14};
experimental = dataArray{:, 15};




