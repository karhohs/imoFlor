function [data] = loadDemoData(str)
[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
switch str
    case 'cpGrowthCurve'
        myfiles = {'DefaultOUT_Nuclei_1.csv','DefaultOUT_Nuclei_2.csv','DefaultOUT_Nuclei_3.csv'};
        data = cell(1,length(myfiles));
        for i = 1:length(myfiles)
            mydata = dataset('XLSFile',fullfile(mfilepath,myfiles{i}));
            myImageNumber = unique(mydata.ImageNumber);
            myNucleiPerImage = zeros(size(myImageNumber));
            for j = 1:length(myImageNumber)
                myNucleiPerImage(j) = max(mydata.ObjectNumber(mydata.ImageNumber==myImageNumber(j)));
            end
            data{i} = myNucleiPerImage;
        end
    case 'cpHistogram'
        myfiles = {'DefaultOUT_Nuclei_1.csv','DefaultOUT_Nuclei_2.csv','DefaultOUT_Nuclei_3.csv'};
        data = cell(1,3*length(myfiles));
        for i = 1:length(myfiles)
            mydata = dataset('XLSFile',fullfile(mfilepath,myfiles{i}));
            data{i} = mydata.Intensity_MeanIntensity_TexasRed;
        end
        for i = 1:length(myfiles)
            mydata = dataset('XLSFile',fullfile(mfilepath,myfiles{i}));
            data{3+i} = mydata.Intensity_MeanIntensity_FITC;
        end
        for i = 1:length(myfiles)
            mydata = dataset('XLSFile',fullfile(mfilepath,myfiles{i}));
            data{6+i} = mydata.Intensity_IntegratedIntensity_DAPI;
        end
    case 'importNucleiData'
        myfiles = {'DefaultOUT_Nuclei_1.csv','DefaultOUT_Nuclei_2.csv','DefaultOUT_Nuclei_3.csv'};
        data = cell(1,length(myfiles));
        for i = 1:length(myfiles)
            data{i} = dataset('XLSFile',fullfile(mfilepath,myfiles{i}));
        end
    otherwise
        data = {};
        disp('unrecognized data request');
end
