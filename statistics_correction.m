clear all
clc

addpath /autofs/space/voima_002/users/fahimeh_transcend/fm_functions/Mines
addpath /autofs/space/voima_002/users/fahimeh_transcend/fm_functions/npy-matlab-master/npy-matlab/

save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/';

% lname = {'caudalmiddlefrontal_rh',
%  'lateralorbitofrontal_rh',
%  'parsopercularis_rh',
%  'rostralmiddlefrontal_rh',
%  'precentral_rh',
%  'superiortemporal_rh',
%  'lateralorbitofrontal_lh',
%  'parsopercularis_lh',
%  'caudalmiddlefrontal_lh',
%  'rostralmiddlefrontal_lh',
%  'precentral_lh',
%  'superiortemporal_lh',
%  'supramarginal_lh',
%  'supramarginal_rh'};

lname = {
 'superiortemporal_rh',
 'superiortemporal_lh'};

%tag='silent_impuse_';
%tag='MeanTrials_21subjs_5freq_silent_impuse_';
tag='MeanTrials_21subjs_5freq_impulse_';

for ilabel=1:length(lname)

file_name = [save_dir, tag,lname{ilabel},'_power.npy'];

p_power=readNPY(file_name);

% remove left handed
%p_power([6,14],:)=[];
p_power([8,16],:)=[];

[h,p,ci,stats]=ttest(p_power,1/6,'Tail','right');


p_value(ilabel,:)=p;

clear p

end

p = p_value(:);

%save([save_dir , tag,'_nostg_uncorrected_pvalues.mat'],'p');

save_p = [save_dir , tag,'_19subjs_STG_rh_lh_uncorrected_pvalues.csv'];
csvwrite(save_p,p)

%% run correction in R

%mydata = read.csv(file="/autofs/space/taito_005/users/fahimeh/resources/power/MeanTrials_5freq_stimulus_uncorrected_pvalues.csv", header=FALSE, sep=",")
%p = p.adjust(as.numeric(mydata[[1]]),'fdr')
%write.table(p,file="/autofs/space/taito_005/users/fahimeh/resources/power/MeanTrials_5freq_stimulus_corrected_pvalues.txt",sep="",row.names=FALSE)

%% Read R results here
clc

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};


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

%% merge lhrh STG with bilateral areas
clear all
tag='MeanTrials_5freq_silent_impuse_';
save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/';

p1=load([save_dir , tag,'_nostg_uncorrected_pvalues.mat']);

cond_tag='silent_impuse_';
tag='MeanTrials_lhrh_5freq_';

p2=load([save_dir , tag,cond_tag,'uncorrected_pvalues.mat']);


p=[p1.p;p2.p];

save_p = [save_dir , tag,'_lhrhSTG_uncorrected_pvalues.csv'];
csvwrite(save_p,p)

%mydata = read.csv(file="/autofs/space/taito_005/users/fahimeh/resources/power/MeanTrials_lhrh_5freq__lhrhSTG_uncorrected_pvalues.csv", header=FALSE, sep=",")