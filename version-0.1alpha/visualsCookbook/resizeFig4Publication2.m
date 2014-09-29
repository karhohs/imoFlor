%% resizeFig4Publication2
%
%% Inputs
% * |figh|, 
% * |xydimensions|, 
%%% Outputs
% In addition to the images created by this function a web page is created
% for easy viewing.
function [] = resizeFig4Publication2(figh,xydimensions,varargin)
p = inputParser;
addRequired(p,'figh',@(x) iscell(x)||(strcmp('figure',get(x,'type'))));
addRequired(p,'xydimensions',@(x) (~any(size(x)~=[1,2])||ischar(x)));
parse(p,figh,xydimensions,varargin{:});
if ~iscell(figh)
    myfigh = figh;
    figh = cell(1,1);
    figh{1} = myfigh;
elseif any(cellfun(@(x) ~strcmp('figure',get(x,'type')),figh))  
    error('reszFig4Pub2:argChk','The cell array of figure handles holds an object that is not a figure handle.');
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
    %%
    % get the size of the figure (pixels)
    fPosition = get(f,'Position');
    %%
    % get the outer-position and position of the axes (normalized units)
    hOuterPosition1 = get(h(1),'OuterPosition');
    hPosition1 = get(h(1),'Position');
    %%
    % Calculate the normalized units per inch in both x and y direction
    npix = hOuterPosition1(3)*ppi/fPosition(3);
    npiy = hOuterPosition1(4)*ppi/fPosition(4);
    %%
    % Adjust the figure size to encompass the resized axes
    hOuterPosition1 = get(h(1),'OuterPosition'); %The outerposition has automatically been redefined
    hOuterPosition2 = get(h(2),'OuterPosition');
    x_offset = min([hOuterPosition1(1),hOuterPosition2(1)]);
    y_offset = min([hOuterPosition1(2),hOuterPosition2(2)]);
    hOuterPosition1 = hOuterPosition1-[x_offset,y_offset,0,0];
    hOuterPosition2 = hOuterPosition2-[x_offset,y_offset,0,0];
    set(h(1),'OuterPosition',hOuterPosition1);
    set(h(2),'OuterPosition',hOuterPosition2);
    %%
    % Alter the axes size to reflect the desired dimensions of the figure
    hPosition1 = get(h(1),'Position');
    hPosition1(3) = axesPositionSize(1)*npix;
    hPosition1(4) = axesPositionSize(2)*npiy;
    set(h(1),'Position',hPosition1);
    set(h(2),'Position',hPosition1);
    
    hOuterPosition1 = get(h(1),'OuterPosition'); %The outerposition has automatically been redefined
    hOuterPosition2 = get(h(2),'OuterPosition');
    x_offset = min([hOuterPosition1(1),hOuterPosition2(1)]);
    y_offset = min([hOuterPosition1(2),hOuterPosition2(2)]);
    width = max([hOuterPosition1(3)+hOuterPosition1(1),hOuterPosition2(3)+hOuterPosition2(1)])+x_offset;
    height = max([hOuterPosition1(4)+hOuterPosition1(2),hOuterPosition2(4)+hOuterPosition2(2)])+y_offset;
    hOuterPosition = [x_offset,y_offset,width,height];
    
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
    set(h,'Units','normalized'); %re-establish the automatic resizing between figure and axes
end
