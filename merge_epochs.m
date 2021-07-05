clear all
clc
close all

data_dir='/autofs/space/voima_001/users/awmrc/';

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};
visitNo=C{1,2};


conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];
%7 8 9 10 11 12 13 14 15 16 17 18];
k=1;

for isubj=3:length(subjects)
    
    subj=subjects{isubj};
    
    
    try
        
        
        for icond=1:length(conds)
            
            cond=conds(icond);
            
            if ~exist([data_dir 'epochMEG/Epochs_sensor_' subj '_run_all'  '_cond_' num2str(cond) '.mat'],'file')
                
                A= load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(1) '_cond_' num2str(cond) '.mat']);
                B= load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(2) '_cond_' num2str(cond) '.mat']);
                C= load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(3) '_cond_' num2str(cond) '.mat']);
                D= load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(4) '_cond_' num2str(cond) '.mat']);
                
                
                data.all_epochs=cat(3,A.data(:,:,A.cfg.indgood),B.data(:,:,B.cfg.indgood),C.data(:,:,C.cfg.indgood),D.data(:,:,D.cfg.indgood));
                data.cfg{1}=A.cfg;
                data.cfg{2}=B.cfg;
                
                save([data_dir 'epochMEG/Epochs_sensor_' subj '_run_all'  '_cond_' num2str(cond) '.mat'],'data')
                
            end
            
        end
        
        
    catch
        failed{k}=fileData;
        k=k+1;
    end
    
end

%%
clear all
clc
close all

data_dir='/autofs/space/voima_001/users/awmrc/';

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};
visitNo=C{1,2};


conds=[3002,3005,3008,3011,3014,3017];
%7 8 9 10 11 12 13 14 15 16 17 18];
k=1;

for isubj=13:18
    
    subj=subjects{isubj};
    
    
    try
        
        
        for icond=1:length(conds)
            
            cond=conds(icond);
            
          %  if ~exist([data_dir 'epochMEG/Epochs_sensor_' subj '_run_all'  '_cond_' num2str(cond) '.mat'],'file')
                
                A= load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(1) '_cond_' num2str(cond) '.mat']);
                B= load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(2) '_cond_' num2str(cond) '.mat']);
                C= load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(3) '_cond_' num2str(cond) '.mat']);
                D= load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(4) '_cond_' num2str(cond) '.mat']);
                
                
                data.all_epochs=cat(3,A.data(:,:,A.cfg.indgood),B.data(:,:,B.cfg.indgood),C.data(:,:,C.cfg.indgood),D.data(:,:,D.cfg.indgood));
                data.cfg{1}=A.cfg;
                data.cfg{2}=B.cfg;
                
                size_data(isubj,icond)=size(data.all_epochs,3);
                
                save([data_dir 'epochMEG/Epochs_sensor_' subj '_run_all'  '_cond_' num2str(cond) '.mat'],'data')
                
           % end
            
        end
        
        
    catch
        failed{k}=fileData;
        k=k+1;
    end
    
end



