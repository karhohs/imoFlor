%% CellProfiler call from the DOS command line Template
% When using CellProfiler to analyze several different sets of images it is
% convenient to repeatedly call CellProfiler from the command line. MATLAB
% can run a command from DOS (or UNIX in a Mac). This script is template.
% Just add the appropriate paths to the variables below. Make sure each
% variable has the same number of elements, so if a pipeline is used
% mulitple times, it should appear in the _pipelinepath_ variable multiple
% times.
%
% * pipelinepath: the path to each CellProfiler pipeline variable
% * inpath: the path to the folder that contains the CSV file
% * outpath: self-explanatory
pipelinepath = {'',...
    ''};
inpath = {'',...
    ''};
outpath = {'',...
    ''};

%%
%
for i=1:length(pipelinepath)
str = sprintf('CellProfiler.exe -c -r -i %s -o %s -p %s',inpath{i},outpath{i},pipelinepath{i});
dos(str);
end