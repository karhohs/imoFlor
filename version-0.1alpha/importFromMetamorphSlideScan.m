%% importFromMetamorphSlideScan
% Converts a folder of TIFF images created via Metamorph into PNG images.
% A |.mat| file containing metadata about all the images is also created.
%
% PNG images are preferred to TIFF images, because the format is simpler
% and more standardized. Also, the PNG has better lossless compression for
% this type of image.
%
%   [] = importFromMetamorphSlideScan(inpath,outpath)
%
%%% Input
% * inpath: a char. The path to the folder that contains the orignal
% TIFF images from metamorph.
% * outpath: a char. The path where the new images will be created.
%
%%% Output:
% There is no direct argument output. Rather, a new folder will be created
% that contains PNG images and other files that will later be accessed by
% p53Cinema.
%
% The metadata collected are
% * image filename
% * time of acquisition
% * wavelength names (or the names of the fluorophores)
% * exposure times
% * x, y, and z stage position for each image
% * the maximum number of stage positions, wavelengths, timepoints, and z steps.
%%% Detailed Description
% When an image is created in Metamorph's Multi-Dimensional-Acquisition it
% is saved in the TIFF format. An inividual image is created for each stage
% position, wavelength, and timepoint. If z-positions are taken then the
% individual images are instead TIFF stacks.
%
% When metamorph saves a |.tif| the filename has the following format:
%
% |"user defined input"_w\d+"channel name"_s\d+_t\d+.tif|
%
% * '_w' is the wavelength
% * '_s' is the stage position
% * '_t' is the time point
%
% This function will retain a similiar format for the output images:
%
% |"user defined input"_s\d+_w\d+"channel name"_t\d+_z\d+.png|
%
% The TIFF format stores metadata within the image file. The function will
% extract a subset of this metadata such as the time the image was taken,
% the path to the image, and the exposure used for each channel. There is
% the option to store this information in a PNG comment, but I thought the
% data might be more conveniently accessed through MATLAB if it was stored
% inside a |.mat| file.
%
%%% Other Notes
% The last image created by Metamorph scanslide is a bird's eye view of the
% slide. This image is not included in the conversion to PNG.
function [] = importFromMetamorphSlideScan(inpath,outpath)
p = inputParser;
p.addRequired('inpath', @(x) ischar(x));
p.addRequired('outpath', @(x) ischar(x));
p.parse(inpath,outpath);
warning('off','MATLAB:tifflib:libraryWarning');
%%
% *Look to see if the outpath is an existing directory*
%
% If it is, then add a number to the end of it, so that previously existing
% data is not overwritten. This block of code is really overkill. It will
% keep increasing the number on the end of the folder name until it finds a
% number that doesn't yet exist.
if ~isdir(outpath)
    mkdir(outpath);
else
    dirCon = dir(outpath);
    if length(dirCon) ~= 2
        % If here, the directory contains other files or folders
        warning('outpathExists:importMetamorph','The outpath specified already exists and contains other files or folders, so a new outpath has been generated.');
        while true
            num = regexp(outpath,'_(\d+)$','tokens'); %check to see if number already exists on the end of the path
            if isempty(num)
                outpath = strcat(outpath,'_1');
                if isdir(outpath)
                    continue
                else
                    mkdir(outpath);
                    break
                end
            else
                num = str2double(num{1}{1});
                num = num+1;
                outpath = regexprep(outpath,'(\d+)$',num2str(num));
                if isdir(outpath)
                    continue
                else
                    mkdir(outpath);
                    break
                end
            end
        end
    end
end
%% Organizing the filenames
% The filenames are organized within a 3D (i,j,k) matrix where each
% dimension represents either time, position, or wavelength (i=time,
% j=position, k=wavelength). This organization facilitates the collating of
% these images into TIFF stacks.
%
%   FileNames(Position,Channel);
FileNames=cell(2048,16); %Assumes there will not be more than 2048 positions (over a week at images every 5 minutes), or more than 16 channels. If there are, change this number. It has been pre-allocated for speed.

