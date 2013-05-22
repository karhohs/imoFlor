[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
outpath = fullfile(mfilepath,'demo_output');
datapath = fullfile(mfilepath,'demo_data');
        myfiles = {'DefaultOUT_Nuclei_1.csv','DefaultOUT_Nuclei_2.csv','DefaultOUT_Nuclei_3.csv'};
        alldata = cell(1,length(myfiles));
        for i = 1:length(myfiles)
            alldata{i} = dataset('XLSFile',fullfile(datapath,myfiles{i}));
        end


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