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

addpath /space/voima/1/users/matlab/CoSMoMVPA-master/
addpath /space/voima/1/users/matlab/CoSMoMVPA-master/mvpa
addpath /space/voima/1/users/matlab/toolbox/libsvm-master/
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




%%%%%%%%%%%%%%%%%%%%%

name_tag='1002to1017';

if strcmp(name_tag,'1002to1017')
   % t1=0.5;
    t1=1.25;
    t2=2;
    %t2=2;
else
    t1=0;
    t2=1;
end

% for 0.5 to 2s
if t1==0.5 && t2==2 || strcmp(name_tag,'3002to3017')
    dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';
else
    % for 0.5 to 1.25 s, 1.25 to 2s
    dpath = '/autofs/space/tahto_001/users/fahimeh/awmrc_resource2/coherence/large_subroi/';
end

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

inds=[1:5,7:13,15:19];

nPerm=500;
true_accuracy=zeros(5,12);
permute_accuracy=zeros(5,12,nPerm);

run_perm = 0;


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
                
                fn1=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split1_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                fn2=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split2_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                fn3=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split3_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                fn4=[dpath  'iCoh_allsubj_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq '_split4_time' num2str(t1) 'to' num2str(t2) 's.mat'];
                
                d1=load(fn1);d2=load(fn2);
                d3=load(fn3);d4=load(fn4);
                
                [nsubjs, nc, nroi1, nroi2]=size(d1.data);
                
                vols1=[];vols2=[];vols3=[];vols4=[];
                
                
                if(isempty(vols1)),vols1=zeros(nsubjs,nc,nroi1,nroi2);vols2=vols1; vols3=vols1; vols4=vols1; end
                
                vols1(:,:,:,:)=(d1.data);
                vols2(:,:,:,:)=(d2.data);
                vols3(:,:,:,:)=(d3.data);
                vols4(:,:,:,:)=(d4.data);
                
                
                if t1==0.5 && t2==2 || strcmp(name_tag,'3002to3017')
                    
                    vols1=vols1(inds,:,:,:);
                    
                    vols2=vols2(inds,:,:,:);
                    
                    vols3=vols3(inds,:,:,:);
                    
                    vols4=vols4(inds,:,:,:);
                    
                end
                
                vols=[vols1; vols2; vols3; vols4];
                
                X = [squeeze(vols(:,1,:,:));squeeze(vols(:,2,:,:));squeeze(vols(:,3,:,:)); ...
                    squeeze(vols(:,4,:,:));squeeze(vols(:,5,:,:));squeeze(vols(:,6,:,:))];
                
                Y = [ones(68,1)*1;ones(68,1)*2;ones(68,1)*3;ones(68,1)*4; ...
                    ones(68,1)*5;ones(68,1)*6];
                
                
                for fold=1:100
                    
                    rp=randperm(68);
                    
                    train_ind = rp(1:51);
                    test_ind = rp(52:end);
                    
                    ind_train=[];
                    ind_test = [];
                    
                    for i=1:6
                        
                        ind_train = [ind_train,train_ind+(i-1)*68];
                        ind_test = [ind_test,test_ind+(i-1)*68];
                        
                    end
                    
                    targets_train = Y(ind_train);
                    targets_test = Y(ind_test);
                    
                    samples_train= X(ind_train,:);
                    samples_test = X(ind_test,:);
                    
                    opt.autoscale=true;
                    
                    predicted = cosmo_classify_libsvm(samples_train, targets_train, samples_test, opt);
                    HR(fold)=sum(targets_test==predicted)/length(targets_test);
                    mx=cosmo_confusion_matrix(targets_test, predicted);
                    conf(fold,:,:)=mx;
                    
                    
                    clear rp train_ind test_ind ind_train ind_test
                    
                end
                
                
                roi_to_roi{k,1}=[lnames{iroi1} '-' lnames{iroi2}];
                true_accuracy(freqi,k)=mean(HR);
                
                
                save([dpath,'confusion_matrix_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq,...
                    '_split1_time' num2str(t1) 'to' num2str(t2) 's.mat' ],'conf');
                
                
                clear HR conf
                
                [freqi k]
                
                tic
                
                if run_perm
                    
                for iperm = 1:nPerm
                    
                    rp=randperm(68);
                    
                    train_ind = rp(1:51);
                    test_ind = rp(52:end);
                    
                    ind_train=[];
                    ind_test = [];
                    
                    for i=1:6
                        
                        ind_train = [ind_train,train_ind+(i-1)*68];
                        ind_test = [ind_test,test_ind+(i-1)*68];
                        
                    end
                    
                    
                    targets_train = Y(ind_train);
                    targets_test = Y(ind_test);
                    
                    targets_train = targets_train(randperm(length(ind_train)));
                    
                    samples_train= X(ind_train,:);
                    samples_test = X(ind_test,:);
                    
                    opt.autoscale=true;
                    
                    predicted = cosmo_classify_libsvm(samples_train, targets_train, samples_test, opt);
                    permute_accuracy(freqi,k,iperm)=sum(targets_test==predicted)/length(targets_test);
                    
                    clear targets_train
                    
                end
                
                end
                
                toc
                
                k=k+1;
                
            end
            
        end
        
    end
    
end

%save([dpath, 'maintenance_connectivity_5freq_subjects_group_level_500perm_' name_tag '_' num2str(t1) 'to' num2str(t2) 's.mat'],...
%    'permute_accuracy','true_accuracy')

%%

close all

name_tag='1002to1017';
t1=0.5;t2=1.25;

fig_dir = '/autofs/space/taito_005/users/fahimeh/doc/Figures/coherence/review/';

%t1=0.5;t2=2;

if t1==0.5 && t2==2 || strcmp(name_tag,'3002to3017')
    
    dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';
    
    if ~strcmp(name_tag,'3002to3017')
    
     tt=load([dpath, 'maintenance_connectivity_5freq_subjects_group_level_500perm_' num2str(t1) 'to' num2str(t2) 's.mat'])

    else
    
      
      tt = load([dpath, 'maintenance_connectivity_5freq_subjects_group_level_500perm_' name_tag '_' num2str(t1) 'to' num2str(t2) 's.mat'])
    
    end
    
else
    % for 0.5 to 1.25 s, 1.25 to 2s
    dpath = '/autofs/space/tahto_001/users/fahimeh/awmrc_resource2/coherence/large_subroi/';
    tt=load([dpath, 'maintenance_connectivity_5freq_subjects_group_level_500perm_' num2str(t1) 'to' num2str(t2) 's.mat'])

end


Tmax_stats=squeeze(max(max(tt.permute_accuracy)));


Ttrue_acc = tt.true_accuracy(:);

threshold=0.3;
sum(Tmax_stats>threshold)/500

%%

figure;hist(Tmax_stats(:),10);title(['null distribution' name_tag num2str(t1) 'to' num2str(t2) 's'])
xlim([.2 .5])

line([threshold threshold],[0 100],'color','black')
xlabel('Accuracy')

set(gca,'fontsize',12)

%print([fig_dir name_tag '_null' num2str(t1) 'to' num2str(t2) 's'],'-dpdf')



figure;hist(Ttrue_acc(:),10);title(['original values' name_tag])
xlim([.2 .5])
hold on
line([threshold threshold],[0 10],'color','black')
xlabel('Accuracy')

set(gca,'fontsize',12)

%print([fig_dir name_tag '_original' num2str(t1) 'to' num2str(t2) 's'],'-dpdf')





index_roi=[1:6,9,7,8,10:12];

figure;bar(tt.true_accuracy(:,index_roi)')

title(name_tag)

hold on
line([1 12],[threshold threshold],'color','black','linestyle','--')
ylabel('Accuracy')

ylim([0 0.5])

set(gca,'fontsize',12)

%print([fig_dir name_tag '_bar' num2str(t1) 'to' num2str(t2) 's'],'-dpdf')


%%
freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

kk=1;
for freqi=1:5
    
    
    freq=freqs{freqi};
    
    
    for iroi1=2:length(lnames)-1
        
        for iroi2=iroi1+1:length(lnames)
            
            
            L1=label_names(indices{iroi1});
            L2=label_names(indices{iroi2});
            
            
            check1=strcmp(L1{1}(end-7:end-6),L2{1}(end-7:end-6));
            
            check2= contains(L1{1},'temporal')+contains(L2{1},'temporal');
            
            if check1+check2==2 && check2<2
                
                roi_to_roi{kk,1}=[freq '-' ROIs{iroi1} '-' ROIs{iroi2}];
                kk=kk+1;
            end
            
        end
        
    end
    
end

%%
sum(Tmax_stats>.33)/500
roi_to_roi(Ttrue_acc>.33)
