clear all
clc
close all

data_dir='/autofs/space/taito_005/users/awmrc/';

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};
visitNo=C{1,2};


conds=[1002 1005 1008 1011 1014 1017];
%7 8 9 10 11 12 13 14 15 16 17 18];
k=1;

for isubj=3:length(subjects)
    
    subj=subjects{isubj};
        
    try
        
        
        for icond=1:length(conds)
            
            cond=conds(icond);                        
            
            load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_all'  '_cond_' num2str(cond) '.mat'])
            
            p=size(data.all_epochs,3);
            
            indices=randperm(p);
            
            save([data_dir 'epochMEG/rand_sensor_' subj '_run_all'  '_cond_' num2str(cond) '.mat'],'indices')
            
        end
        
        
    catch
        failed{k}=fileData;
        k=k+1;
    end
    
end


