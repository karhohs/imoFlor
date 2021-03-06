%% cp2DDensityScatter
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
function [figh,sctrgrp] = cpDensityScatter(datax,datay,varargin)
%% Parse input
% The inputs into the function are parsed. If there were no inputs when the
% function was called a set of demonstrative data is imported and
% processed; this is useful and necessary for MATLAB-publishing this file.
defaultNbins = round(sqrt(length(datax)));
defaultDataxLimits = [min(datax),max(datax)];
defaultDatayLimits = [min(datay),max(datay)];

p = inputParser;
addRequired(p,'datax',@isnumeric);
addRequired(p,'datay',@isnumeric);
addParamValue(p,'nbins',defaultNbins,@isinteger);
addParamValue(p,'dataxLimits',defaultDataxLimits,@isstr);
addParamValue(p,'datayLimits',defaultDatayLimits,@islogical);

if length(datax)~=length(datay)
    error('not:good','the input data are not of the same length');
end
parse(p,datax,datay,varargin{:});
%% cpDensityScatter
figure;
figh = gcf;
%guess a good density measurement
numberOfbins = p.Results.nbins;
nbins1 = linspace(p.Results.dataxLimits(1),p.Results.dataxLimits(2),numberOfbins);
nbins2 = linspace(p.Results.datayLimits(1),p.Results.datayLimits(2),numberOfbins);
[n,c] = hist3([datax,datay],{nbins1 nbins2});
X = zeros(length(c{1})*length(c{2}),2);
V = zeros(length(c{1})*length(c{2}),1);
for i = 1:length(c{1})
    for j = 1:length(c{2})
        X((i-1)*length(c{2})+j,1) = c{1}(i);
        X((i-1)*length(c{2})+j,2) = c{2}(j);
        V((i-1)*length(c{2})+j) = n(i,j);
    end
end
%color the points using a log2 scale
V = log(V)/log(2);
F = scatteredInterpolant(X,V);
Vq = F(datax,datay);
%Sort data so that it is plotted in ascending order
xyv = [datax,datay,Vq];
xyv = sortrows(xyv,3);
xyv = flipud(xyv);
datax = xyv(:,1);
datay = xyv(:,2);
Vq = xyv(:,3);
sctrgrp = scatter(datax,datay,10,Vq,'o','fill');
%set(h,'SizeData',10);
title('a wild scatter plot has appeared!');
