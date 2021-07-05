clear all
clc
close all

addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Coherence


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
cfg.protocol='aw';

save_dir='/autofs/space/toivo_002/users/awmrc_2/';

cfg.highpass=140;
cfg.lowpass=0.5;

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};


clear C

% fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_labels.txt');
% C=textscan(fid,'%s');
% label_names=C{1,1};

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};

visitNo='megdata';

%conds=[1002 1005 1008 1011 1014 1017];
%conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];
%conds=[3002,3005,3008,3011,3014,3017];
conds=[1002 1005 1008 1011 1014 1017 3002,3005,3008,3011,3014,3017];


flipsign=1;

tag=input('1 or 2 or 3 or 4:')

FREQ=2:120;

%POOL=parpool('local',6);

for isubj=12:12
    
    subj=subjects{isubj};
    
    for icond=1:6
        
        cond=conds(icond);
        
        randfile=[cfg.data_rootdir 'epochMEG/rand_sensor_' subj '_run_all'  '_cond_' num2str(cond) '.mat'];
        
        
        for iLabel1=123:154
            
            data1name=[cfg.data_rootdir,subj,'/',visitNo,'/' subj,'_',cfg.protocol,'_epochs_' label_names{iLabel1}(1:end-6) ...
                '_cond' num2str(cond) '_flipsign' num2str(flipsign) '_140-0.5allepochs_fil.mat'];
            
            for iLabel2=155:175
                
                
                % two labels should be in the same hemisphere
                check1=strcmp(label_names{iLabel2}(end-7:end-6),label_names{iLabel1}(end-7:end-6));
                % one of the labels should be temporal
                %check2=contains(label_names{iLabel2}(1:end-6),'temporal')+contains(label_names{iLabel1}(1:end-6),'temporal');
                check2=contains(label_names{iLabel2}(1:end-6),'lateraloccipital');
                
                
                if check1+check2==2
                    
                    fprintf('label %s and label %s subj %s and cond %s \n',...
                        label_names{iLabel1}(1:end-6), label_names{iLabel2}(1:end-6),subj, num2str(icond))
                    
                    data2name=[cfg.data_rootdir,subj,'/',visitNo,'/' subj,'_',cfg.protocol,'_epochs_' label_names{iLabel2}(1:end-6) ...
                        '_cond' num2str(cond) '_flipsign' num2str(flipsign) '_140-0.5allepochs_fil.mat'];
                    
                    
                    savefilename=[save_dir,subj,'/',visitNo,'/', subj,'_Coh_' num2str(tag) '_split4_' label_names{iLabel1}(1:end-6) '_' ...
                        label_names{iLabel2}(1:end-6) '_cond' num2str(cond) '_140-0.5_fil.mat'];
                    
                    %coherence_A_B_conn(data1name,data2name,savefilename,FREQ)
                    if ~exist(savefilename,'file')
                        
                        if ~exist([savefilename(1:end-4) '.lock'],'file')
                            
                            fid=fopen([savefilename(1:end-4) '.lock'],'w');
                            w=1;
                            fwrite(fid,w);
                            fclose(fid);
                            
                            coherence_A_B_conn(data1name,data2name,randfile,savefilename,FREQ,tag)
                            
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
end

