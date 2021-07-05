clear all
clc
close all


addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
cfg.protocol='aw';

cfg.highpass=140;
cfg.lowpass=0.5;

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/aw_list_proj.txt');
C=textscan(fid,'%s%s%s%s%s');

subjects=C{1,1};

runs=C{1,3};
ecgproj=C{1,4};
eogproj=C{1,5};


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};


labeldir='/autofs/space/dodeca_003/users/cueshift_perm/resources/fslabels450/';
%labeldir='/autofs/space/voima_001/users/awmrc/fmri_scripts/4mvpa/make_searchlights/fsave3_pcdiv3_labels/';

visitNo='megdata';

%conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];

%%

% pool=parpool('local',15);
iLabel=135;

isMean=0;
isSpatial=0;
flipsign=0;

for isubj=1:length(subjects)
    
 %   try
        subj=subjects{isubj};
        irun=runs{isubj};
        
        
            
            file1=[cfg.data_rootdir,'/',subj,'/',visitNo,'/' subj '_rawdata_fix_inv_0.5_140fil_' label_names{iLabel}(1:end-6) '_run' num2str(irun) '.mat'];
            
                
                subj
                
                fname_inv = [cfg.data_rootdir subj '/megdata/' subj  '_aw_0.5_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif'];
                
                inv = mne_read_inverse_operator(fname_inv);
                
                
                file=[cfg.data_rootdir,'/',subj,'/',visitNo,'/' subj '_' cfg.protocol '_' num2str(irun) '_0.5_140fil_raw.fif'];
                
                raw=fiff_setup_read_raw(file);
                
                [data,times]=fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp);
                
                
                % sol: vertices*time*epochs
                data_input=data(1:306,:);
                nave=1;
                dSPM=1;
                pickNormal=0;
                
                
                sol = single(labelrep_cortex(data_input,fname_inv,nave,dSPM,pickNormal));
                
                
                label_dir=[labeldir subj '/fsmorphedto_' subj '-'];
                
                label=[label_dir label_names{iLabel}];
                
                isubj
                
                [labrep, rsrcind, lsrcind,srcind] = labelmean(label,inv,sol,isMean,isSpatial,flipsign);
                
                save(file1,'labrep','times','fname_inv')
                
            
            
            
       
        
%     catch
%         
%         failed_s{isubj}=isubj;
%     end
    
end

save('failed_s2.mat','failed_s')





