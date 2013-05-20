%% cpHistogram
%
%% Inputs
% * |data|, a required variable. |data| is a cell array containing time
% series data. In each position of the cell array resides a column vector.
% There is a row for every cell measurement in the column vector.
% * |outpath|, the directory where image files will be saved. By default
% this is the user's home in the MATLAB(R) path.
% * |nbins|, the number of bins within a histogram or if this is an array,
% the centers of histogram boxes. The default value is 100.
% * |titles|, the titles that will be placed above each figure. There must
% be a title for each column vector in the |data| cell array.
%%% Outputs
% * |figh|, a struct containing the figure handles for each plot created by
% this function. This output is useful for tweaking these plots after the
% function call.
function [figh] = cpHistogram(data,varargin)
%% Parse input
% The inputs into the function are parsed. If there were no inputs when the
% function was called a set of demonstrative data is imported and
% processed; this is useful and necessary for MATLAB-publishing this file.
if nargin == 0
    data = loadDemoData('cpHistogram');
end
defaultOutpath = userpath;
defaultNbins = 100;
defaultTitles = num2cell(1:length(data));
defaultTitles = cellfun(@num2str,defaultTitles,'UniformOutput', false);

p = inputParser;
addRequired(p,'data',@iscell);
addParamValue(p,'outpath',defaultOutpath,@isdir);
addParamValue(p,'nbins',defaultNbins,@isinteger);
addParamValue(p,'titles',defaultTitles,@(x) length(x)==length(data));
parse(p,data,varargin{:});

if nargin == 0
    [mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
    outpath = fullfile(mfilepath,'html');
else
    outpath = p.Results.outpath;
end
if ~isdir(outpath)
    mkdir(outpath);
end
%% histogram
figh(length(data)).hist = []; %initialize struct for speedy memory access
for i=1:length(data)
    figure;
    hist(data{i},p.Results.nbins);
    figh(i).hist = gcf;
    str = sprintf('number of cells');
    ylabel(str);
    title(p.Results.titles{i});
    set(figh(i).hist,'PaperSize',[7 4]);
    set(figh(i).hist,'PaperUnits','inches','PaperPosition',[0 0 6.4 3.6]);
    rez=150; %resolution (dpi) of final graphic
    str = sprintf('cpHistogram_%s.png',p.Results.titles{i});
    print(figh(i).hist,fullfile(outpath,str),'-dpng',['-r',num2str(rez)],'-opengl') %save file
    str = sprintf('cpHistogram_%s.pdf',p.Results.titles{i});
    print(figh(i).hist,fullfile(outpath,str),'-dpdf');
end
%% Full Size Demo Figures
%
% <<cpHistogram_1.png>>
%
% <<cpHistogram_2.png>>
%