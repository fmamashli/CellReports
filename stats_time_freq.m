clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Coherence

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_labels.txt');
C=textscan(fid,'%s');
label_names=C{1,1};


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
visitNo='megdata';
cfg.protocol='aw';
cfg.highpass=140;
cfg.lowpass=0.5;

save_dir='/autofs/space/taito_005/users/fahimeh/doc/Figures/Power/';

save_data='/autofs/space/taito_005/users/fahimeh/resources/power/';

conds=[1002 1005 1008 1011 1014 1017];


FREQ=2:120;

t=-.5:.002:3;
indt=find(t>0,1,'first'):find(t>2.4,1,'first');

%%
for icond=1:6
    
    for isubj=3:17
        
        subj=subjects{isubj};
        
        for iLabel1=96:length(label_names)
            
            [iLabel1 isubj icond]
            
            cond1=conds(icond);
            
            filename=[cfg.data_rootdir, subj,'/',visitNo,'/TF_',subj,'_',cfg.protocol,'_epochs_' label_names{iLabel1}(1:end-6) '_cond' num2str(cond1)  'epochs_AutoTF.mat'];
            load(filename)
            
            data_totals(iLabel1-95,:)=median(Total(:,indt),2);
            data_induced(iLabel1-95,:)=median(Induced(:,indt),2);
            data_itc(iLabel1-95,:)=median(ITC(:,indt),2);
            
        end
        
        subj_total(isubj-2,:)=mean(data_totals);
        subj_induced(isubj-2,:)=mean(data_induced);
        subj_itc(isubj-2,:)=mean(data_itc);
        
    end
    
    save([save_data 'TF_subjects_cond' num2str(cond1) '.mat'],'subj_total','subj_induced','subj_itc')
    
    clear subj_total subj_induced subj_itc
    
end
%%
figure;
for icond=1:6
    cond1=conds(icond);
    load([save_data 'TF_subjects_cond' num2str(cond1) '.mat'])
    [h,p,ci,stats]=ttest(subj_itc)
    plot(stats.tstat,'LineWidth',3)
    hold on
end
title('ITC')
legend('1002','1005','1008','1011','1014','1017')
print([save_dir 'ITC_ttest'],'-dpng')
%%
theta=find(FREQ>3,1,'first'):find(FREQ>7,1,'first');
alpha=find(FREQ>7,1,'first'):find(FREQ>12,1,'first');
beta=find(FREQ>13,1,'first'):find(FREQ>29,1,'first');
gamma=find(FREQ>30,1,'first'):find(FREQ>58,1,'first');

freq_inds={theta,alpha,beta,gamma};
freq_names={'Theta','Alpha','Beta','Gamma'};



for icond=1:6
    cond1=conds(icond);
    load([save_data 'TF_subjects_cond' num2str(cond1) '.mat'])
    
    meas1(icond,:)=mean(subj_itc(:,theta),2);
    meas2(icond,:)=mean(subj_itc(:,alpha),2);
    meas3(icond,:)=mean(subj_itc(:,beta),2);
    meas4(icond,:)=mean(subj_itc(:,gamma),2);
    
    
end

classes=cell(1,1);
classes(1:15,1)={'1002'};
classes(16:30,1)={'1005'};
classes(31:45,1)={'1008'};
classes(46:60,1)={'1011'};
classes(61:75,1)={'1014'};
classes(76:90,1)={'1017'};

X1=[meas1(1,:),meas1(2,:),meas1(3,:),meas1(4,:),meas1(5,:),meas1(6,:)]';
X2=[meas2(1,:),meas2(2,:),meas2(3,:),meas2(4,:),meas2(5,:),meas2(6,:)]';
X3=[meas3(1,:),meas3(2,:),meas3(3,:),meas3(4,:),meas3(5,:),meas3(6,:)]';
X4=[meas4(1,:),meas4(2,:),meas4(3,:),meas4(4,:),meas4(5,:),meas4(6,:)]';

tb = table(classes,X1,X2,X3,X4,...
    'VariableNames',{'ripplescategory','Theta','Alpha','Beta','Gamma'});


Meas = table([1 2 3 4]','VariableNames',{'Measurements'});

rm = fitrm(tb,'Theta-Gamma~ripplescategory','WithinDesign',Meas);

ranovatbl = ranova(rm)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/raacampbell-notBoxPlot-3ce29db/code


