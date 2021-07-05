clear all
clc
close all

dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';


p1=load([dpath , 'EtoM_4fold_connectivity_5freq_uncorrected_pvalues.mat']);
p2=load([dpath , '3002to3017_connectivity_5freq_uncorrected_pvalues.mat']);
p3=load([dpath , '1002to1017_connectivity_5freq_uncorrected_pvalues.mat']);
%p4=load([dpath , '1002to1017_subjects_connectivity_5freq_uncorrected_pvalues.mat']);


pp = [p1.p_value;p2.p_value;p3.p_value];

save_p = [dpath , 'ALL_4fold_connectivity_5freq_uncorrected_pvalues.csv'];
csvwrite(save_p,pp)