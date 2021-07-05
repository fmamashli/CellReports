clear all; close all; fclose all;

cfg.data_rootdir = '/autofs/space/voima_001/users/awmrc/';

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};

k=1;

for isubj=3:20
    
    subj=subjects{isubj};
%     
%     fname = [cfg.data_rootdir,subj,'/megdata/alltimes_', subj , '_aw_decoding_scores']
%     stc_lh = mne_read_stc_file([fname '-lh.stc'])
%     stc_rh = mne_read_stc_file([fname '-rh.stc'])
%     
%     subj_data(k,:,:) = [stc_lh.data;stc_rh.data];
%     k=k+1;
   try
        inv_fix_name=[cfg.data_rootdir '/' subj '/megdata'  '/' subj '_aw'  '_1-fwd.fif'];

    % inv =  mne_read_inverse_operator(inv_fix_name)
     
   tt =  mne_read_forward_solution(inv_fix_name)
     
     n(isubj,1)=tt.nsource;
   catch
       
   end
end