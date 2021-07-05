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

%name_tag='1002to1017';
% name_tag='3002to3017';
% %name_tag='2102to2117';
%
%
% if strcmp(name_tag,'1002to1017')
%     t1=0.5;
%     t2=2;
% else
%     t1=0;
%     t2=1;
% end


% indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68],[69:72], ...
%     [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154]};

indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154]};


%%
dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

v=[1/6,1/6,1/6,1/6,1/6,1/6];
D=diag(v);
X=triu(ones(6),1)*(-1/30);
Y=tril(ones(6),-1)*(-1/30);

contrast=D+X+Y;

for freqi=1:5
    
    freq=freqs{freqi};
    
    k=1;
    data1=[];
    data2=[];
    data3=[];
    data4=[];
    
    data1m=[];
    data2m=[];
    data3m=[];
    data4m=[];
    
    for iroi1=2:length(lnames)-1
        
        for iroi2=iroi1+1:length(lnames)
            
            L1=label_names(indices{iroi1});
            L2=label_names(indices{iroi2});
            
            
            check1=strcmp(L1{1}(end-7:end-6),L2{1}(end-7:end-6));
            
            check2= contains(L1{1},'temporal')+contains(L2{1},'temporal');
            
            if check1+check2==2
                
                name_tag='3002to3017';
                t1=0;
                t2=1;
                
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
                
                
                
                %                 vols1=[];vols2=[];vols3=[];vols4=[];
                %                 vols1m=[];vols2m=[];vols3m=[];vols4m=[];
                %                 mvpaRes=[];
                %
                %                 if(isempty(vols1)),vols1=zeros(nsubjs,nc,nroi1,nroi2);vols2=vols1; vols3=vols1; vols4=vols1; end
                %
                %
                %                 if(isempty(vols1m)),vols1m=zeros(nsubjsm,ncm,nroi1m,nroi2m);vols2m=vols1m; vols3m=vols1m; vols4m=vols1m; end
                %
                t1=reshape(d1.data,19,6,size(d1.data,3)*size(d1.data,4));
                t2=reshape(d2.data,19,6,size(d1.data,3)*size(d1.data,4));
                t3=reshape(d3.data,19,6,size(d1.data,3)*size(d1.data,4));
                t4=reshape(d4.data,19,6,size(d1.data,3)*size(d1.data,4));
                
                t1m=reshape(d1m.data,19,6,size(d1.data,3)*size(d1.data,4));
                t2m=reshape(d2m.data,19,6,size(d1.data,3)*size(d1.data,4));
                t3m=reshape(d3m.data,19,6,size(d1.data,3)*size(d1.data,4));
                t4m=reshape(d4m.data,19,6,size(d1.data,3)*size(d1.data,4));
                
                
                
                data1=cat(3,data1,t1);
                data2=cat(3,data2,t2);
                data3=cat(3,data3,t3);
                data4=cat(3,data4,t4);
                
                
                data1m=cat(3,data1m,t1m);
                data2m=cat(3,data2m,t2m);
                data3m=cat(3,data3m,t3m);
                data4m=cat(3,data4m,t4m);
                
                
            end
        end
        
    end
        
        HR  = zeros(nsubjs,4);
    
    %    if(isempty(mvpaRes)), mvpaRes=zeros(size(d1.data,1),1);end
    
    for sidx=1:size(d1.data,1)
        
        pred_vect=[]; targ_vect=[];
        
        vols=[data1(sidx,:,:); data2(sidx,:,:); data3(sidx,:,:); data4(sidx,:,:)];
        
        volsm=[data1m(sidx,:,:); data2m(sidx,:,:); data3m(sidx,:,:); data4m(sidx,:,:)];
        
        %                     vol1=squeeze(mean(vols));
        %
        %                     vol2=squeeze(mean(volsm));
        %
        for irun=1:4
            
            vol1=squeeze(vols(irun,:,:));
            vol2=squeeze(volsm(irun,:,:));
            
            
            for icond=1:6
                
                for icond2=1:6
                    
                    [r,p]=corr(vol1(icond,:)',vol2(icond2,:)','Type','Spearman');
                    
                    normr(icond,icond2)=atanh(r);
                    
                end
                
                
            end
            
            data=normr.*contrast;
            
            vec1=reshape(data,1,size(data,1)*size(data,2));
            
            mvec(irun)=sum(vec1);
            
            
            clear vol1 vol2
            
        end
        
        subject_mvec(sidx)=mean(mvec);
        
        
    end
    
    %                 save_hr{k,1}=HR;
    %                 mvpaRes=mean(HR,2);
    %
    %                 % removing left handed subjects
    %                 mvpaRes([6,14])=[];
    %                 [h p ci stat]=ttest(mvpaRes,1/6,'Tail','right')
    %
  %  roi_to_roi{k,1}=[ROIs{iroi1} '-' ROIs{iroi2}];
    
    subject_mvec([6,14])=[];
    
   % roi_p(k,:)= subject_mvec;
    
    [h p ci stat]=ttest(subject_mvec,0,'Tail','right')
    
    p_mean(freqi)=p;
    %                 accuracy_st_error(freqi,k)=std(mvpaRes)/sqrt(length(mvpaRes));
    %
    %                 accuracy(freqi,k,:)=mvpaRes;
    %
    
    
    clear p subject_mvec
    
