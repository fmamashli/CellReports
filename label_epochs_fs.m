clear all
clc
close all

addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Mines/

cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
cfg.protocol='aw';

cfg.highpass=140;
cfg.lowpass=0.5;

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1}(155:175);


labeldir='/autofs/space/dodeca_003/users/cueshift_perm/resources/fslabels450/';
%labeldir='/autofs/space/voima_001/users/awmrc/fmri_scripts/4mvpa/make_searchlights/fsave3_pcdiv3_labels/';

visitNo='megdata';

%conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];
conds=[1002 1005 1008 1011 1014 1017 3002,3005,3008,3011,3014,3017];

isMean=0;
isSpatial=0;
flipsign=1;

for isubj=3:length(subjects)
    
    subj=subjects{isubj};
    
    % for tf analysis you need to use FIXed inverse!!
    fname_inv = [cfg.data_rootdir subj '/megdata/' subj  '_aw_0.5_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif'];
    
    
    label_dir=[labeldir subj '/fsmorphedto_' subj '-'];
    
 %   try
        
        for icond=1:12
            
            cfg1=cfg;
            
            [isubj icond ]
            
            cond=conds(icond);
            
            epoch_data=[cfg.data_rootdir '/epochMEG/Epochs_sensor_' subj '_run_all'   '_cond_' num2str(cond) '.mat'];
            
            tic
            label_epoching_emo2(fname_inv,epoch_data,label_names,label_dir,cfg1,subj,visitNo,cond,isMean,isSpatial,flipsign)
            toc
            
            fprintf('done \n')
            
            clear cfg1
            
            
        end
        
%     catch
%         
%         failed_s{isubj}=subj;
%         
%     end
    
    
end

save('failed_s3.mat','failed_s')
