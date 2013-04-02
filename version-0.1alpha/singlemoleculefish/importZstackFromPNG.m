function [IM,mysize] = importZstackFromPNG(imageMetadata,s,w,path)
fnames = squeeze(imageMetadata.filenames(s,w,1,:)); %only the first time point

% remove cells with no filenames
fnames(cellfun(@isempty,fnames)) = [];

% find the size of the stack
myinfo = imfinfo(fullfile(path,'png',fnames{1}));
mysize = [myinfo.Height, myinfo.Width, length(fnames)];

% import the image
IM = zeros(mysize);
hwbar = waitbar(0, 'Please wait... loading z-stack');
set(hwbar, 'WindowStyle', 'modal');
for i=1:length(fnames)
    IM(:,:,i) = imread(fullfile(path,'png',fnames{i}),'PNG');
    waitbar(i/mysize(3), hwbar);
end
delete(hwbar);

