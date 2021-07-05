clear all; close all; fclose all; clc;


relevants = {'CMF','LOF','IFG','RMF','PC','SM'};


cutoff=95;
fn1=['/space/voima/1/users/awmrc/jyrki_meg/behavioral/predict_behavior_svr_0.5to1.25_s_1000_perm__Theta_Alpha_Beta_Gamma_HighGamma.PCA' num2str(cutoff) '_RMSE.mat'];
fn2=['/space/voima/1/users/awmrc/jyrki_meg/behavioral/predict_behavior_svr_1.25to2_s_1000_perm__Theta_Alpha_Beta_Gamma_HighGamma.PCA' num2str(cutoff) '_RMSE.mat'];
spath='/space/voima/1/users/awmrc/jyrki_meg/behavioral/';
d1=load(fn1);
d2=load(fn2);
connections=d1.connections;
nd=[d1.mvpaPermErr(:,2:end); d2.mvpaPermErr(:,2:end)];

nulld=min(nd);
cut=prctile(nulld,2.5);
mvpaErr1=(d1.mvpaPermErr(:,1));
mvpaErr2=(d2.mvpaPermErr(:,1));

connections(mvpaErr1<cut&mvpaErr2<cut)

% pooled error:

mvpaErr=[mvpaErr1 mvpaErr2];
maxErr=max(mvpaErr,[],2);

figure;
hist(nulld); hold on;
plot([cut,cut],[0,350],'k--','linewidth',1);
hold off;
sfn=[spath 'nulldist_behSVR.fig'];
savefig(sfn);
sfn=[spath 'nulldist_behSVR.eps'];
print(sfn,'-depsc2','-painters');
sfn=[spath 'nulldist_behSVR.svg'];
print(sfn,'-dsvg','-painters');


figure;
dat=reshape(maxErr,length(maxErr)/5,5);
h1=bar(dat([1:6,8:end],:),'grouped'); 
set(h1,'FaceAlpha',1/4,'EdgeAlpha',1/4); ylim([0,0.2]);pbaspect([3,1,1]);
% % sfn=[spath 'bar_faint_behSVR.eps'];
% % print(sfn,'-depsc2','-painters');
% % sfn=[spath 'bar_faint_behSVR.svg'];
% % print(sfn,'-dsvg','-painters');
hold on;

sigdat=dat;
sigdat(sigdat>=cut)=NaN;
% figure;
h2=bar(sigdat([1:6,8:end],:),'grouped'); hold on;
for i=1:5
    h2(i).FaceColor=h1(i).FaceColor;
end
set(h2,'FaceAlpha',1,'EdgeAlpha',1); set(gca,'xticklabel',[relevants relevants]);
% legend(h2,{'Theta','Alpha','Beta','Low Gamma','High Gamma'},'location','eastoutside');
xlabel('Connections to Right STC       Connections to Left STC');
ylabel('RMSE [{\itP}_c_o_r_r_e_c_t]')

h3=plot([0,13],[cut,cut],'k--','linewidth',0.5); ylim([0,0.2]); xlim([0,13]);
sfn=[spath 'bar_nsFaint_sigOpaq_behSVR.fig'];
savefig(sfn);
sfn=[spath 'bar_nsFaint_sigOpaq_behSVR.eps'];
print(sfn,'-depsc2','-painters');
sfn=[spath 'bar__nsFaint_sigOpaq__behSVR.svg'];
print(sfn,'-dsvg','-painters');
hold off; pbaspect([3,1,1]);