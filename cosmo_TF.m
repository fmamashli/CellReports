clear all; close all; fclose all;
clc



%%
addpath /space/voima/1/users/matlab/CoSMoMVPA-master/
addpath /space/voima/1/users/matlab/CoSMoMVPA-master/mvpa
addpath /space/voima/1/users/matlab/toolbox/libsvm-master/


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
    'anteriorcingulate_lh',
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
    'lACC',
    'lOF',
    'lIFG',
    'lCMF',
    'lRMF',
    'lPrC',
    'lST',
    'lSM',
    'rSM'};

name_tag='1002to1017';
%name_tag='2002to2017';
%name_tag='2102to2117';


if strcmp(name_tag,'1002to1017')
    t1=0.5;
    t2=2;
else
    t1=0;
    t2=1.5;
end


indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68],[69:72], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154]};

%%

tt=load('/autofs/space/taito_005/users/fahimeh/resources/power/TF_across_trials/power_ifg_beta_timeresolved.mat')

%%
dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

freqs={'Theta','Alpha','Beta','Gamma'};



for freqi=1:4
    
    freq=freqs{freqi};
    k=1;
    for iroi1=1:length(lnames)-1
        
        for iroi2=iroi1+1:length(lnames)
            
            L1=label_names(indices{iroi1});
            L2=label_names(indices{iroi2});
            
            
            check1=strcmp(L1{1}(end-7:end-6),L2{1}(end-7:end-6));
            
            check2= contains(L1{1},'temporal')+contains(L2{1},'temporal');
            
            if check1+check2==2
                
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
                
                HR  = zeros(nsubjs,4);
                
                if(isempty(mvpaRes)), mvpaRes=zeros(size(d1.data,1),1);end
                
                for sidx=1:size(d1.data,1)
                    
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
                
                
                mvpaRes=mean(HR,2);
                
                % removing left handed subjects
                mvpaRes([6,14])=[];
                [h p ci stat]=ttest(mvpaRes,1/6,'Tail','right');
                
                roi_to_roi{k,1}=[ROIs{iroi1} '-' ROIs{iroi2}];
                roi_p(freqi,k)=p;
                k=k+1;
                
                clear p
                
            end
            
        end
        
    end
    
end

indx=[1,7,9,12];

pp = roi_p;
pp(:,indx)=[];


p_value = pp(:);

save_p = [dpath , name_tag,'_connectivity_uncorrected_pvalues.csv'];
csvwrite(save_p,p_value)
%% run the R commands:
%mydata = read.csv(file="/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/2102to2117_connectivity_uncorrected_pvalues.csv", header=FALSE, sep=",")
%p = p.adjust(as.numeric(mydata[[1]]),'fdr')
%write.table(p,file="/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/2102to2117_connectivity_corrected_pvalues.txt",sep="",row.names=FALSE)

%%
clc
fid=fopen([dpath , name_tag,'_connectivity_corrected_pvalues.txt']);
C=textscan(fid,'%s');
corr_p=C{1,1};

for i=2:length(corr_p)
    
    corp(i-1) = str2double(corr_p{i});
    
end

roi_to_roi_copy = roi_to_roi;

roi_to_roi_copy(indx)=[];

roi_freq = cell(1);

kk=1;
for ii=1:11
    
    for jj=1:4
        
    roi_freq{kk}=[roi_to_roi_copy{ii} '-' freqs{jj}];
    kk=kk+1;
    
    end
    
end

roi_freq(corp<0.05)


