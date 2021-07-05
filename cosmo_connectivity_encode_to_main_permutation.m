clear all; close all; fclose all;
clc

% addpath /space/voima/1/users/matlab/CoSMoMVPA-master/
% addpath /space/voima/1/users/matlab/CoSMoMVPA-master/mvpa
% addpath /space/voima/1/users/matlab/toolbox/libsvm-master/
% addpath /space/voima/1/users/matlab/libsvm-master/matlab
% addpath /homes/9/jyrki/matlab/toolbox/CoSMoMVPA-master/mvpa
% addpath /autofs/homes/009/jyrki/matlab/toolbox/libsvm-master/
% addpath /autofs/homes/009/jyrki/matlab/toolbox/libsvm-master/matlab
% addpath /homes/9/jyrki/matlab/toolbox/CoSMoMVPA-master/

%%
addpath /space/voima/1/users/matlab/CoSMoMVPA-master/
addpath /space/voima/1/users/matlab/CoSMoMVPA-master/mvpa
%addpath /space/voima/1/users/matlab/toolbox/libsvm-master/
addpath /space/voima/1/users/matlab/libsvm-master/matlab


%%

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
    'supramarginal_rh'};

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
    'rSM'};


indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154]};


%%
dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

perms=load([dpath 'total_permutations.mat']);
%P = perms([1:6]);

target_train_p=perms.total_perm;

nPerm=50;
accuracy_total=zeros(5,12,nPerm);
accuracy_true=zeros(5,12);

inds=[1:5,7:13,15:19];

run_perm=1;

