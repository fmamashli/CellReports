clear all
clc
close all

addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/
cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
cfg.protocol='aw';



fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};


k=1;

for isubj=3:21
    
    
    subj=subjects{isubj};
    visitNo='megdata';
    run='1';
    
    
    inv_fix_name=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_0.5_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif'];
    
    check=exist(inv_fix_name,'file');
    
 %   if check==0
        
        tic
        %    command1=['mne_setup_source_space  --subject  ' subj ' --ico 4 --cps --overwrite '];
        
        %   [st,ct]=system(command1)
        
        filtered_data=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_' run '_0.5_140fil_raw.fif'];
        
        mri_trans= ['/autofs/space/voima_001/users/awmrc/erm/' subj '/' visitNo '/' subj '_1-trans.fif'];
        
        fw_name=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_' run '_ico4-fwd.fif'];
        
        log_file=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_' run '_ico4-fwd.log'];
        
        command2=['mne_do_forward_solution --meas ' filtered_data ' --megonly --overwrite --spacing ico-4 --mri ' mri_trans ' --fwd ' fw_name ' --subject ' subj ' > ' log_file];
        
        %   [st,ct]=system(command2)
        
        
        %Please make sure --noiserank is correct
        [ fid, tree ] = fiff_open(filtered_data);
        [ info ] = fiff_read_proj(fid,tree);
        noise_rank=64-size(info,2);
        
        
        %     ind=find(strcmp(subj,subjects_t));
        %     projs=proj_type{ind};
        %     ecgeog=str2double(remove_ecgeog{ind});
        
        ecgproj=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_' run '_decim_ecg_proj.fif'];
        eogproj=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_' run '_decim_eog_proj.fif'];
        
        
        erm_cov_file=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_erm_1_0.5-140fil-cov.fif'];
        
        
        [ fid, tree ] = fiff_open(erm_cov_file);
        [ info_erm ] = fiff_read_proj(fid,tree);
        
        if size(info,2)~=size(info_erm,2)
            
            different_projs{k}=subj;
            k=k+1;
            
            save('/autofs/space/voima_001/users/awmrc/erm_proj_check.mat','different_projs')
            
        end
        
        proj_file = [ecgproj ' ' eogproj];
        
        %  proj_file = [ eogproj];
        
        
        inv_loose_name=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_0.5_140_calc-inverse_loose_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif .fif'];
        
        log_file=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_0.5_140_calc-inverse_loose_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.log'];
        
        command3=['mne_do_inverse_operator --meg  --depth --loose 0.3  --noiserank ' num2str(noise_rank) ' --fwd ' fw_name '  --proj ' proj_file ...
            ' --senscov ' erm_cov_file ' --inv '  inv_loose_name ' -v >& ' log_file ];
        
        [st,ct]=system(command3)
        
        
        
        log_file=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg.protocol '_0.5_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.log'];
        
        command4=['mne_do_inverse_operator --meg --fixed   --noiserank ' num2str(noise_rank) ' --fwd ' fw_name '  --proj ' proj_file ...
            ' --senscov ' erm_cov_file ' --srccov ' inv_loose_name ...
            ' --inv ' inv_fix_name  ' -v >& ' log_file ];
        
        [st,ct]=system(command4)
        
        toc
        
 %   end
    
end



