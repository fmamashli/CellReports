clear all
clc
close all

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};


for isubj=1:length(subjects)
    
   
    
    subj=subjects{isubj};
    
    %labeldir='/autofs/cluster/transcend/fahimeh/fmm/resources/manual_labels/';
    
    %labeldir='/autofs/cluster/transcend/fahimeh/emo2/resources/fslabelsSK/';
    
   labeldir='/autofs/space/dodeca_003/users/cueshift_perm/resources/fslabels450/';
    
    
    command=['mne_morph_labels --from fsaverage --to ' subj ' --labeldir ' labeldir  ' --smooth  5  --prefix  fsmorphedto_' subj];
    [ct,st]=system(command)
    
end