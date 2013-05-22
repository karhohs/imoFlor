function [] = figures2HTML(imagenames,htmlname)
[~,name,~] = fileparts(htmlname);
fid=fopen(htmlname,'w'); %create the file
fprintf(fid,'<!DOCTYPE html>\r\n<head>\r\n<title>%s</title>\r\n</head>\r\n<body>\r\n',name);
for i=1:length(imagenames)
        fprintf(fid,'<img vspace="5" hspace="5" src="%s"/>\r\n',imagenames{i});
end
fprintf(fid,'</body>\r\n</html>\r\n');
fclose(fid);