%% cpKsdensity
%
%% Inputs
% * |data|, a required variable. |data| is a cell array containing time
% series data. In each position of the cell array resides a column vector.
% There is a row for every cell measurement in the column vector.
% * |nbins|, the number of bins within a histogram or if this is an array,
% the centers of histogram boxes. The default value is 100.
% * |outpath|, the directory where image files will be saved. By default
% this is the user's home in the MATLAB(R) path.
% * |report|, a boolean variable to indicate if a report should be
% generated. By default this is |false|.
% * |titles|, the titles that will be placed above each figure. There must
% be a title for each column vector in the |data| cell array.
%%% Outputs
% * |figh|, a cell containing the figure handles for each plot created by
% this function. This output is useful for tweaking these plots after the
% function call.
% * |axesh|, a cell containing the axes handles for each plot created by
% this function. This output is useful for tweaking these plots after the
% function call.
function [figh,axesh] = cpKsdensity(data,varargin)
%% Parse input
% The inputs into the function are parsed. If there were no inputs when the
% function was called a set of demonstrative data is imported and
% processed; this is useful and necessary for MATLAB-publishing this file.
defaultOutpath = userpath;
defaultNbins = 100;
defaultTitles = num2cell(1:length(data));
defaultTitles = cellfun(@num2str,defaultTitles,'UniformOutput', false);

p = inputParser;
addRequired(p,'data',@iscell);
addParamValue(p,'npoints',defaultNbins,@isinteger);
addParamValue(p,'outpath',defaultOutpath,@isstr);
addParamValue(p,'report',false,@islogical);
addParamValue(p,'titles',defaultTitles,@(x) length(x)==length(data));

parse(p,data,varargin{:});
outpath = p.Results.outpath;
if ~isdir(outpath)
    mkdir(outpath);
end
%% histogram
figh = cell(length(data),1); %initialize cell for speedy memory access
axesh = cell(length(data),1);
for i=1:length(data)
    figure;
    figh{i} = gcf;
    hist(data{i},p.Results.nbins);
    str = sprintf('number of cells');
    ylabel(str);
    title(p.Results.titles{i});
    axesh{i} = gca;
end
resizeFig4Publication(figh,'16:9');
%% Create a simple webpage to conveniently view the data
if p.Results.report
    imagenames = cell(size(p.Results.titles));
    for i=1:length(p.Results.titles)
        imagenames{i} = sprintf('cpHistogram_%s',p.Results.titles{i});
        imagenames{i} = regexprep(imagenames{i},'\s','');
        imagenames{i} = regexprep(imagenames{i},',','_');
    end
    htmlname = fullfile(outpath,'cpHistogram_output.html');
    generateReport(figh,imagenames,outpath,htmlname);
end