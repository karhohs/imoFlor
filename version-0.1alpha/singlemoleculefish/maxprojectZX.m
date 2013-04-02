function [zx] = maxprojectZX(IM)
zx = max(IM,[],1);
zx = squeeze(zx);
zx = transpose(zx);
zx = flipud(zx);
