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


name_tag='1002to1017';

if strcmp(name_tag,'1002to1017')
    t1=0.5;
   % t1=1.25;
    t2=1.25;
   % t2=2;
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




fig_dir = '/autofs/space/taito_005/users/fahimeh/doc/Figures/coherence/review/';

clims=[0.1,0.4];
figure;
for freqi=5:5
    
    freq=freqs{freqi};
    k=1;
    
   
    for iroi1=2:length(lnames)-7
        
        for iroi2=iroi1+1:length(lnames)-7
            
            L1=label_names(indices{iroi1});
            L2=label_names(indices{iroi2});
            
            
            check1=strcmp(L1{1}(end-7:end-6),L2{1}(end-7:end-6));
            
            check2= contains(L1{1},'temporal')+contains(L2{1},'temporal');
            
            if check1+check2==2 && check2<2
                
                
                
                load([dpath,'confusion_matrix_' lnames{iroi1} '_' lnames{iroi2} '_' name_tag '_' freq,...
                    '_split1_time' num2str(t1) 'to' num2str(t2) 's.mat' ],'conf');
                
                
                subplot(3,2,k)
                imagesc(squeeze(mean(conf))/17,clims); colorbar
                xlabel('Predicted Class')
                ylabel('True Class')
               
                
                title([ROIs{iroi1} '-' ROIs{iroi2} ' ' freq ' ' num2str(t1) 'to' num2str(t2) 's'])
                
                k=k+1;
                
            end
            
        end
        
    end
    
    print([fig_dir 'confusion_mat_' freq num2str(t1) 'to' num2str(t2) 's.pdf'],'-dpdf')
    print([fig_dir 'confusion_mat_' freq num2str(t1) 'to' num2str(t2) 's.png'],'-dpng')
    
    
end
