function [] = figures2HTML(imagenames,htmlname)
[~,name,~] = fileparts(htmlname);
fid=fopen(htmlname,'w'); %create the file
fprintf(fid,'<!DOCTYPE html>\r\n<head>\r\n<title>%s</title>\r\n</head>\r\n<body>\r\n',name);
fprintf(fid,'<table>\r\n');
for i=1:length(imagenames)
    if mod(i,2) == 1
        fprintf(fid,'<tr>\r\n');
        fprintf(fid,'<td><img src="%s"/></td>\r\n',imagenames{i});
    else
        
        fprintf(fid,'<td><img src="%s"/></td>\r\n',imagenames{i});
        fprintf(fid,'</tr>\r\n');
    end
end
fprintf(fid,'</table>\r\n');
fprintf(fid,'</body>\r\n</html>\r\n');
fclose(fid);