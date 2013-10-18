%% A Cookbook of Data Visualization for Immunofluorescence
% The goal of the cookbook is to provide functions/templates for the
% visualization of data from immunofluorescence experiments. Often the same type of graphic is desired for varying timepoints and conditions. The functions
% in the cookbook are written with the intent to abolish the need for "copy
% and paste" coding of these graphics and to simplify the changing of
% parameters common to all the graphs.
%% Load the CSV data created by CellProfiler(R)
[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
outpath = fullfile(mfilepath,'demo_output');
datapath = fullfile(mfilepath,'demo_data');
myfiles = {'DefaultOUT_Nuclei_1.csv','DefaultOUT_Nuclei_2.csv','DefaultOUT_Nuclei_3.csv'};
alldata = cell(1,length(myfiles));
for i = 1:length(myfiles)
    alldata{i} = dataset('File',fullfile(datapath,myfiles{i}),'Delimiter',',');
end
%% cpCDF
%
myfiles = {'DefaultOUT_Nuclei_1.csv','DefaultOUT_Nuclei_2.csv','DefaultOUT_Nuclei_3.csv'};
data = cell(1,length(myfiles));
for i = 1:length(myfiles)
    mydata = alldata{i};
    data{i} = mydata.Intensity_MeanIntensity_TexasRed;
end
cpCDF(data,'outpath',outpath,'report',true);
clear('options_doc');
options_doc.codeToEvaluate = 'cpCDF(data,''outpath'',outpath,''report'',true)';
options_doc.maxOutputLines = 0;
publish(fullfile(mfilepath,'cpCDF.m'),options_doc);
%% cpHistogram
%
myfiles = {'DefaultOUT_Nuclei_1.csv','DefaultOUT_Nuclei_2.csv','DefaultOUT_Nuclei_3.csv'};
data = cell(1,3*length(myfiles));
for i = 1:length(myfiles)
    mydata = alldata{i};
    data{i} = mydata.Intensity_MeanIntensity_TexasRed;
end
for i = 1:length(myfiles)
    mydata = alldata{i};
    data{3+i} = mydata.Intensity_MeanIntensity_FITC;
end
for i = 1:length(myfiles)
    mydata = alldata{i};
    data{6+i} = mydata.Intensity_IntegratedIntensity_DAPI;
end
clear('options_doc');
options_doc.codeToEvaluate = 'cpHistogram(data,''outpath'',outpath,''report'',true)';
options_doc.maxOutputLines = 0;
publish(fullfile(mfilepath,'cpHistogram.m'),options_doc);
%% cpGrowthCurve
%
data = cell(1,length(myfiles));
for i = 1:length(myfiles)
    mydata = alldata{i};
    myImageNumber = unique(mydata.ImageNumber);
    myNucleiPerImage = zeros(size(myImageNumber));
    for j = 1:length(myImageNumber)
        myNucleiPerImage(j) = max(mydata.ObjectNumber(mydata.ImageNumber==myImageNumber(j)));
    end
    data{i} = myNucleiPerImage;
end
clear('options_doc');
options_doc.codeToEvaluate = 'cpGrowthCurve(data,''outpath'',outpath,''report'',true)';
options_doc.maxOutputLines = 0;
publish(fullfile(mfilepath,'cpGrowthCurve.m'),options_doc);

%% cp2DHistogram
%
datax = cell(1,length(myfiles));
datay = cell(1,length(myfiles));
for i = 1:length(myfiles)
    mydata = alldata{i};
    datax{i} = mydata.Intensity_IntegratedIntensity_DAPI;
end
for i = 1:length(myfiles)
    mydata = alldata{i};
    datay{i} = mydata.Intensity_MeanIntensity_TexasRed;
end
clear('options_doc');
options_doc.codeToEvaluate = 'cp2DHistogram(datax,datay,''outpath'',outpath,''report'',true)';
options_doc.maxOutputLines = 0;
publish(fullfile(mfilepath,'cp2DHistogram.m'),options_doc);
%% cp2DensityScatter
%
datax = cell(1,length(myfiles));
datay = cell(1,length(myfiles));
for i = 1:length(myfiles)
    mydata = alldata{i};
    datax{i} = mydata.Intensity_IntegratedIntensity_DAPI;
end
for i = 1:length(myfiles)
    mydata = alldata{i};
    datay{i} = mydata.Intensity_MeanIntensity_TexasRed;
end
clear('options_doc');
options_doc.codeToEvaluate = 'cp2DensityScatter(datax,datay,''outpath'',outpath,''report'',true)';
options_doc.maxOutputLines = 0;
publish(fullfile(mfilepath,'cp2DensityScatter.m'),options_doc);
%% cpKsdensity
%
myfiles = {'DefaultOUT_Nuclei_1.csv','DefaultOUT_Nuclei_2.csv','DefaultOUT_Nuclei_3.csv'};
data = cell(1,3*length(myfiles));
for i = 1:length(myfiles)
    mydata = alldata{i};
    data{i} = mydata.Intensity_MeanIntensity_TexasRed;
end
for i = 1:length(myfiles)
    mydata = alldata{i};
    data{3+i} = mydata.Intensity_MeanIntensity_FITC;
end
for i = 1:length(myfiles)
    mydata = alldata{i};
    data{6+i} = mydata.Intensity_IntegratedIntensity_DAPI;
end
clear('options_doc');
options_doc.codeToEvaluate = 'cpKsdensity(data,''outpath'',outpath,''asLog'',true,''report'',true)';
options_doc.maxOutputLines = 0;
publish(fullfile(mfilepath,'cpKsdensity.m'),options_doc);