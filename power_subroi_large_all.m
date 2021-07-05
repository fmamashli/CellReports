clear all
clc
close all


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
cfg.protocol='aw';

save_dir = '/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

cfg.highpass=140;
cfg.lowpass=0.5;

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};
subjects=subjects(3:21);

clear C



fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};



visitNo='megdata';

conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];

flipsign=1;

FREQ=2:120;

theta=find(FREQ>3,1,'first'):find(FREQ>7,1,'first');
alpha=find(FREQ>7,1,'first'):find(FREQ>12,1,'first');
beta=find(FREQ>13,1,'first'):find(FREQ>29,1,'first');
gamma=find(FREQ>30,1,'first'):find(FREQ>58,1,'first');

%%

lnames = {'anteriorcingulate_rh',
    'caudalmiddlefrontal_rh',
    'lateralorbitofrontal_rh',
    'IFG_rh',
    'rostralmiddlefrontal_rh',
    'precentral_rh',
    'superiortemporal_rh',
    'anteriorcingulate_lh',
    'lateralorbitofrontal_lh',
    'IFG_lh',
    'caudalmiddlefrontal_lh',
    'rostralmiddlefrontal_lh',
    'precentral_lh',
    'superiortemporal_lh',
    'supramarginal_lh',
    'supramarginal_rh'};

indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68],[69:72], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154]};


%%

freq_inds={theta,alpha,beta,gamma};
freq_names={'Theta','Alpha','Beta','Gamma'};

tag=input('1, 2 or 3 or 4:')

t1=0.5;
t2=2;
k=1;

for ifreq=1:1
    
    indf=freq_inds{ifreq};
    freq_tag=freq_names{ifreq};
    
    
    for iroi1=10:10
        
        
        L1=label_names(indices{iroi1});
        
        try
            
            for isubj=1:19
                
                subj=subjects{isubj};
                
                for icond1=1:6
                    
                    [ifreq isubj iroi1 icond1]
                    
                    cond1=conds(icond1);
                    
                    data(isubj,icond1,:)=cross_cond_power_subroi_all(subj,L1,cond1,indf,tag,t1,t2);
                    
                end
                
            end
            
            save([save_dir 'pow_allsubj_' lnames{iroi1} '_1002to1017_' freq_tag ,...
                '_split' num2str(tag) '_time' num2str(t1) 'to' num2str(t2) 's.mat'],'data','L1','L2','subjects')
            
            clear data L1 L2
            
        catch
            failed{k}=[iroi1,iroi2];
            k=k+1;
        end
        
        
        
    end
    
    
end



