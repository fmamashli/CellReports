clear all
clc

addpath /autofs/space/voima_002/users/fahimeh_transcend/fm_functions/Mines
addpath /autofs/space/voima_002/users/fahimeh_transcend/fm_functions/npy-matlab-master/npy-matlab/

save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/';

lname = {'caudalmiddlefrontal_rh',
 'lateralorbitofrontal_rh',
 'parsopercularis_rh',
 'rostralmiddlefrontal_rh',
 'precentral_rh',
 'superiortemporal_rh',
 'lateralorbitofrontal_lh',
 'parsopercularis_lh',
 'caudalmiddlefrontal_lh',
 'rostralmiddlefrontal_lh',
 'precentral_lh',
 'superiortemporal_lh',
 'supramarginal_lh',
 'supramarginal_rh'};

% lname = {
%  'superiortemporal_rh',
%  'superiortemporal_lh'};

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
