clear all; close all;clc
% logfile dir
dir1='/autofs/space/voima_001/users/awmrc/fmri_log_files/';


fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_fmri_logfiles.txt');
C=textscan(fid,'%s');


files=C{1,1};


for i=1:length(files)
    
    fid=fopen([dir1 files{i}]);
    C=textscan(fid,'%s%s%s%s');
    time=C{1,1}{3};    
    Date=C{1,4}{2};
    
    strcat(Date,' , ',time)
    
    data(i)=datenum(strcat(Date,' , ',time));
    
end

[val,ind]=sort(data);

sorted_files=files(ind);

save([dir1 'sorted_logfiles_basedontime.mat'],'sorted_files')
    
    
%%
clear all; close all;clc
% logfile dir
dir1='/autofs/space/voima_001/users/awmrc/meg_log_files/';


fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_meg_log.txt');
C=textscan(fid,'%s');


files=C{1,1};


for i=1:length(files)
    
    fid=fopen([dir1 files{i}]);
    C=textscan(fid,'%s%s%s%s');
    time=C{1,1}{3};    
    Date=C{1,4}{2};
    
    strcat(Date,' , ',time)
    
    data(i)=datenum(strcat(Date,' , ',time));
    
end

[val,ind]=sort(data);

sorted_files=files(ind);

save([dir1 'sorted_MEG_logfiles_basedontime.mat'],'sorted_files')
%save([dir1 'sorted_MEG_logfiles_basedontime1.mat'],'sorted_files')