%%
% Collect the directory contents
disp(['working in ', inpath]);
dirCon = dir(inpath);
[S,W]=deal(zeros(length(dirCon),1));
for i = 1:length(dirCon)
    if isempty(regexpi(dirCon(i).name,'_thumb')) && ...
            ~isempty(regexpi(dirCon(i).name,'(?<=(_s\d+).*)\.tif')) %Look at .tif images, but not "thumb" images
        S(i)=str2double(regexp(dirCon(i).name,'(?<=_s)\d+','match','once')); %Find the stage position number
        W(i)=str2double(regexp(dirCon(i).name,'(?<=_w)\d+','match','once')); %Find the wavelength number
        FileNames{S(i),W(i)}=dirCon(i).name; %Cleverly store the file name in a cell
    end
end
Sunique = unique(S)';
Sunique = Sunique(Sunique~=0);
Wunique = unique(W)';
Wunique = Wunique(Wunique~=0);
%%
% Remove the bird's eye view image from the file name list, assuming that
% this is the last position.
maxS = max(Sunique);
[FileNames{maxS,:}] = deal([]);
Sunique(Sunique==maxS) = [];
%%
% *Find the names of the wavelengths*
%
% The number of unique wavelengths was stored in the variable _Wunique_.
% The names of the wavelengths are extracted from the metadata stored in
% first image found for each unique wavelength number.
Wnames = cell(size(Wunique));
Wexp = cell(size(Wunique));
for i=1:length(Wunique)
    ind_findwavelength = find(W==Wunique(i),1,'first');
    filename_findwavelength = dirCon(ind_findwavelength).name;
    t = Tiff(fullfile(inpath,filename_findwavelength),'r');
    metadata = t.getTag('ImageDescription');
    t.close;
    fid = fopen('t3mp.xml','w');
    fprintf(fid,'%s',metadata);
    fclose(fid);
    xdoc = xmlread('t3mp.xml');
    node_root = xdoc.getDocumentElement;
    my_list = node_root.getElementsByTagName('prop');
    for j=0:my_list.getLength-1
        if my_list.item(j).hasAttributes
            if strcmp(my_list.item(j).getAttribute('id').toString.toCharArray','image-name')
                Wnames{i} = my_list.item(j).getAttribute('value').toString.toCharArray';
                %edit the name to remove unwanted characters and words
                Wnames{i} = regexprep(Wnames{i},'\s',''); %Remove all not(alphabetic, numeric, or underscore) characters
                Wnames{i} = regexprep(Wnames{i},'tocamera','','ignorecase'); %remove 'tocamera' if present b/c it is not informative
                Wnames{i} = regexprep(Wnames{i},'camera','','ignorecase'); %remove 'camera' if present b/c it is not informative
            end
            if strcmp(my_list.item(j).getAttribute('id').toString.toCharArray','Description')
                Wexp{i} = my_list.item(j).getAttribute('value').toString.toCharArray';
                %Find the exposure time
                Wexp{i} = regexp(Wexp{i},'Exposure: (\d+)','tokens');
                Wexp{i} = Wexp{i}{1}{1};
            end
        end
    end
    delete('t3mp.xml');
end
%%
% find the label, which was user defined in multi-dimensional analysis
labelText = regexp(dirCon(ind_findwavelength).name,'.+(?=_w)','match','once');
%%
% create the directory that will store the PNG images
pngpath = fullfile(outpath,'png');
mkdir(pngpath);
%% make the PNG images and metadata file
%
imageMetadata = struct;
imageMetadata.numbers.howManyS = max(Sunique);
imageMetadata.numbers.howManyW = max(Wunique);
imageMetadata.wavelengthInfo = vertcat(num2cell(Wunique),Wnames,Wexp);
imageMetadata.wavelengthInfo = transpose(imageMetadata.wavelengthInfo);
header = {'index','name','exposure (ms)'};
imageMetadata.wavelengthInfo = vertcat(header,imageMetadata.wavelengthInfo);
imageMetadata.filenames = cell(imageMetadata.numbers.howManyS, imageMetadata.numbers.howManyW);
imageMetadata.timeOfAcquisition = cell(size(imageMetadata.filenames)); %Units are in days
imageMetadata.stagePosition.x = zeros(imageMetadata.numbers.howManyS,1);
imageMetadata.stagePosition.y = zeros(imageMetadata.numbers.howManyS,1);
for i = Sunique
    for j = Wunique
        if ~isempty(FileNames{i,j}) %FileNames(Time,Position,Channel)
            %Load the image
            filename = fullfile(inpath,FileNames{i,j});
            t = Tiff(filename,'r');
            
            %% Create the PNG
            %Load the image
            I = t.read;
            %%
            %The Hamamatsu cameras for the closet scope and curtain
            %scope create images with 12-bit dynamic range.
            %However, the TIFF format that stores these images uses
            %a 16-bit format. Viewing a 12-bit image in a 16-bit
            %format on a computer monitor is compromised by the
            %scaling being done at 16-bit. To make viewing images
            %from the microscope easier on a computer monitor,
            %without any compression or loss of data, the 12-bit
            %data is shifted left 4-bits to become 16-bit data. In
            %addition, more information is kept following image
            %processing.
            numType = class(I);
            switch numType
                case 'double'
                    I = uint16(I);
                    I = bitshift(I,4);
                    I = double(I);
                case 'uint16'
                    I = bitshift(I,4);
            end
            filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d.png',labelText,i,j,Wnames{j},1,1);
            imwrite(I,fullfile(pngpath,filenamePNG),'png','bitdepth',16);
            imageMetadata.filenames{i,j} = filenamePNG;
            %% Pull info from the image description in the TIFF
            %
            metadata = t.getTag('ImageDescription');
            fid = fopen('t3mp.xml','w');
            fprintf(fid,'%s',metadata);
            fclose(fid);
            xdoc = xmlread('t3mp.xml');
            node_root = xdoc.getDocumentElement;
            my_list = node_root.getElementsByTagName('prop');
            for g=0:my_list.getLength-1
                if my_list.item(g).hasAttributes
                    if strcmp(my_list.item(g).getAttribute('id').toString.toCharArray','acquisition-time-local')
                        timetext = my_list.item(g).getAttribute('value').toString.toCharArray';
                        myTokens = regexpi(timetext,'(\d{4})(\d{2})(\d{2}) (\d+):(\d+):(\d+\.?\d*)','tokens');
                        imageMetadata.timeOfAcquisition{i,j} = datenum(str2double(myTokens{1}{1}),str2double(myTokens{1}{2}),str2double(myTokens{1}{3}),str2double(myTokens{1}{4}),str2double(myTokens{1}{5}),str2double(myTokens{1}{6}));
                    elseif strcmp(my_list.item(g).getAttribute('id').toString.toCharArray','stage-position-x')
                        imageMetadata.stagePosition.x(i) = str2double(my_list.item(g).getAttribute('value').toString.toCharArray');
                    elseif strcmp(my_list.item(g).getAttribute('id').toString.toCharArray','stage-position-y')
                        imageMetadata.stagePosition.y(i) = str2double(my_list.item(g).getAttribute('value').toString.toCharArray');
                    end
                end
            end
            delete('t3mp.xml');
            if ~t.lastDirectory
                t.nextDirectory;
            end
        end
        t.close;
    end
end
save(fullfile(outpath,'imageMetadata'),'imageMetadata');
%%
% Create a CSV file for use with Cell Profiler
cpCSVmaker(outpath);
%% Create or append a log file
%
fid = fopen(fullfile(outpath,'log.txt'),'a+');
fprintf(fid,'%s: importFromMetamorphSlideScan: TIFF images from the folder ''%s'' were converted to PNG images, and along with metadata, added to the folder ''%s''.\r\n\r\n',date,inpath,outpath);
fclose(fid);