clear all
clc
close all

addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Coherence

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
visitNo='megdata';
cfg.protocol='aw';
cfg.highpass=140;
cfg.lowpass=0.5;


conds=[1002 1005 1008 1011 1014 1017 ];
%conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];
%conds=[3002,3005,3008,3011,3014,3017];



FREQ=2:120;


pool=parpool('local',4);

for isubj=3:10
    
    subj=subjects{isubj};
    
    for icond=1:6
        
        for iLabel1=1:length(label_names)
            
            cond1=conds(icond);
            
            try
                
                data1=load([cfg.data_rootdir,subj,'/',visitNo,'/' subj,'_',cfg.protocol,'_epochs_' label_names{iLabel1}(1:end-6), ...
                    '_cond' num2str(cond1) '_flipsign1'  '_140-0.5allepochs_fil.mat']);
                
                
                labrep=data1.labrep;
                
                times=data1.times;
                
                fs=1./diff(times);
                Fs=fs(1);
                
                n = fix(size(labrep,3)/4);
                
                parfor ihalf=1:4
                    
                    labrep_sel = labrep(:,:,(ihalf-1)*n+1:n*ihalf);
                    
                    filename=[cfg.data_rootdir, subj,'/',visitNo,'/TF_split4_half',num2str(ihalf),'_',subj,'_', label_names{iLabel1}(1:end-6) '_cond' num2str(cond1)];
                    
                                        
                    TF_label_source_attn(labrep_sel,Fs,FREQ,times,filename,subj,icond)
                    
                end
                
                
            catch
                failed{isubj}=subj;
            end
            
        end
        
    end
    
end



