clear all
clc
close all

addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Mines/

cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';


fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};
subjects=subjects(1:21);

name_tag='stimulus';
time_tag='_0to1s_';


for isubj=1:length(subjects)
    
    subj=subjects{isubj};
    fname = [cfg.data_rootdir,subj,'/megdata/', name_tag,'_',subj,time_tag,...
        'pca100_aw_decoding_scores'];
    stc_out =[cfg.data_rootdir,subj,'/megdata/', name_tag,'_',subj,time_tag,...
        'pca100_aw_decoding_scores-morph'];
    
 %   if strcmp(subj,'awmrc_001') || strcmp(subj,'awmrc_002')
    command=['mne_make_movie  --stcin  ' fname  ' --subject '  subj   ' --tstep 5 --morph fsaverage --morphgrade 4 --smooth 5   --stc ' stc_out];
    
    [st] = unix(command);
 
  %  end
    
    lh=mne_read_stc_file([stc_out '-lh.stc']);
    rh=mne_read_stc_file([stc_out '-rh.stc']);
    
    [lh,rh]=removeMedialWall(lh,rh);
    
    Data=[lh.data;rh.data];
    
    
    data_subj(isubj,:,:)=Data;
    
end

data_subj([8,16],:,:)=[];

%%

save_dir='/autofs/space/taito_005/users/fahimeh/resources/decoding_results/timeseries/';

cfg1=[];
cfg1.statmethod='ttest';
cfg1.numperm=500;
cfg1.alpha=0.001;
load('/space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Mines/VertConn5124.mat')
cfg1.connectivity=VertConn;

G2=ones(size(data_subj))/6;

tic
STATS=clustterstat3D(data_subj,G2,cfg1);
toc

save([save_dir 'statistics_cluster_001_' name_tag '_' time_tag '.mat'],'STATS')

%% visualization
load([save_dir 'statistics_cluster_' name_tag '_' time_tag '.mat'])
iclus=3;
lh.data = STATS.posclus(iclus).mask(1:2562,:);
rh.data = STATS.posclus(iclus).mask(2563:end,:);

stc_file=[save_dir 'stats_cluster_mask_cluster' num2str(iclus) '_' name_tag '_' time_tag];

mne_write_stc_file([stc_file '-lh.stc'],lh);
mne_write_stc_file([stc_file '-rh.stc'],rh);



