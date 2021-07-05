clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Coherence


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
cfg.protocol='aw';

cfg.highpass=140;
cfg.lowpass=0.5;

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_labels.txt');
C=textscan(fid,'%s');
label_names=C{1,1};

% fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
% C=textscan(fid,'%s');
% label_names=C{1,1};


%conds=[1002 1005 1008 1011 1014 1017];
conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];

flipsign=1;




for isubj=3:17
    
    subj=subjects{isubj};
    
    for icond=1:6
        
        cond=conds(icond);
        
        
        for iLabel1=1:95
            
            try
                
                command=['rm ' cfg.data_rootdir , subj,'/megdata/',subj,'_Coh_', '*',label_names{iLabel1}(1:end-6),'*','cond', num2str(cond),'*'];
                
                [st,ct]=system(command)
                
            catch
                fprintf('file not found \n')
            end
            
            
        end
        
    end
    
end