for freqi=1:5
    
    freq=freqs{freqi};
    k=1;
    for iroi1=2:length(lnames)-1
        
        for iroi2=iroi1+1:length(lnames)
            
            L1=label_names(indices{iroi1});
            L2=label_names(indices{iroi2});
            
            
            check1=strcmp(L1{1}(end-7:end-6),L2{1}(end-7:end-6));
            
            check2= contains(L1{1},'temporal')+contains(L2{1},'temporal');
            
            if check1+check2==2 && check2<2
                
                name_tag='3002to3017';
                t1=0;
                t2=1;
                
                try
                    [freqi k]
                    
                    fn1=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split1_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    fn2=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split2_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    fn3=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split3_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    fn4=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split4_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    
                    d1=load(fn1);d2=load(fn2);
                    d3=load(fn3);d4=load(fn4);
                    
                    [nsubjs, nc, nroi1, nroi2]=size(d1.data);
                    
                    
                    name_tag='1002to1017';
                    t1=0.5;
                    t2=2;
                    
                    fn1=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split1_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    fn2=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split2_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    fn3=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split3_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    fn4=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split4_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                    
                    d1m=load(fn1);d2m=load(fn2);
                    d3m=load(fn3);d4m=load(fn4);
                    
                    [nsubjsm, ncm, nroi1m, nroi2m]=size(d1m.data);
                    
                    
                    
                    vols1=[];vols2=[];vols3=[];vols4=[];
                    vols1m=[];vols2m=[];vols3m=[];vols4m=[];
                    mvpaRes=[];
                    
                    if(isempty(vols1)),vols1=zeros(nsubjs,nc,nroi1,nroi2);vols2=vols1; vols3=vols1; vols4=vols1; end
                    
                    
                    if(isempty(vols1m)),vols1m=zeros(nsubjsm,ncm,nroi1m,nroi2m);vols2m=vols1m; vols3m=vols1m; vols4m=vols1m; end
                    
                    
                    vols1(:,:,:,:)=(d1.data);
                    vols2(:,:,:,:)=(d2.data);
                    vols3(:,:,:,:)=(d3.data);
                    vols4(:,:,:,:)=(d4.data);
                    
                    
                    vols1=vols1(inds,:,:,:);
                    
                    vols2=vols2(inds,:,:,:);
                    
                    vols3=vols3(inds,:,:,:);
                    
                    vols4=vols4(inds,:,:,:);
                    
                    
                    
                    vols1m(:,:,:,:)=(d1m.data);
                    vols2m(:,:,:,:)=(d2m.data);
                    vols3m(:,:,:,:)=(d3m.data);
                    vols4m(:,:,:,:)=(d4m.data);
                    
                    
                    vols1m=vols1m(inds,:,:,:);
                    
                    vols2m=vols2m(inds,:,:,:);
                    
                    vols3m=vols3m(inds,:,:,:);
                    
                    vols4m=vols4m(inds,:,:,:);
                    
                    
                    ns = size(vols1,1);
                    
                    
                    HR  = zeros(ns,4);
                    
                    %  if(isempty(mvpaRes)), mvpaRes=zeros(ns,1);end
                    
                    for sidx=1:ns
                        
                        pred_vect=[]; targ_vect=[];
                        
                        vols=[vols1(sidx,:,:); vols2(sidx,:,:); vols3(sidx,:,:); vols4(sidx,:,:)];
                        
                        volsm=[vols1m(sidx,:,:); vols2m(sidx,:,:); vols3m(sidx,:,:); vols4m(sidx,:,:)];
                        
                        targets_train=[(1:6)';(1:6)'; (1:6)'];
                        %  targets_train=[(1:6)';(1:6)'; (1:6)'; (1:6)'];
                        targets_test=(1:6)';
                        
                        runs=1:size(vols,1);
                       % foldk=1;
                        for fold=1:4
                            
                            traini=runs(~ismember(runs,fold));
                            
                            samples_train= [squeeze(vols(traini(1),:,:));squeeze(vols(traini(2),:,:)); squeeze(vols(traini(3),:,:))];
                            
                            
                            %    samples_train= [squeeze(vols(1,:,:));squeeze(vols(2,:,:)); squeeze(vols(3,:,:));squeeze(vols(4,:,:))];
                            samples_test = squeeze(volsm(fold,:,:));
                            
                            %  [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED, MU] = pca(samples_train);
                            
                            samples_train=samples_train(:,:); %samples_train=samples_train-mean(samples_train(:));
                            samples_test=samples_test(:,:); %samples_test=samples_test-mean(samples_test(:));
                            % opt=[];
                            
                            % opt.autoscale=true;
                            
                            predicted = cosmo_classify_libsvm(samples_train, targets_train, samples_test);
                            HR(sidx,fold)=sum(targets_test==predicted)/6;
                            
                         %   foldk=foldk+1;
                            
                            clear predicted samples_train samples_test
                            
                            
                        end
                        
                        clear vols volsm
                        
                    end
                    
                    
                    mvpaRes=mean(mean(HR,2));
                    
                    accuracy_true(freqi,k)=mvpaRes;
                    
                    std_acc(freqi,k)=std(mean(HR,2));
                    
                    clear mvpaRes HR
                    
                    
                    if run_perm
                        
                        for iperm=1:nPerm
                            
                            mvpaRes=[];
                            HR  = zeros(ns,4);
                            
                            %    if(isempty(mvpaRes)), mvpaRes=zeros(ns,1);end
                            
                            
                            targets_trainP=target_train_p(iperm,:);
                            HR  = zeros(ns,4);
                            
                            for sidx=1:ns
                                
                                pred_vect=[]; targ_vect=[];
                                
                                vols=[vols1(sidx,:,:); vols2(sidx,:,:); vols3(sidx,:,:); vols4(sidx,:,:)];
                                
                                volsm=[vols1m(sidx,:,:); vols2m(sidx,:,:); vols3m(sidx,:,:); vols4m(sidx,:,:)];
                                
                                % we permute the target class
                                
                                runs=1:size(vols,1);
                                
                              %  foldk=1;
                                for fold=1:4
                                    
                                    traini=runs(~ismember(runs,fold));
                                    
                                    samples_train= [squeeze(vols(traini(1),:,:));squeeze(vols(traini(2),:,:)); squeeze(vols(traini(3),:,:))];
                                    
                                    
                                    % samples_train= [squeeze(vols(1,:,:));squeeze(vols(2,:,:)); squeeze(vols(3,:,:));squeeze(vols(4,:,:))];
                                    samples_test = squeeze(volsm(fold,:,:));
                                    
                                    %  [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED, MU] = pca(samples_train);
                                    
                                    samples_train=samples_train(:,:); %samples_train=samples_train-mean(samples_train(:));
                                    samples_test=samples_test(:,:); %samples_test=samples_test-mean(samples_test(:));
                                    % opt=[];
                                    predicted = cosmo_classify_libsvm(samples_train, targets_trainP, samples_test);
                                    HR(sidx,fold)=sum(targets_test==predicted)/6;
                                    
                                %    foldk=foldk+1;
                                    
                                    clear predicted samples_train samples_test
                                    
                                    
                                end
                                
                                clear vols volsm
                                
                            end
                            
                            mvpaRes=mean(mean(HR,2));
                            
                            
                            accuracy_total(freqi,k,iperm)=mvpaRes;
                            
                            clear HR mvpaRes
                            
                        end
                        
                    end
                    
                    
                    k=k+1;
                    
                    
                    
                catch
                    
                end
                
            end
            
        end
        
    end
    
end


%save([dpath,  'encodetomain_connectivity_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat'],'accuracy','roi_to_roi')

%%
max_stats=squeeze(max(max(accuracy_total)));


true_acc = accuracy_true(:);


