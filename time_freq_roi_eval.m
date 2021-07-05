clear all
clc
close all

%addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Coherence

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1}([3:7,9:15,17:21]);


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
visitNo='megdata';
cfg.protocol='aw';



%conds=[1002 1005 1008 1011 1014 1017 ];
conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];

FREQ=2:120;

theta=find(FREQ>3,1,'first'):find(FREQ>7,1,'first');
alpha=find(FREQ>7,1,'first'):find(FREQ>12,1,'first');
beta=find(FREQ>13,1,'first'):find(FREQ>29,1,'first');
gamma=find(FREQ>30,1,'first'):find(FREQ>58,1,'first');
highgamma = find(FREQ>62,1,'first'):find(FREQ>119,1,'first');

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

%pool=parpool('local',4);

INDF={theta,alpha,beta,gamma,highgamma};

for iLabel1=6:154
    
    
    for ifreq =1:5
        
        indf=INDF{ifreq};
        
        for isubj=1:length(subjects)
            
            subj=subjects{isubj};
            
            for icond=1:6
                
                cond1=conds(icond);
                
                try
                    
                    for ihalf=1:4
                        
                        [iLabel1 ifreq isubj]
                        
                        filename=[cfg.data_rootdir, subj,'/',visitNo,'/TF_split4_half',...
                            num2str(ihalf),'_',subj,'_', label_names{iLabel1}(1:end-6) '_cond' num2str(cond1),'epochs_AutoTF.mat'];
                        
                        tt=load(filename);
                        times=tt.times;
                        freq=tt.FREQ;
                        
                        indt=find(times>0,1,'first'):find(times>2,1,'first');
                        
                        half_data(ihalf,:)=mean(tt.Total(indf,:));
                        
                        
                    end
                    
                    
                    data_total(icond,:)=squeeze(mean(half_data));
                    
                    
                    clear half_data
                    
                catch
                    failed{isubj}=subj;
                end
                
            end
            
            subj_data(isubj,:)=mean(data_total);
            
            clear data_total
            
        end
        
        save(['/autofs/space/taito_005/users/fahimeh/resources/power/TF_across_trials/power_', ...
            label_names{iLabel1}(1:end-6) '_' freqs{ifreq} '_timeresolved.mat'],'subj_data','indt','times')
        
        
        
    end
    
end


%indstr=strfind(label_names{iLabel1}(1:end-6),'_');


%%
clear all
clc
close all

%addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Coherence

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1}([3:7,9:15,17:21]);


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
visitNo='megdata';
cfg.protocol='aw';



%conds=[1002 1005 1008 1011 1014 1017 ];
conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];

FREQ=2:120;

theta=find(FREQ>3,1,'first'):find(FREQ>7,1,'first');
alpha=find(FREQ>7,1,'first'):find(FREQ>12,1,'first');
beta=find(FREQ>13,1,'first'):find(FREQ>29,1,'first');
gamma=find(FREQ>30,1,'first'):find(FREQ>58,1,'first');
highgamma = find(FREQ>62,1,'first'):find(FREQ>119,1,'first');

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

%pool=parpool('local',4);

indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154],[155:165],[166:175]};

addpath /autofs/space/hypatia_001/users/fahimeh_MEG_Analyses/fm_functions/Mines
addpath /autofs/space/hypatia_001/users/fahimeh_MEG_Analyses/fm_functions/tfce


cfg=[];
cfg.nThreads=10;
cfg.nPerm=500;
cfg.test='pairedTtest';


