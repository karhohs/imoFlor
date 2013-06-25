%% cpCDF
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
% * |figh|, a struct containing the figure handles for each plot created by
% this function. This output is useful for tweaking these plots after the
% function call.
function [figh] = cpCDF(data,varargin)
%% Parse input
% The inputs into the function are parsed. If there were no inputs when the
% function was called a set of demonstrative data is imported and
% processed; this is useful and necessary for MATLAB-publishing this file.
defaultOutpath = userpath;
defaultTitles = num2cell(1:length(data));
defaultTitles = cellfun(@num2str,defaultTitles,'UniformOutput', false);

p = inputParser;
addRequired(p,'data',@iscell);
addParamValue(p,'outpath',defaultOutpath,@isstr);
addParamValue(p,'report',false,@islogical);
addParamValue(p,'titles',defaultTitles,@(x) length(x)==length(data));
parse(p,data,varargin{:});
%% CDF
figh = cell(length(data),1); %initialize struct for speedy memory access
for i=1:length(data)
    figure;
    figh{i} = gcf;
    ecdf(data{i});
    pd = fitdist(data{i},'Normal');
    x = linspace(min(data{i}),max(data{i}),100);
    y = cdf(pd,x);
    hold on;
    plot(x,y,'r--');
    str = sprintf('probability a cell has <= x');
    ylabel(str);
    [h,p2] = kstest(data{i},'CDF',pd);
    hold off;
end
resizeFig4Publication(figh,'16:9');
%% Create a simple webpage to conveniently view the data
if p.Results.report
    imagenames = cell(size(p.Results.titles));
    for i=1:length(p.Results.titles)
        imagenames{i} = sprintf('cpCDF_%s',p.Results.titles{i});
    end
    htmlname = fullfile(p.Results.outpath,'cpCDF_output.html');
    generateReport(figh,imagenames,p.Results.outpath,htmlname);
end