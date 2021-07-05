clear all
clc

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1}([3:7,9:15,17:21]);

cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
cfg.protocol='aw';

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};

visitNo='megdata';

conds=[3002,3005,3008,3011,3014,3017];
%conds=[1002 1005 1008 1011 1014 1017];

for isubj=1:length(subjects)
    
    subj=subjects{isubj};
    
    for icond=1:6
        
        cond=conds(icond);
        
        
        
        data1name=[cfg.data_rootdir,subj,'/',visitNo,'/' subj,'_',cfg.protocol,'_epochs_' label_names{1}(1:end-6) ...
            '_cond' num2str(cond) '_flipsign' num2str(1) '_140-0.5allepochs_fil.mat'];
        
        load(data1name);
        
        epoch_nums(isubj,icond)=size(labrep,3);
        
    end
    
end

num1002=epoch_nums;