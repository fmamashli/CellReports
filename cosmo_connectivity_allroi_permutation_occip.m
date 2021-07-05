clear all; close all; fclose all;
clc


addpath /space/voima/1/users/matlab/CoSMoMVPA-master/
addpath /space/voima/1/users/matlab/CoSMoMVPA-master/mvpa
%addpath /space/voima/1/users/matlab/toolbox/libsvm-master/
addpath /space/voima/1/users/matlab/libsvm-master/matlab



fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt');
C=textscan(fid,'%s');
label_names=C{1,1};


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

ROIs = {'rACC',
    'rCMF',
    'rOF',
    'rIFG',
    'rRMF',
    'rPrC',
    'rST',
    'lOF',
    'lIFG',
    'lCMF',
    'lRMF',
    'lPrC',
    'lST',
    'lSM',
    'rSM',
    'lLO',
    'rLO'};

name_tag='1002to1017';
%name_tag='3002to3017';
%name_tag='2102to2117';


if strcmp(name_tag,'1002to1017')
    t1=0.5;
    %t1=1.25;
    t2=2;
    %t2=2;
else
    t1=0;
    t2=1;
end



% indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68], ...
%     [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154]};

indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154],[155:165],[166:175]};



dpath = '/autofs/space/tahto_001/users/fahimeh/awmrc_resource2/coherence/large_subroi/';
%dpath = '/autofs/space/tahto_001/users/fahimeh/awmrc_resource2/coherence/large_subroi/';


freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

%%

perms=load(['/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/total_permutations.mat']);
%P = perms([1:6]);

target_train_p=perms.total_perm;

nPerm=2000;
accuracy_total=zeros(5,14,nPerm);
accuracy_true=zeros(5,14);


