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
%  'supramarginal_rh'};

lname = {'superiortemporal_rh'};

cond_tag='silent_impuse_';
tag='MeanTrials_lhrh_5freq_21subjs_';
%cond_tag='';
%cond_tag='impulse_';

for ilabel=1:length(lname)

file_name = [save_dir, tag,cond_tag,lname{ilabel}(1:end-3),'__power.npy'];

p_power=readNPY(file_name);

% remove left handed
p_power([6,14],:)=[];

[h,p,ci,stats]=ttest(p_power,1/6,'Tail','right');


p_value(ilabel,:)=p;

clear p

end

p = p_value(:);

save_p=[save_dir , tag,cond_tag,'_STGmerged_uncorrected_pvalues'];

save([save_p '.mat'],'p');

csvwrite([save_p '.csv'],p)

%% run correction in R

%mydata = read.csv(file="/autofs/space/taito_005/users/fahimeh/resources/power/MeanTrials_lhrh_5freq_21subjs_silent_impuse_uncorrected_pvalues.csv", header=FALSE, sep=",")
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



