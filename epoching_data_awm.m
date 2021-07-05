clear all
clc
close all

addpath /usr/pubsw/packages/mne/nightly_build/share/matlab/;
addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/Private_epochMEG;
addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/

data_dir='/autofs/space/voima_001/users/awmrc/';

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/aw_list_proj.txt');
C=textscan(fid,'%s%s%s%s%s');

subjects=C{1,1};
visitNo=C{1,2};
runs=C{1,3};
ecgproj=C{1,4};
eogproj=C{1,5};

tminvalue=2;
tmaxvalue=3;
bminvalue=1.7;
bmaxvalue=2;

%conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];
%conds=[3002,3005,3008,3011,3014,3017];
conds=[256, 512];
%7 8 9 10 11 12 13 14 15 16 17 18];
k=1;

for isubj=21:length(subjects)
    
    subj=subjects{isubj}
    run=str2double(runs{isubj});
    
    
    fileData=[data_dir subj '/megdata/' subj '_aw_' num2str(run) '_0.5_140fil_raw.fif'];
    % eventfile=[data_dir subj '/megdata/run' num2str(irun) '_mc_sss_ds_nprj_raw-eve.fif'];
    
    eventfile = [data_dir subj '/megdata/' subj '_aw_' num2str(run) '_decim_recode_sss_mergestim-eve.fif'];
    
    
    goodtrialLog=[data_dir subj '/megdata/' subj '_aw_' num2str(run) '_0.5_140fil-ave.log'];
    
   try
        
     %   if ~exist([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(run) '_cond_1002'  '.mat'],'file')
            
            for icond=1:length(conds)
                
                cond=conds(icond)
                
                [data,cfg.times,cfg.epoch_ch_names] = mne_read_epochs(fileData,cond,eventfile,tminvalue,tmaxvalue);
                
                
                first_sample=find(cfg.times  >=bminvalue,1,'first');
                zero_sample=find(cfg.times  >=bmaxvalue,1,'first');
                
                data=permute(data,[3 1 2]);
                data_mean=mean(data(:,:,first_sample:zero_sample),3);
                data_mean=repmat(data_mean,[1 1 size(data,3)]);
                data=(data-data_mean);
                data=permute(data,[2 3 1]);
                clear data_mean zero_sample
                
                
                cfg.bminvalue=bminvalue;
                cfg.bmaxvalue=bmaxvalue;
                cfg.tminvalue=tminvalue;
                cfg.tmaxvalue=tmaxvalue;
                
                data=data(1:306,:,:);
                
                [cfg.indgood,cfg.indbad_EOG,cfg.indbad_MEG] = parsemneavelog(goodtrialLog,cond);
                
                save([data_dir 'epochMEG/Epochs_sensor_' subj '_run_' num2str(run) '_cond_' num2str(cond) '.mat'],'data','cfg','-v7.3')
                
                clear cfg data cond
                
            end
            
      %  end
        
    catch
        failed{k}=fileData;
        k=k+1;
   end
    
end