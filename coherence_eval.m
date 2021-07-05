clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Coherence


cfg.data_rootdir='/autofs/space/taito_005/users/awmrc/';
cfg.protocol='aw';

save_dir = '/autofs/space/taito_005/users/fahimeh/doc/Figures/coherence/1/';

cfg.highpass=140;
cfg.lowpass=0.5;

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_labels.txt');
C=textscan(fid,'%s');
label_names=C{1,1};

selection={'precentral-fs3vrtx2fsave-3-lh.label';
    'precentral-fs3vrtx2fsave-50-lh.label';
    'precentral-fs3vrtx2fsave-191-lh.label';
    'precentral-fs3vrtx2fsave-275-lh.label';
    'precentral-fs3vrtx2fsave-277-lh.label';
    'precentral-fs3vrtx2fsave-278-lh.label';
    'precentral-fs3vrtx2fsave-292-lh.label';
    'precentral-fs3vrtx2fsave-71-rh.label';
    'precentral-fs3vrtx2fsave-127-rh.label';
    'precentral-fs3vrtx2fsave-266-rh.label';
    'precentral-fs3vrtx2fsave-267-rh.label';
    'precentral-fs3vrtx2fsave-490-rh.label'};

visitNo='megdata';

conds=[1002 1005 1008 1011 1014 1017];

flipsign=1;

FREQ=2:120;


%%
for icond=1:6
    
    cond=conds(icond);
    
    %   randfile=[cfg.data_rootdir 'epochMEG/rand_sensor_' subj '_run_all'  '_cond_' num2str(cond) '.mat'];
    
    tvalues=zeros(61,51,119,1201);
    
    for iLabel1=1:61
        
        
        for iLabel2=62:length(label_names)
            
            [icond iLabel1 iLabel2]
            
            k=1;
            data=zeros(15,119,1751);
            
            for isubj=3:17
                
                subj=subjects{isubj};
                
                load(['/autofs/space/voima_001/users/fahimeh/temp/', subj,'_Coh_' label_names{iLabel1}(1:end-6) '_' ...
                    label_names{iLabel2}(1:end-6) '_cond' num2str(cond) '_140-0.5_fil.mat']);
                
                
                data(k,:,:)=Coh;
                k=k+1;
                
            end
            
            [h,p,ci,stats]=ttest(data);
            
            indt=find(times>0,1,'first'):find(times>2.4,1,'first');
            
            tvalues(iLabel1,iLabel2-61,:,:)=squeeze((stats.tstat(1,:,indt)));
            
            clear data stats k
            
        end
        
    end
    
    D{icond}=tvalues;
    
    clear tvalues
    
end

%%
lh=str_find_cell(label_names,'-lh.label');
rh=str_find_cell(label_names,'-rh.label');
stg=str_find_cell(label_names,'STc');
precentral=str_find_cell(label_names,'precentral');

lstg=find(lh.*stg)-61;
rstg=find(rh.*stg)-61;

for iselect=1:7
    
    precentral_lh(iselect)=find(str_find_cell(label_names,selection{iselect}));
    
end

for iselect=8:12
    
    precentral_rh(iselect-7)=find(str_find_cell(label_names,selection{iselect}));
    
end



for iselect=1:7
    
    precentral_xlh(iselect,:)=str_find_cell(label_names,selection{iselect});
    
end

precentral_xlh = sum(precentral_xlh);

for iselect=8:12
    
    precentral_xrh(iselect-7,:)=str_find_cell(label_names,selection{iselect});
    
end

precentral_xrh = sum(precentral_xrh);


leftpre_x=find(precentral.*lh.*~precentral_xlh');

rightpre_x=find(precentral.*rh.*~precentral_xrh');


%%

for icond=1:6
    
    tf_lstg_lpre=squeeze(mean(squeeze(mean(D{icond}(precentral_rh,rstg,:,:)))));
    figure;
    imagesc(times(indt),FREQ,tf_lstg_lpre);colorbar;colormap('jet');axis xy;
    set(gca,'clim',[5.5 8.5])
    xlabel('time(s)')
    ylabel('Freq (Hz)')
    title(['RSTG-RLip-precentral-cond' num2str(conds(icond))])
    
    print([save_dir 'rstg_rprecentral_cond' num2str(conds(icond))],'-dpng')
    
end

%%

%t=-0.5:.002:3;

for icond=1:6
    
    tf_lstg_lpre=squeeze(mean(squeeze(mean(D{icond}(rightpre_x,rstg,:,:)))));
    figure;
    imagesc(times(indt),FREQ,tf_lstg_lpre);colorbar;colormap('jet');axis xy;
    set(gca,'clim',[5.5 8.5])
    xlabel('time(s)')
    ylabel('Freq (Hz)')
    title(['RSTG-R-other-precentral-cond' num2str(conds(icond))])
    
    print([save_dir 'rstg_other_precentral_cond' num2str(conds(icond))],'-dpng')
    
end


%load('/autofs/space/voima_001/users/fahimeh/temp/tvalues_6conds.mat','D')


