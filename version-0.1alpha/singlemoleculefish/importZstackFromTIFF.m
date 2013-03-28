function [IM] = importZstackFromTIFF(path)
str = regexpi(path,'\.tif$','match');
if ~isempty(str)
    str = lower(str{1});
switch str
    case '.tif'
        hwbar = waitbar(0, 'Please wait... loading z-stack');
        set(hwbar, 'WindowStyle', 'modal');
        info = imfinfo(path,'tif');
        s = [info(1).Height, info(1).Width, length(info)];
        IM = zeros(s);
        t = Tiff(path,'r');
        if s(3) > 1
            for k=1:s(3)-1
                IM(:,:,k) = double(t.read);
                t.nextDirectory;
                waitbar(k/s(3), hwbar);
            end
        end
        %one last time without t.nextDirectory
        IM (:,:,s(3)) = double(t.read);
        waitbar(1, hwbar);
        t.close;
        delete(hwbar);
    otherwise
        warning('importZ:notTIFF','The given path does not lead to a TIFF image.');
        IM = [];
end
else
    warning('importZ:notTIFF','The given path does not lead to a TIFF image.');
        IM = [];
end
