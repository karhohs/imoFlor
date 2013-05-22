%% cpGrowthCurve
%
%% Inputs
% * |data|, a required variable. |data| is a cell array containing time
% series data. In each position of the cell array resides a column vector.
% There is a row for each image in the column vector and the number in each
% row represents the number of cells segmented in that image.
% * |outpath|, the directory where image files will be saved. By default
% this is the user's home in the MATLAB(R) path.
% * |report|, a boolean variable to indicate if a report should be
% generated. By default this is |false|.
%%% Outputs
% * |figh|, a struct containing the figure handles for each plot created by
% this function. This output is useful for tweaking these plots after the
% function call.
function [figh] = cpGrowthCurve(data,varargin)
%% Parse input
% The inputs into the function are parsed.
defaultOutpath = userpath;
p = inputParser;
addRequired(p,'data',@iscell);
addParamValue(p,'outpath',defaultOutpath,@isstr);
addParamValue(p,'report',false,@islogical);
parse(p,data,varargin{:});

outpath = p.Results.outpath;
if ~isdir(outpath)
    mkdir(outpath);
end
%% boxplot
numImages = cellfun(@length,data);
maxNumImages = max(numImages);
myBoxPlotData = NaN(maxNumImages,length(data));
for i = 1:length(data)
    myBoxPlotData(1:numImages(i),i) = data{i};
end
boxplot(myBoxPlotData,'notch','on');
figh{1} = gcf;
str = sprintf('cell density\n(nuclei per image)');
ylabel(str);
%%
meancelldensity = cellfun(@mean,data)./cellfun(@length,data);
%% Create a simple webpage to conveniently view the data
if p.Results.report
    imagenames = {'cpGrowthCurve_boxplot'};
    htmlname = fullfile(outpath,'cpGrowthCurve_output.html');
    generateReport(figh,imagenames,outpath,htmlname);
end
