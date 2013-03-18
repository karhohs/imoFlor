%% IFcartography
% Stiches the individual images captured while scanning a slide into a
% birds-eye-view super image. The image will be compressed 8 fold along
% the x and y dimensions, so the final image size will be 64 times
% smaller than the combined size of all images; that is 1GB of data will be
% reduced to 16MB.
%
%   [] = IFcartography(path)
%
%%% Input
% * path: a char. The path where the image metadata is located.
%
%%% Output:
% There is no direct argument output. An global map of the scanned area
% will be created for each channel. These maps will remain quantitative.
%
%%% Detailed Description
%
%
%%% Other Notes
%
function [] = IFcartography(path)
%% Create a grid from image x and y positions
% It is assumed that images captured can be tiled to form a rectangle. The
% x and y positions are sorted by rows, then the columns are sorted.
load(fullfile(path,'imageMetadata.mat'));

disp('ok');