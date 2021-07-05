clear all
clc
close all

data_dir='/autofs/space/voima_001/users/awmrc/';



fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/aw_list_proj.txt');
C=textscan(fid,'%s%s%s%s%s');

subjects=C{1,1};
runs=C{1,3};

%conds=[1002 1005 1008 1011 1014 1017];
conds=[3002 3005 3008 3011 3014 3017];




for isubj=1:8
    
    subj=subjects{isubj};
    
    for icond=1:length(conds)
        
        cond=conds(icond);
        
        load([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' runs{isubj} '_cond_' num2str(cond) '.mat']);
        
        if ~isempty(cfg.indgood)
            epochs_num(isubj,icond)=length(cfg.indgood);
        else
            epochs_num(isubj,icond)=0;
        end
        
    end
    
end