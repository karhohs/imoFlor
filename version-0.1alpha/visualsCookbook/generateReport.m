%% generateReport
%
%% Inputs
% * |figh|, a required variable. |data| is a cell array containing time
% series data. In each position of the cell array resides a column vector.
% There is a row for every cell measurement in the column vector.
% * |imagenames|, the number of bins within a histogram or if this is an array,
% the centers of histogram boxes. The default value is 100.
% * |outpath|, the directory where image files will be saved. By default
% this is the user's home in the MATLAB(R) path.
% * |report|, a boolean variable to indicate if a report should be
% generated. By default this is |false|.
% * |titles|, the titles that will be placed above each figure. There must
% be a title for each column vector in the |data| cell array.
%%% Outputs
% In addition to the images created by this function a web page is created
% for easy viewing.
function [] = generateReport(figh,imagenames,outpath,htmlname,varargin)
%% Parse input
% The inputs into the function are parsed. If there were no inputs when the
% function was called a set of demonstrative data is imported and
% processed; this is useful and necessary for MATLAB-publishing this file.
p = inputParser;
addRequired(p,'figh',@iscell);
addRequired(p,'imagenames',@(x) length(x)==length(figh));
addRequired(p,'outpath',@isstr);
addRequired(p,'htmlname',@isstr);
addParamValue(p,'rez',120,@(x) mod(x,1)==0); %resolution (dpi) of final graphic
addParamValue(p,'aspectRatio',1,@(x) any(x==[1,2,3,4]));
parse(p,figh,imagenames,outpath,htmlname,varargin{:});
if ~isdir(outpath)
    mkdir(outpath);
end
switch p.Results.aspectRatio
    case 1
        %16:9
        PaperSize = [8.5 11];
        PaperPosition = [0.25 3.25 8 4.5];
    case 2
        %4:3
        PaperSize = [8.5 11];
        PaperPosition = [0.25 2.5 8 6];
    case 3
        %square
        PaperSize = [8.5 11];
        PaperPosition = [0.25 1.5 8 8];
    case 4
        %3:2
        PaperSize = [8.5 11];
        PaperPosition = [0.5 3 7.5 5];
end
%% Save image files
for i=1:length(figh)
    set(figh{i},'PaperSize',PaperSize);
    set(figh{i},'PaperUnits','inches','PaperPosition',PaperPosition);
    print(figh{i},fullfile(outpath,imagenames{i}),'-dpng',['-r',num2str(p.Results.rez)],'-opengl') %save file
    print(figh{i},fullfile(outpath,imagenames{i}),'-dpdf');
end

imagenamespng = cell(size(p.Results.imagenames));
for i=1:length(imagenamespng)
    imagenamespng{i} = sprintf('%s.png',imagenames{i});
end
figures2HTML(imagenamespng,htmlname);