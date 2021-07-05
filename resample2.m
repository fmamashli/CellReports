clear all
clc
close all


cfg.data_rootdir='/autofs/space/voima_001/users/fahimeh/temp/';
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

%tag=input('1 or 2:')

visitNo='megdata';

conds=[1002 1005 1008 1011 1014 1017];
k=1;

for isubj=3:17
    
    subj=subjects{isubj};
    
    for icond=1:6
        
        cond=conds(icond);
        
         
        for iLabel1=35:95
            
                        
            for iLabel2=96:length(label_names)
                
                
            try
                
                
                savefilename=[cfg.data_rootdir,'/', subj,'_Coh_' label_names{iLabel1}(1:end-6) '_' ...
                    label_names{iLabel2}(1:end-6) '_cond' num2str(cond) '_140-0.5_fil.mat'];
              
                
              load(savefilename)
                
                Coh=resample(Coh',100,500);
                iCoh=resample(iCoh',100,500);
                PL=resample(PL',100,500);
                wPLI=resample(wPLI',100,500);
                wPLI_debiased=resample(wPLI_debiased',100,500);
                
                
                Coh=Coh';
                iCoh=iCoh';
                PL=PL';
                wPLI=wPLI';
                wPLI_debiased=wPLI_debiased';
                
                
                Fs=Fs/5;
                
                
                command=['rm ' savefilename];
                [ct,st]=system(command)
                
                save(savefilename,'nepochs','Fs','iCoh','Coh','PL','wPLI','wPLI_debiased')
                
            catch
               
                failed_s{k}=savefilename;
                k=k+1;
            end
                
            end
            
        end
        
    end
    
end