for freqi=1:5
    
    
    freq=freqs{freqi};
    k=1;
    
    for iroi1=2:length(lnames)-2
        
        for iroi2=length(lnames)-1:length(lnames)
            
            L1=label_names(indices{iroi1});
            L2=label_names(indices{iroi2});
            
            
            check1=strcmp(L1{1}(end-7:end-6),L2{1}(end-7:end-6));
            
             check2= contains(L1{1},'temporal')+contains(L2{1},'temporal');
            
            if check1 
                
                fn1=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split1_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                fn2=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split2_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                fn3=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split3_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                fn4=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split4_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                
                d1=load(fn1);d2=load(fn2);
                d3=load(fn3);d4=load(fn4);
                
                [nsubjs, nc, nroi1, nroi2]=size(d1.data);
                
                vols1=[];vols2=[];vols3=[];vols4=[];
                mvpaRes=[];
                
                if(isempty(vols1)),vols1=zeros(nsubjs,nc,nroi1,nroi2);vols2=vols1; vols3=vols1; vols4=vols1; end
                
                
                vols1(:,:,:,:)=abs(d1.data);
                vols2(:,:,:,:)=abs(d2.data);
                vols3(:,:,:,:)=abs(d3.data);
                vols4(:,:,:,:)=abs(d4.data);
                
                 
                
                nsubjs=size(vols1,1);
                
                
                HR  = zeros(nsubjs,4);
                
                if(isempty(mvpaRes)), mvpaRes=zeros(nsubjs,1);end
                
                for sidx=1:nsubjs
                    
                    pred_vect=[]; targ_vect=[];
                    
                    vols=[vols1(sidx,:,:); vols2(sidx,:,:); vols3(sidx,:,:); vols4(sidx,:,:)];
                    
                    targets_train=[(1:6)';(1:6)'; (1:6)'];
                    targets_test=(1:6)';
                    
                    runs=1:size(vols,1);
                    
                    for fold=1:length(runs)
                        
                        traini=runs(~ismember(runs,fold));
                        
                        samples_train= [squeeze(vols(traini(1),:,:));squeeze(vols(traini(2),:,:)); squeeze(vols(traini(3),:,:))];
                        samples_test = squeeze(vols(fold,:,:));
                        
                        
                        samples_train=samples_train(:,:); %samples_train=samples_train-mean(samples_train(:));
                        samples_test=samples_test(:,:); %samples_test=samples_test-mean(samples_test(:));
                        
                        predicted = cosmo_classify_libsvm(samples_train, targets_train, samples_test);
                        HR(sidx,fold)=sum(targets_test==predicted)/6;
                        
                    end
                    
                    clear vols
                    
                end
                
                mvpaRes=mean(mean(HR,2));
                % removing left handed subjects
                %mvpaRes([6,14])=[];
                
                accuracy_true(freqi,k)=mvpaRes;
                
                clear mvpaRes
                
                for iperm=1:nPerm
                    
                    mvpaRes=[];
                    HR  = zeros(nsubjs,4);
                    
                    if(isempty(mvpaRes)), mvpaRes=zeros(nsubjs,1);end
                    
                    targets_trainP=target_train_p(iperm,:);
                    
                    
                    
                    for sidx=1:nsubjs
                        
                        pred_vect=[]; targ_vect=[];
                        
                        vols=[vols1(sidx,:,:); vols2(sidx,:,:); vols3(sidx,:,:); vols4(sidx,:,:)];
                        
                        
                        % we permute the target class
                        
                        
                        runs=1:size(vols,1);
                        
                        for fold=1:length(runs)
                            
                            traini=runs(~ismember(runs,fold));
                            
                            samples_train= [squeeze(vols(traini(1),:,:));squeeze(vols(traini(2),:,:)); squeeze(vols(traini(3),:,:))];
                            samples_test = squeeze(vols(fold,:,:));
                            
                            
                            samples_train=samples_train(:,:); %samples_train=samples_train-mean(samples_train(:));
                            samples_test=samples_test(:,:); %samples_test=samples_test-mean(samples_test(:));
                            
                            
                            targets_test=(1:6)';
                            
                            
                            predicted = cosmo_classify_libsvm(samples_train, targets_trainP, samples_test);
                            HR(sidx,fold)=sum(targets_test==predicted)/6;
                            
                        end
                        
                        clear vols
                        
                    end
                    
                    mvpaRes=mean(mean(HR,2));
                    
                    
                    accuracy_total(freqi,k,iperm)=mvpaRes;
                    
                    
                end
                
                %roi_to_roi{k,1}=[ROIs{iroi1} '-' ROIs{iroi2}];
                
                k=k+1;
                
                
            end
            
        end
        
    end
    
    
    
end



save([dpath, name_tag, '_connectivity_5freq_subjects_accuracy_perm_2000_allfreqs_occipital_' freq '_' num2str(t1) 'to' num2str(t2) 's.mat'],...
    'accuracy_total','accuracy_true')

%%

load([dpath, name_tag, '_connectivity_5freq_subjects_accuracy_perm_2000_allfreqs_occipital_HighGamma_' num2str(t1) 'to' num2str(t2) 's.mat'])

max_stats=squeeze(max(max(accuracy_total)));


true_acc = accuracy_true(:);


figure;hist(max_stats(:));title('null dist-occipital-mean subjs')
figure;hist(true_acc(:));title('original-occipital-mean subjs')


for icon=1:70
    corrected_p(icon)=(sum(max_stats>true_acc(icon))+1)/2001;
end


kk=1;
for freqi=1:5
    
    
    freq=freqs{freqi};
    
    
    for iroi1=2:length(lnames)-2
        
        for iroi2=length(lnames)-1:length(lnames)
            
            
            L1=label_names(indices{iroi1});
            L2=label_names(indices{iroi2});
            
            
            check1=strcmp(L1{1}(end-7:end-6),L2{1}(end-7:end-6));
            
           % check2= contains(L1{1},'temporal')+contains(L2{1},'temporal');
            
            if check1
                
                roi_to_roi{kk,1}=[freq '-' ROIs{iroi1} '-' ROIs{iroi2}];
                kk=kk+1;
            end
            
        end
        
    end
    
end

roi_to_roi(corrected_p<0.01)
true_acc(corrected_p<0.05)
corrected_p(corrected_p<0.01)'


%%
close all
dpath = '/autofs/space/tahto_001/users/fahimeh/awmrc_resource2/coherence/large_subroi/';

t1=0.5;
t2=1.25;

roip1=load([dpath, name_tag, '_connectivity_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat']);

t1=1.25;
t2=2;

roip2=load([dpath, name_tag, '_connectivity_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat']);



dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

t1=0.5;
t2=2;

roip3=load([dpath, name_tag, '_connectivity_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat']);

figure;
imagesc(roip1.roi_p<0.05);axis xy
title('from 0.5 to 1.25s')

figure;
imagesc(roip2.roi_p<0.05);axis xy
title('from 1.25 to 2s')

figure;
imagesc(roip3.roi_p<0.05);axis xy
title('from 0.5 to 2s')





%%
close all
dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

load([dpath, name_tag, '_connectivity_5freq_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat'])

save_fig_dir='/autofs/space/taito_005/users/fahimeh/doc/Figures/coherence/results/';

figure;
for i=1:5
    plot(accuracy_mean(i,:),'LineWidth',2)
    hold on
end
ylim([0.15 .45])
legend('Theta','Alpha','Beta','LowGamma','HighGamma')
xticks([1:12])
xticklabels(roi_to_roi_copy)
print([save_fig_dir name_tag '_accuracy_mean'],'-dpdf','-bestfit')

print([save_fig_dir name_tag '_accuracy_mean'],'-dpng')
