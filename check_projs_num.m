
clear all
clc
close all

data_dir='/autofs/space/taito_005/users/awmrc/';


fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/aw_list_proj.txt');
C=textscan(fid,'%s%s%s%s%s');

subjects=C{1,1};
visitNo=C{1,2};
runs=C{1,3};



for isubj=4:length(subjects)
    
    subj=subjects{isubj};
    run=str2double(runs{isubj});
    
    try
    
    fileData=[data_dir subj '/megdata/' subj '_aw_' num2str(run) '_0.5_140fil_raw.fif'];
    
    
    [fid,tree]=fiff_open(fileData);
    projs=fiff_read_proj(fid,tree);
    
    projs_num(isubj,1)=length(projs);
    
    catch
       
        failed{isubj}=fileData;
    end
    
end
