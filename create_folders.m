% clear all
% clc
% 
% fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
% C=textscan(fid,'%s%s');
% subjects=C{1,1};
% 
% dir1='/autofs/space/toivo_002/users/awmrc_2/';
% 
% %%
% for i=1:length(subjects)
%     
%     command=['mkdir ' dir1 subjects{i}];
%     system(command)
%     
%     command=['mkdir ' dir1 subjects{i} '/megdata' ];
%     system(command)
%     
% end

%%
clear all
clc
close all

save_dir='/autofs/space/toivo_002/users/awmrc_2/';

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
label_names=C{1,1};

visitNo='megdata';

%conds=[1002 1005 1008 1011 1014 1017];
%conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];
%conds=[3002,3005,3008,3011,3014,3017];
conds=[1002 1005 1008 1011 1014 1017 3002,3005,3008,3011,3014,3017];


flipsign=1;

%tag=input('1 or 2 or 3 or 4:')


for isubj=3:21
    
    subj=subjects{isubj};
    
    for icond=1:12
        
        cond=conds(icond);
        
        
        
        for iLabel1=1:154
            
            
            for iLabel2=155:175
                
                
                for itag=1:4
                    
                    savefilename=[cfg.data_rootdir,subj,'/',visitNo,'/', subj,'_Coh_' num2str(itag) '_split4_' label_names{iLabel1}(1:end-6) '_' ...
                        label_names{iLabel2}(1:end-6) '_cond' num2str(cond) '_140-0.5_fil.mat'];
                    
                    newf=[save_dir ,subj,'/',visitNo,'/', subj,'_Coh_' num2str(itag) '_split4_' label_names{iLabel1}(1:end-6) '_' ...
                        label_names{iLabel2}(1:end-6) '_cond' num2str(cond) '_140-0.5_fil.mat'];
                    
                    if exist(savefilename,'file')
                        
                        command=['mv ' savefilename ' ' newf];
                        system(command)
                        
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
end

