%% cellularGPS_TriangleMethod
% Suppose there the 1D data is primarily represented by a large bell curve,
% but to the left of the curve is an overlapping distribution of noise,
% which has only a fraction of the data within the large bell curve. This
% function will identify the mean of the large bell curve and then explore
% for a point of inflection to the left of the mean.
%
%   [trithresh] = cellularGPS_TriangleMethod(I)
%
%%% Input
% * I: A grayscale image.
%
%%% Output:
% * trithresh: the threshold value determined from the image.
%
%%% Detailed Description
% There is no detailed description.
%
%%% Other Notes
%
function [bblThresh] = pixata_bigBellLeftThreshold(I, varargin)

p = inputParser;
addRequired(p,'I',@isnumeric);
addOptional(p,'outlierQuantile',0.3,@(x) x<=1 & x>=0);
parse(p,I,varargin{:})
outlierQuantile = p.Results.outlierQuantile;
%%%
% Create the histogram. The number of bins will be the sqrt the number of
% datapoints. |sqrt(numel(A))*2/3| is a heuristic measure. If the number of
% datapoints is 10, then the number of bins will be 2.
A=double(reshape(I,[],1));
[n,xout]=hist(A,round(sqrt(numel(A))*2/3));
%%%
% find the mean of the big
lbc = A(A <= quantile(A, 1-outlierQuantile) & A >= quantile(A, outlierQuantile));
muLbc = mean(lbc);
muInd = find(xout < muLbc,1,'last');
if muInd <= 4
    error('pixata_bblThresh:notEnoughData','There was not enough data or the shape of the histogram was not appropriate for this algorithm');
end
nSmooth = smooth(n,round(sqrt(muInd)));
nDiff = smooth(diff(nSmooth),round(sqrt(muInd)));
%%%
%
if muInd == 1
    bblThresh = n(1);
    warning('bblThresh:weird','The threshold was the leftmost value, which is strange. Make sure the data resembles a big bell curve with noise to the left.');
    return
end
%%%
% Going from left to right...
%
% # wait for the curve to increase for two consecutive steps, then
% # wait for the curve to decrease for two consecutive steps
% # the step of the first decrease is the threshold
upcounter = 0;
downcounter = 0;
value2 = nDiff(muInd);
for i = muInd:-1:2
    value1 = nDiff(i);
    if upcounter ~= 2
        if value1 > value2
            upcounter = upcounter+1;
        else
            upcounter = 0;
        end
        value2 = value1;
        continue
    end
    if downcounter ~= 2
        if value1 < value2
            downcounter = downcounter + 1;
        else
            downcounter = 0;
        end
        value2 = value1;
        continue
    end
    break
end
bblThresh = xout(i);
end