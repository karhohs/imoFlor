%% resizeFig4Publication
%
%% Inputs
% * |figh|, 
% * |xydimensions|, 
%%% Outputs
% In addition to the images created by this function a web page is created
% for easy viewing.
function [] = resizeFig4Publication(figh,xydimensions,varargin)
p = inputParser;
addRequired(p,'figh',@(x) iscell(x)||(strcmp('figure',get(x,'type'))));
addRequired(p,'xydimensions',@(x) (~any(size(x)~=[1,2])||ischar(x)));
parse(p,figh,xydimensions,varargin{:});
if ~iscell(figh)
    myfigh = figh;
    figh = cell(1,1);
    figh{1} = myfigh;
elseif any(cellfun(@(x) ~strcmp('figure',get(x,'type')),figh))  
    error('reszFig4Pub:argChk','The cell array of figure handles holds an object that is not a figure handle.');
end
PaperSize = [8.5 11]; % The size of a piece of paper.
if ischar(xydimensions)
    switch xydimensions
        case '16:9'
            %16:9
            axesPositionSize = [3 1.6875];
        case '4:3'
            %4:3
            axesPositionSize = [3 2.25];
        case '1:1'
            %square
            axesPositionSize = [2.5 2.5];
        case '3:2'
            %3:2
            axesPositionSize = [3 2];
    end
else
    axesPositionSize = xydimensions;
end
%%
% get the ppi for the monitor
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','inches');
Inch_SS = get(0,'screensize');
ppi = Pix_SS./Inch_SS;
ppi = ppi(4);

for i=1:length(figh)
    f = figh{i};
    h = findall(f,'type','axes','-not','Tag','legend','-not','Tag','Colorbar');
    h=h(1); %use the first data axes for resizing purposes
    %%
    % get the size of the figure (pixels)
    fPosition = get(f,'Position');
    %%
    % get the outer-position and position of the axes (normalized units)
    hOuterPosition = get(h,'OuterPosition');
    hPosition = get(h,'Position');
    %%
    % Calculate the normalized units per inch in both x and y direction
    npix = hOuterPosition(3)*ppi/fPosition(3);
    npiy = hOuterPosition(4)*ppi/fPosition(4);
    %%
    % Alter the axes size to reflect the desired dimensions of the figure
    hPosition(3) = axesPositionSize(1)*npix;
    hPosition(4) = axesPositionSize(2)*npiy;
    set(h,'Position',hPosition);
    %%
    % Adjust the figure size to encompass the resized axes
    hOuterPosition = get(h,'OuterPosition'); %The outerposition has automatically been redefined
    hOuterPosition(1:2) = [0,0]; %Make sure the origin is set to the bottom left of the figure
    set(h,'OuterPosition',hOuterPosition);
    set(h,'Units','inches'); %break the automatic resizing between figure and axes
    fPosition(3) = hOuterPosition(3)/npix*ppi;
    fPosition(4) = hOuterPosition(4)/npiy*ppi;
    set(f,'Position',fPosition);
    figPositionSize = get(f,'Position');
    figPositionSize = [figPositionSize(3), figPositionSize(4)]/ppi;
    PaperPosition = [(PaperSize(1)-figPositionSize(1))/2,...
        (PaperSize(2)-figPositionSize(2))/2,...
        figPositionSize(1), figPositionSize(2)];
    set(f,'PaperUnits','inches','PaperPosition',PaperPosition);
end