for ifreq =1:5
    
    
    % figure;
    for iroi1=2:15
        
        
        L1=label_names(indices{iroi1});
        
        
        for iLabel1=1:length(L1)
            
            
            load(['/autofs/space/taito_005/users/fahimeh/resources/power/TF_across_trials/power_', ...
                L1{iLabel1}(1:end-6) '_' freqs{ifreq} '_timeresolved.mat'])
            
            
            subroi(iLabel1,:,:)=subj_data;
            
            
        end
        
        meanR=squeeze(mean(subroi));
        
        %     subplot(3,5,iroi1)
        
        S1=meanR(:,indt);
        T=times(indt);
        
        
        G1=double(S1);
        G2 = zeros(size(G1));
        
        tfceSTATS=cluster_tfce(G1,G2,cfg);
        
        
        save(['/autofs/space/taito_005/users/fahimeh/resources/power/TF_across_trials/stats_power_' ,...
            L1{iLabel1}(1:end-6) '_' freqs{ifreq}],'tfceSTATS','S1','T');
        
        
        
        %        plot_shadederror(S1,T,1);
        %       grid on
        
        % cluster stats1D with p=0.001; corrected bonferroni with 42.
        
        %    title(L1{iLabel1}(1:end-11))
        
        clear subj_data meanR
        clear tfceSTATS S1 T
        
        
    end
    
end

%%
clear all
clc
close all

%addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Coherence

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1}([3:7,9:15,17:21]);


clear C

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};


cfg.data_rootdir='/autofs/space/voima_001/users/awmrc/';
visitNo='megdata';
cfg.protocol='aw';



%conds=[1002 1005 1008 1011 1014 1017 ];
conds=[1002 1005 1008 1011 1014 1017 2002 2005 2008 2011 2014 2017 2102 2105 2108 2111 2114 2117];

FREQ=2:120;

theta=find(FREQ>3,1,'first'):find(FREQ>7,1,'first');
alpha=find(FREQ>7,1,'first'):find(FREQ>12,1,'first');
beta=find(FREQ>13,1,'first'):find(FREQ>29,1,'first');
gamma=find(FREQ>30,1,'first'):find(FREQ>58,1,'first');
highgamma = find(FREQ>62,1,'first'):find(FREQ>119,1,'first');

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

%pool=parpool('local',4);

indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154],[155:165],[166:175]};

addpath /autofs/space/hypatia_001/users/fahimeh_MEG_Analyses/fm_functions/Mines
addpath /autofs/space/hypatia_001/users/fahimeh_MEG_Analyses/fm_functions/tfce


cfg=[];
cfg.nThreads=10;
cfg.nPerm=500;
cfg.test='pairedTtest';

save_dir ='/autofs/space/taito_005/users/fahimeh/doc/Figures/Power/power_in_time/';

for iroi1=2:15
    
    
  
    for ifreq =1:5
        
        
        
        [ifreq iroi1]
        
        L1=label_names(indices{iroi1});
        
        iLabel1 = length(L1);
        
        load(['/autofs/space/taito_005/users/fahimeh/resources/power/TF_across_trials/stats_power_' ,...
            L1{iLabel1}(1:end-6) '_' freqs{ifreq}]);
        
        
        index = find(tfceSTATS.P_Values<0.01);
        
        if ~isempty(index)
            
            figure;
            subplot(2,1,1)
            plot_shadederror(S1,T,1);
         %   grid on
            title([L1{iLabel1}(1:end-6)])
            xlabel('time(s)')
            ylabel([freqs{ifreq} ' Power'])
            set(gca,'fontsize',10)
            
            
            subplot(2,1,2)
            plot(T,-log10(tfceSTATS.P_Values),'linewidth',2)
            hold on
            line([0 2],[1.3 1.3])
            xlim([0 2])
        %    grid on
            xlabel('time(s)')
            ylabel('-log10(pvalue)')
            set(gca,'fontsize',10)
            
            print([save_dir 'power_stats_' L1{iLabel1}(1:end-6) '_' freqs{ifreq} ],'-dpdf')
            close all
            % cluster stats1D with p=0.001; corrected bonferroni with 42.
            
            
        end
        
        clear subj_data meanR
        clear tfceSTATS S1 T
        
        
    end
    
    
    
    
    
    
end





