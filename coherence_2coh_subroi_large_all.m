clear all
clc
close all

%addpath /autofs/cluster/transcend/fahimeh/fm_functions/Coherence


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
cfg.protocol='aw';

%save_dir = '/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

save_dir = '/autofs/space/tahto_001/users/fahimeh/awmrc_resource2/coherence/large_subroi/';

cfg.highpass=140;
cfg.lowpass=0.5;

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};
subjects=subjects([3:7,9:15,17:21]);

clear C



fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};



visitNo='megdata';


flipsign=1;

FREQ=2:120;

theta=find(FREQ>3,1,'first'):find(FREQ>7,1,'first');
alpha=find(FREQ>7,1,'first'):find(FREQ>12,1,'first');
beta=find(FREQ>13,1,'first'):find(FREQ>29,1,'first');
gamma=find(FREQ>30,1,'first'):find(FREQ>58,1,'first');
highgamma = find(FREQ>62,1,'first'):find(FREQ>119,1,'first');



lnames = {'anteriorcingulate_rh',
    'caudalmiddlefrontal_rh',
    'lateralorbitofrontal_rh',
    'IFG_rh',
    'rostralmiddlefrontal_rh',
    'precentral_rh',
    'superiortemporal_rh',
    'lateralorbitofrontal_lh',
    'IFG_lh',
    'caudalmiddlefrontal_lh',
    'rostralmiddlefrontal_lh',
    'precentral_lh',
    'superiortemporal_lh',
    'supramarginal_lh',
    'supramarginal_rh',
    'lateraloccipital_lh',
    'lateraloccipital_rh'};

indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154],[155:165],[166:175]};


%%

freq_inds={theta,alpha,beta,gamma,highgamma};
freq_names={'Theta','Alpha','Beta','Gamma','HighGamma'};

tag=input('1, 2 or 3 or 4:')

name_tag='1002to1017';


if strcmp(name_tag,'1002to1017')
    t1=0.5;
    t2=2; %original time
    
    % we test early time now: 0.5 to 1.25
    %t2=1.25;
    
    % second half
    %t1=1.25;t2=2;
    
    conds=[1002 1005 1008 1011 1014 1017];
else
    t1=0;
    t2=1;
    conds=[3002,3005,3008,3011,3014,3017];
end
k=1;

%tag='ALL';

for ifreq=1:5
    
    indf=freq_inds{ifreq};
    freq_tag=freq_names{ifreq};
    
    
    for iroi1=2:length(lnames)-1
        
        for iroi2=iroi1+1:length(lnames)
            
            L1=label_names(indices{iroi1});
            L2=label_names(indices{iroi2});
            
            check1=strcmp(L1{1}(end-7:end-6),L2{1}(end-7:end-6));
            
            %check2= contains(L1{1},'temporal')+contains(L2{1},'temporal');
            check2= contains(L1{1},'occipital')+contains(L2{1},'occipital');
            
            
            if check1+check2==2
                
              %  try
                    
                    save_file=[save_dir 'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq_tag ,...
                        '_split' num2str(tag) '_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    
                    if ~exist(save_file,'file')
                        
                        if ~exist([save_file(1:end-4) '.lock'],'file')
                            
                            fid=fopen([save_file(1:end-4) '.lock'],'w');
                            w=1;
                            fwrite(fid,w);
                            fclose(fid);
                            
                            
                            for isubj=1:length(subjects)
                                
                                subj=subjects{isubj};
                                
                                for icond1=1:6
                                    
                                    [ifreq isubj iroi1 icond1]
                                    
                                    cond1=conds(icond1);
                                    
                                    data(isubj,icond1,:,:)=cross_cond_icoh_subroi_all(subj,L1,L2,cond1,indf,tag,t1,t2);
                                    
                                end
                                
                            end
                            
                            %                         save([save_dir 'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq_tag ,...
                            %                             '_split' num2str(tag) '_time' num2str(t1) 'to' num2str(t2) 's.mat'],'data','L1','L2','subjects')
                            %
                            save(save_file,'data','L1','L2','subjects')
                            
                            clear data L1 L2
                            
                        end
                        
                    end
                    
%                 catch
%                     failed{k}=[iroi1,iroi2];
%                     k=k+1;
%                 end
%                 
            end
            
            
        end
        
        
    end
    
    
end



