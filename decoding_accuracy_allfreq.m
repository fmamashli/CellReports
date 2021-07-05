clear all; close all; fclose all;
clc


name_tag='1002to1017';

[M1,accuracy1]=load_awm_decode(name_tag);

maintenance=M1([2,4:5],:);

name_tag='3002to3017';

[M2,accuracy2]=load_awm_decode(name_tag);

encoding = M2([2,4:5],:);

save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/';

info='Alpha_LowGamma_HighGamma_by_Nsubjects_decoding';

save([save_dir 'decoding_subjects_alpha_LGamma_HGama.mat'],'maintenance','encoding','info')




