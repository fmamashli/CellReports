clear all
clc

name_tag='1002to1017';
%name_tag='3002to3017';
%name_tag='2102to2117';


if strcmp(name_tag,'1002to1017')
    t1=0.5;
    t2=2;
else
    t1=0;
    t2=1;
end


dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

total = load([dpath, name_tag, '_connectivity_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat']);
averaged_stg = load([dpath, name_tag, '_connectivity_avgSTG_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat']);
averaged_nonstg = load([dpath, name_tag, '_connectivity_nonSTG_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat']);

total.accuracy(:,6,:)=[];
averaged_stg.accuracy(:,6,:)=[];
averaged_nonstg.accuracy(:,6,:)=[];

t1 = total.accuracy;
t2=averaged_stg.accuracy;
t3=averaged_nonstg.accuracy;

t1 = permute(t1,[3,2,1]);
t2 = permute(t2,[3,2,1]);
t3 = permute(t3,[3,2,1]);

% t1 = t1(:,:);
% t2 = t2(:,:);
% t3 = t3(:,:);

clc
%fid=fopen([dpath , name_tag,'_connectivity_5freq_corrected_pvalues.txt']);

fid=fopen([dpath ,'ALL_4fold_connectivity_5freq_corrected_pvalues.txt']);

C=textscan(fid,'%s');
corr_p=C{1,1};

for i=2:length(corr_p)
    
    corrected_p(i-1) = str2double(corr_p{i});
    
end

corr_p=corrected_p(121:180);

kk=1;
for ii=1:12
    
    for jj=1:5
        
        if corr_p(kk)<0.05
            roi_freq(ii,jj)=1;
        else
            roi_freq(ii,jj)=0;
        end
        kk=kk+1;
        
    end
    
end

% mask = (corrected_p<0.05);
%
% for isubj=1:size(t1,1)
%
%     v=t1(isubj,:).*mask;
%     v1(isubj)=mean(v(v~=0));
%
%     clear v
%
%     v=t2(isubj,:).*mask;
%     v2(isubj)=mean(v(v~=0));
%
%     clear v
%
%     v=t3(isubj,:).*mask;
%     v3(isubj)=mean(v(v~=0));
%
%     clear v
%
% end

%notBoxPlot([v1',v2',v3'])
% for isubj=1:size(t1,1)
%     
%     v=squeeze(t1(isubj,:,:)).*roi_freq;
%     v(v==0)=nan;
%     
%     v1(isubj,:)=nansum(v);
%     
%     clear v
%     
%     v=squeeze(t2(isubj,:,:)).*roi_freq;
%     v(v==0)=nan;
%     
%     v2(isubj,:)=nansum(v);
%     clear v
%     
%     v=squeeze(t3(isubj,:,:)).*roi_freq;
%     v(v==0)=nan;
%     
%     v3(isubj,:)=nansum(v);
%     
%     clear v
%     
% end


for isubj=1:size(t1,1)
    
    v=squeeze(t1(isubj,:,:)).*roi_freq;
    v(v==0)=nan;
    v0=v;
  %  v1(isubj,:)=v0;
    
    clear v
    
    v=squeeze(t2(isubj,:,:)).*roi_freq;
    v(v==0)=nan;
    v00=v;
    v2(isubj,:)=nansum(v0-v00);
    
    clear v
    
    v=squeeze(t3(isubj,:,:)).*roi_freq;
    v(v==0)=nan;
    v000=v;
    v3(isubj,:)=nansum(v0-v000);
    
    clear v
    
end



close all


% v1=squeeze(sum(t1,2));
% v2=squeeze(sum(t2,2));
% v3=squeeze(sum(t3,2));

[h,p,ci,stats]=ttest(v2,v3)

%addpath  /autofs/space/taito_005/users/fahimeh/notBoxPlot-master/code

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

save_p = [dpath , name_tag,'_stg_importance_uncorrected_pvalues.csv'];
p_value=p';
csvwrite(save_p,p_value)

% for i=1:5
%    figure; 
%     notBoxPlot([v2(:,i),v3(:,i)])
%     title([freqs{i}])
%     
%     
%     
% end