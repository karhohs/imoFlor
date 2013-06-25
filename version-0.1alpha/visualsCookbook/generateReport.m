%% generateReport
%
%% Inputs
% * |figh|, a required variable. |data| is a cell array containing time
% series data. In each position of the cell array resides a column vector.
% There is a row for every cell measurement in the column vector.
% * |imagenames|, the number of bins within a histogram or if this is an
% array, the centers of histogram boxes. The default value is 100.
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
addRequired(p,'figh',@(x) iscell(x)||(strcmp('figure',get(x,'type'))));
addRequired(p,'imagenames',@(x) length(x)==length(figh));
addRequired(p,'outpath',@ischar);
addRequired(p,'htmlname',@ischar);
addParamValue(p,'rez',300,@(x) mod(x,1)==0); %resolution (dpi) of final graphic
parse(p,figh,imagenames,outpath,htmlname,varargin{:});
if ~iscell(figh)
    myfigh = figh;
    figh = cell(1,1);
    figh{1} = myfigh;
elseif any(cellfun(@(x) ~strcmp('figure',get(x,'type')),figh))  
    error('reszFig4Pub:argChk','The cell array of figure handles holds an object that is not a figure handle.');
end
if ~isdir(outpath)
    mkdir(outpath);
end
%% Save image files
for i=1:length(figh)
    print(figh{i},fullfile(outpath,imagenames{i}),'-dpng',['-r',num2str(p.Results.rez)],'-opengl') %save file
    print(figh{i},fullfile(outpath,imagenames{i}),'-dpdf','-r0');
end

imagenamespng = cell(size(p.Results.imagenames));
for i=1:length(imagenamespng)
    imagenamespng{i} = sprintf('%s.png',imagenames{i});
end
figures2HTML(imagenamespng,htmlname);