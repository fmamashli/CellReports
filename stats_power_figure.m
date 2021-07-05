clear all
clc

addpath /autofs/space/voima_002/users/fahimeh_transcend/fm_functions/Mines
addpath /autofs/space/voima_002/users/fahimeh_transcend/fm_functions/npy-matlab-master/npy-matlab/
addpath  /autofs/space/taito_005/users/fahimeh/notBoxPlot-master/code

save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/';
save_fig_dir ='/autofs/space/taito_005/users/fahimeh/doc/Figures/Power/';

lname = {'superiortemporal_'};

% 
%tag='silent_impuse_';


%%% STG
ilabel=1;
ifreq=4;

tag='MeanTrials_lhrh_5freq_21subjs_impulse_';

file_name = [save_dir, tag,lname{ilabel},'_power.npy'];

p_power=readNPY(file_name);

% remove left handed
p_power([8,16],:)=[];

data(1,:)=p_power(:,ifreq);


tag='MeanTrials_lhrh_5freq_21subjs_silent_impuse_';

file_name = [save_dir, tag,lname{ilabel},'_power.npy'];

p_power=readNPY(file_name);

% remove left handed
p_power([8,16],:)=[];

data(2,:)=p_power(:,ifreq);



%%%% STG

ifreq=5;
ilabel=1;


tag='MeanTrials_lhrh_5freq_21subjs_impulse_';

file_name = [save_dir, tag,lname{ilabel},'_power.npy'];

p_power=readNPY(file_name);

% remove left handed
p_power([8,16],:)=[];

data(3,:)=p_power(:,ifreq);


tag='MeanTrials_lhrh_5freq_21subjs_silent_impuse_';

file_name = [save_dir, tag,lname{ilabel},'_power.npy'];

p_power=readNPY(file_name);

% remove left handed
p_power([8,16],:)=[];

data(4,:)=p_power(:,ifreq);

%%

CM = jet(size(data(1,:),2));
figure;

for i=1:size(data,2)
    
    
    x=[1,2];
    plot(x,[data(1,i),data(2,i)],'linewidth',2,'color',CM(i,:))
    hold on
    plot(x,[data(1,i),data(2,i)],'o','markersize',12,'markerfacecolor',CM(i,:), ...
        'markeredgecolor',CM(i,:))
    
end

xticks([1:2])
xticklabels({'No Impulse','Impulse'})
ylabel('Decoding accuracy')
set(gca,'fontsize',16)

figure;
boxplot(data')
line([0:5],ones(1,6)/6,'color','black','linestyle','--')

%%

figure;
notBoxPlot(data')
line([0:5],ones(1,6)/6,'color','black','linestyle','--')
ylim([0.05 0.6])

print([save_fig_dir 'power_lhrh_STG_mean_accuracy_19_subjects_individual'],'-dpdf')


%% run correction in R

%mydata = read.csv(file="/autofs/space/taito_005/users/fahimeh/resources/power/MeanTrials_5freq_stimulus_uncorrected_pvalues.csv", header=FALSE, sep=",")
%p = p.adjust(as.numeric(mydata[[1]]),'fdr')
%write.table(p,file="/autofs/space/taito_005/users/fahimeh/resources/power/MeanTrials_5freq_stimulus_corrected_pvalues.txt",sep="",row.names=FALSE)

%% Read R results here
clc

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

tag='MeanTrials_5freq_impulse_';

fid=fopen([save_dir,tag,'corrected_pvalues.txt']);
C=textscan(fid,'%s');
corr_p=C{1,1};

for i=2:length(corr_p)
    
    corrected_p(i-1) = str2double(corr_p{i});
    
end

kk=1;
for ifre=1:5
    
    for ii=1:length(lname)
        
        roi_f{kk,1}=[lname{ii},'-',freqs{ifre}];
        kk=kk+1;
    
    end
    
end

roi_f(corrected_p<0.05)