end






%save([dpath, name_tag, '_connectivity_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat'],'accuracy','roi_to_roi')

%%
% removing lst-rST connection
indx=6;

pp = roi_p;
pp(:,indx)=[];


p_value = pp(:);

save([dpath , 'EtoM_connectivity_5freq_uncorrected_pvalues.mat'],'p_value');


save_p = [dpath , 'EtoM_connectivity_5freq_uncorrected_pvalues.csv'];
csvwrite(save_p,p_value)

accuracy_mean(:,indx)=[];
accuracy_st_error(:,indx)=[];

save([dpath, name_tag, '_connectivity_5freq_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat'],'accuracy_mean','accuracy_st_error')
%
% %% run the R commands:
% % > mydata = read.csv(file="/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/1002to1017_connectivity_5freq_uncorrected_pvalues.csv", header=FALSE, sep=",")
% % > p = p.adjust(as.numeric(mydata[[1]]),'fdr')
% % > write.table(p,file="/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/1002to1017_connectivity_5freq_corrected_pvalues.txt",sep="",row.names=FALSE)
%
% %%
% clc
% fid=fopen([dpath , name_tag,'_connectivity_5freq_corrected_pvalues.txt']);
% C=textscan(fid,'%s');
% corr_p=C{1,1};
%
% for i=2:length(corr_p)
%
%     corrected_p(i-1) = str2double(corr_p{i});
%
% end
%
% roi_to_roi_copy = roi_to_roi;
%
% roi_to_roi_copy(indx)=[];
%
% roi_freq = cell(1);
%
% kk=1;
% for ii=1:12
%
%     for jj=1:5
%
%         roi_freq{kk,1}=[roi_to_roi_copy{ii} '-' freqs{jj}];
%         kk=kk+1;
%
%     end
%
% end
%
% roi_freq(corrected_p<0.05)
%
% accuracy_mean(corrected_p<0.05)
%
% %%
% close all
% dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';
%
% load([dpath, name_tag, '_connectivity_5freq_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat'])
%
% save_fig_dir='/autofs/space/taito_005/users/fahimeh/doc/Figures/coherence/results/';
%
% figure;
% for i=1:5
%     plot(accuracy_mean(i,:),'LineWidth',2)
%     hold on
% end
% ylim([0.15 .45])
% legend('Theta','Alpha','Beta','LowGamma','HighGamma')
% xticks([1:12])
% xticklabels(roi_to_roi_copy)
% print([save_fig_dir name_tag '_accuracy_mean'],'-dpdf','-bestfit')
%
% print([save_fig_dir name_tag '_accuracy_mean'],'-dpng')
