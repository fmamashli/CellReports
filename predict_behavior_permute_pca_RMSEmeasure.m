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

%% Derive behaviorals

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/MEG_behavioral_accuracy.txt');
Beh=textscan(fid,'%s%f');
beh_subjects=Beh{1,1};
beh_accuracy=Beh{1,2};
accuracy=[];
fclose(fid);

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

name_tag='1002to1017';
%name_tag='3002to3017';
%name_tag='2102to2117';


if strcmp(name_tag,'1002to1017')
    t1=0.5;t2=1.25;
%       t1=1.25; t2=2;
    %t2=2;
else
    t1=0;
    t2=1;
end


% indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68],[69:72], ...
%     [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154]};

indices = {[1:5],[6:10],[11:17],[18:27],[28:40],[41:56],[57:68], ...
    [73:79],[80:88],[89:94],[95:106],[107:122],[123:135],[136:145],[146:154]};


%%
% dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';
dpath = '/autofs/space/tahto_001/users/fahimeh/awmrc_resource2/coherence/large_subroi/';


freqs={'Theta','Alpha','Beta','Gamma','HighGamma'};

cntr=1;
vs=[];
% mvpaErr=[];

nperm=1000;
rndseed=1;
cutoff=95;
mvpaPermErr=[];
connections=[];

ftagstring=[];

for freqi=1:5
    
    freq=freqs{freqi};
    k=1;
    
    ftagstring=[ftagstring '_' freq]; 
    
    for iroi1=2:length(lnames)-1
        
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
                
                % populate the accuracy vector in consistent order and
                % content with the order of subjects in the connectivity
                % files
                
                if(isempty(accuracy))
                    conn_subjects=d1.subjects;
                    
                    arr=[];
                    for conni=1:length(conn_subjects)
                        csubj=conn_subjects{conni};
                        arr=[arr; find(strcmp(csubj,beh_subjects))];
                    end
                    accuracy=beh_accuracy(arr);
                    subjects=beh_subjects(arr);
                    vs=zeros(length(subjects));
                end
                
                trust_but_verify=cellfun(@strcmp,d1.subjects,subjects);
                if(sum(trust_but_verify)~=length(subjects))
                    error('Mismatch!');
                end
                
                
                [nsubjs, nc, nroi1, nroi2]=size(d1.data);
                
                vols1=[];vols2=[];vols3=[];vols4=[];
                %                 mvpaErr=[];
                
                if(isempty(vols1)),vols1=zeros(nsubjs,nc,nroi1,nroi2);vols2=vols1; vols3=vols1; vols4=vols1; end
                
                vols1(:,:,:,:)=d1.data;
                vols2(:,:,:,:)=d2.data;
                vols3(:,:,:,:)=d3.data;
                vols4(:,:,:,:)=d4.data;
                
                v=cell(4,1);
                v(1)={vols1(:,:)};
                v(2)={vols2(:,:)};
                v(3)={vols3(:,:)};
                v(4)={vols4(:,:)};
                
                targets_train_set=pre_permutation(3,accuracy,nperm,rndseed);
                runs=1:4;
                mvpaErr=zeros(1,nperm);
                parfor permi=1:nperm+1
                
                    targets_test=accuracy;
                    targets_train=targets_train_set(:,permi);
                
                
                
                    mvpaErr(permi)=implement_mvpa(v,targets_test,targets_train,runs,cutoff);
               
                end
                titletext=[freq ' band:' L1{1} ' x ' L2{1}];
                mvpaPermErr=[mvpaPermErr;mvpaErr];
                connections=[connections;{titletext}];
                
            end
        end
    end
    
end

sfn=['/space/voima/1/users/awmrc/jyrki_meg/behavioral/predict_behavior_svr_' num2str(t1) 'to' num2str(t2) '_s_' num2str(nperm) '_perm_' ftagstring '.PCA' num2str(cutoff) '_RMSE.mat'];
save(sfn,'mvpaPermErr','connections','nperm','label_names','name_tag');

function pred_error=implement_mvpa(datacell,targets_test,targets_train,runs,cutoff)
RMSE=nan(4,1);
for testi=runs
    
    traini=find(~ismember(runs,testi));
    samples_train=cell2mat(datacell(traini));
    samples_test =cell2mat(datacell(testi));
    [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(samples_train);
    samples_train=SCORE(:,cumsum(EXPLAINED)<cutoff);
    samples_test=samples_test*COEFF; samples_test=samples_test(:,cumsum(EXPLAINED)<cutoff);
    
    opt.t=0;
    opt.c=1;
    opt.s=3;
    
    predicted = cosmo_classify_libsvm(samples_train, targets_train, samples_test,opt);
    rmse=sqrt(mean((predicted-targets_test).^2));
    RMSE(testi)=rmse;

end
pred_error=mean(RMSE);
end


function targets_train_set=pre_permutation(n_training_chunks,target_info,Nperm,rndseed)
seed=rndseed;
targets_train_set=zeros(n_training_chunks*length(target_info),Nperm+1);
rng(seed);

initial_targets_train=repmat(target_info,n_training_chunks,1);
initial_targets_train=initial_targets_train(:);
targets_train_set(:,1)=initial_targets_train;

for permi=2:Nperm+1
    tmp_trg=[];
    for chunki=1:n_training_chunks
        
        tmp_trg=[tmp_trg;target_info(randperm(length(target_info)))];
    end
    targets_train_set(:,permi)=tmp_trg(:);
end

end