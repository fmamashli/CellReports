clear all; close all; fclose all;
clc

addpath  /autofs/space/taito_005/users/fahimeh/notBoxPlot-master/code

save_fig_dir='/autofs/space/taito_005/users/fahimeh/doc/Figures/coherence/results/';

%% load data
name_tag='1002to1017';

M=load_awm_decode(name_tag);
M=M';

figure;
notBoxPlot(M)
line([0:6],ones(1,7)/6,'color','black','linestyle','--')
ylim([0.1 1])
title([name_tag])
print([save_fig_dir name_tag '_mean_accuracy_all_subjects'],'-dpdf')

%%
addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Mines

save_dir = '/autofs/space/taito_005/users/fahimeh/resources/decoding_results/'

name_tag='1002to1017';

[M1,accuracy1,roi_to_roi]=load_awm_decode(name_tag);


clear M

name_tag='3002to3017';

[M2,accuracy2,roi_to_roi]=load_awm_decode(name_tag);



freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

for iroi1=1:5
    for iroi2=1:12
        
        [R,P]=corrcoef(accuracy1(iroi1,iroi2,:),accuracy2(iroi1,iroi2,:));
        
        p_rois(iroi1,iroi2)=P(1,2);
        r_rois(iroi1,iroi2)=R(1,2);
        
    end
end

p_value=p_rois(:);

save_p = [save_dir ,'corr_mainencode_17subjs_uncorrected_pvalues.csv'];
csvwrite(save_p,p_value)
%%

fid=fopen([save_dir , 'corr_mainencode_17subjs_corrected_pvalues.txt']);
C=textscan(fid,'%s');
corr_p=C{1,1};

for i=2:length(corr_p)
    
    corrected_p(i-1) = str2double(corr_p{i});
    
end

kk=1;
for ii=1:12
    
    for jj=1:5
        
        freq_conn(jj,ii)=corrected_p(kk);
        kk=kk+1;
        
    end
    
end

%%
figure;
imagesc(r_rois);axis xy;colormap('jet');colorbar
set(gca,'clim',[-.9 0.9])
print([save_fig_dir 'corr_r_main_encode_all'],'-dpdf')

figure;imagesc(freq_conn<0.05);axis xy;colorbar;colormap('summer')
print([save_fig_dir 'corr_p_mask_main_encode_all_summer'],'-dpdf')



% correlation figure of high gamma
M1=squeeze(mean(accuracy1(5,:,:),2));
M2=squeeze(mean(accuracy2(5,:,:),2));

plot(M1,M2,'o','markerfacecolor','blue', ...
    'markeredgecolor','black','markersize',10)

[xs,ys]=do_fit_model(M1,M2);

hold on

plot(xs,ys,'color','black','linewidth',2)

rr=mean(r_rois(5,:));
title(['r=' num2str(rr)])
print([save_fig_dir 'correlation_highgamma_main_encode_all'],'-dpdf')

%%
indsig=find(freq_conn(4,:)<0.05);

% correlation figure of low gamma
M1=squeeze(mean(accuracy1(4,indsig,:),2));
M2=squeeze(mean(accuracy2(4,indsig,:),2));

plot(M1,M2,'o','markerfacecolor','blue', ...
    'markeredgecolor','black','markersize',10)

[xs,ys]=do_fit_model(M1,M2);

hold on

plot(xs,ys,'color','black','linewidth',2)

rr=mean(r_rois(4,indsig,:));
title(['r=' num2str(rr)])
print([save_fig_dir 'correlation_lowgamma_main_encode_all'],'-dpdf')

%%
addpath /space/hypatia/1/users/fahimeh_MEG_Analyses/fm_functions/Mines

name_tag='1002to1017';

[M1,accuracy1]=load_awm_decode(name_tag);


clear M

name_tag='3002to3017';

[M2,accuracy2]=load_awm_decode(name_tag);


colors={'blue','red','Yellow','Magenta','green'};

freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

for ifre=1:5
    
    [R,P]=corrcoef(M1(ifre,:),M2(ifre,:));
    
    r_p(ifre,:)=[R(1,2),P(1,2)];
    
    figure;
    
    plot(M1(ifre,:),M2(ifre,:),'o','markerfacecolor',colors{ifre}, ...
        'markeredgecolor','black','markersize',10)
    
    [xs,ys]=do_fit_model(M1(ifre,:)',M2(ifre,:)');
    
    hold on
    
    plot(xs,ys,'color','black','linewidth',2)
    
    title([num2str(P(1,2)*5) '-r=' num2str(R(1,2)) '-' freqs{ifre}])
    
    xlabel('Maintenance Decoding Accuracy')
    ylabel('Encoding Decoding Accuracy')
    
    set(gca,'fontsize',10)
    print([save_fig_dir 'corr_main_encode_' freqs{ifre}],'-dpdf')
    
end


% for jj=1:5
%
%
%     for ii=1:12
%
%
%        [R,P]=corrcoef(accuracy1(jj,ii,:),accuracy2(jj,ii,:));
%
%         r(jj,ii)=R(1,2);
%         p(jj,ii)=P(1,2);
%
%     end
% end

%%
fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};
subjects=subjects(3:21);

subjects=subjects([1:5,7:13,15:19]);

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/accuracy.txt');
C=textscan(fid,'%s%s');
S=C{1,1};
acc=C{1,2};

for isub=1:length(subjects)
    
    
    ind=find(strcmp(S,subjects{isub}));
    try
        behavior(isub)=str2num(acc{ind});
    catch
        
        fprintf('subj %s failed \n',num2str(isub))
    end
end

behavior([10,14])=[];


for jj=1:5
    
    
    for ii=1:12
        
        D=squeeze(accuracy1(jj,ii,:));
        D([10,14])=[];
        
        [R,P]=corrcoef(behavior,D);
        
        r(jj,ii)=R(1,2);
        p(jj,ii)=P(1,2);
        
    end
end
