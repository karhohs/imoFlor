%% Create Quantified Western Figures
%
%% Import Data
%
[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
p53 = dataset('File',fullfile(mfilepath,'p53quantifiedwestern.csv'),'Delimiter',',');
p53V = dataset('File',fullfile(mfilepath,'p53VenusQuantifiedwestern.csv'),'Delimiter',',');

%% Plot p53 along with p53-Venus with time axis
%
p = plot(p53.time,p53.normalized_to_actin_fold_change);
h = gca;
f = gcf;
set(h,'FontSize',12,'FontName','Arial'); %all fonts in axes
% plot p53-Venus as markers
hold on
p2 = plot(p53V.time,p53V.normalized_to_actin_fold_change,'d');
set(p2,'MarkerSize',6);
hold off

set(h,'box','off');
% line weight and color
set(p,'LineWidth',2,'Color','k');
set(p2,'LineWidth',2,'Color','k');

% axis labels and title
title(h,'p53 Dynamics, MCF7');
xlabel(h,'hours post 10Gy');
str = sprintf('fold change\n(relative to 2h timepoint)');
ylabel(h,str);

% axis tick marks and limits
xlim(h,[0 72]);
set(h,'XTick',[0 2 4 6 8 24 48 72]);
%set(gca,'XTickLabel',{'1N','2N'});
ylim(h,[0 1.1]);
set(h,'YTick',[0,0.25,0.5,0.75,1]);
%set(gca,'YTickLabel',{'1N','2N'});

% create legend
l = legend([p,p2],'p53','p53-Venus','Location','SouthEast');
set(l,'FontSize',10,'FontName','Arial'); %all fonts in axes
legend(h,'boxoff');
%% Shape the figure to the desired dimensions (in inches)
% # height = 1.6875 inches
% # width = 3 inches
%
% get the ppi for the monitor
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','inches');
Inch_SS = get(0,'screensize');
ppi = Pix_SS./Inch_SS;
ppi = ppi(4);
%%
% get the size of the figure (pixels)
fPosition = get(f,'Position');
%%
% get the outer-position and position of the axes (normalized units)
hOuterPosition = get(h,'OuterPosition');
hPosition = get(h,'Position');
%%
% Define the desired axes size (the space with the actual data)
axesPositionSize = [3 1.6875]; % These are the values to play with
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
PaperSize = [8.5 11]; % The size of a piece of paper.
figPositionSize = get(f,'Position');
figPositionSize = [figPositionSize(3), figPositionSize(4)]/ppi;
PaperPosition = [(PaperSize(1)-figPositionSize(1))/2,...
    (PaperSize(2)-figPositionSize(2))/2,... 
    figPositionSize(1), figPositionSize(2)];
set(f,'PaperUnits','inches','PaperPosition',PaperPosition);
print(f,fullfile(mfilepath,'p53quantifiedwestern1.pdf'),'-dpdf','-r0');
