%% Global Variables

%  Necessary for functions
clear all
clc
close all

cfg.protocol='aw';
% .Ave file for Protocol
%cfg.protocol_avedir=('/autofs/space/taito_005/users/awmrc/MEG/descriptors');
%cfg.protocol_avename='emo1_fm';
% .Ave file for ERM
%cfg.covdir = ('/autofs/space/taito_005/users/awmrc/MEG/descriptors');
% Data Directory
cfg.data_rootdir=('/autofs/space/tahto_001/users/awmrc_ep');
% ERM Directory
cfg.erm_rootdir=('/autofs/space/tahto_001/users/awmrc_ep/erm');
% for forward calculation
%cfg.setMRIdir=('/autofs/space/taito_005/users/awmrc/subjects_mri/');

%padma/Matti_data
% Points to all necessary Matlab MEG preprocessing functions
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/Private_SSS');

%% Default Settings

% AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED
%
% cfg.do_erm_and_data_sss_main=[];
%
%                  cfg.do_sss_hpifit=[];
%                  cfg.do_sss_bad_channels=[];
%                  cfg.do_sss_movementcomp_combined=[];
                  cfg.do_sss_no_movementcomp_combined=[];
%                 cfg.do_sss_transform_allrunsto_singlerun=[];
%                 cfg.do_sss_decimation_combined=[];


cfg.do_mne_preproc_main=[];

%                  cfg.do_mne_preproc_heartbeat=[];
                cfg.do_erm_filtering_mne=[];
                cfg.do_erm_noise_covariance_mne=[];
                cfg.do_mne_preproc_filtered=[];
                cfg.do_eve_noise_covariance_mne=[];
                cfg.do_mne_preproc_grand_average=[];


cfg.do_calc_forward_inverse_main=[];

%                   cfg.do_calc_forward=[];
                    cfg.do_calc_inverse=[];
%                   cfg.do_eve_calc_inverse=[];

cfg.do_epochMEG_main=[];



%% Optional Parameters

%cfg.tsss=1;

cfg.decim_freq=500;
cfg.erm_sss=1;
 
% do_mne_preproc_heartbeat
%cfg.no_projector_application_on_erm=1;
%cfg.apply_projections_erm_only=1;
%cfg.without_movement_option=1;

%cfg.no_data_sss=1;

% cfg.no_erm_decimation=1;
% cfg.no_data_decimation=1;

%% Parameters

% fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
% C=textscan(fid,'%s%s');
% subject=C{1,1};
% visitNo=C{1,2};

subject='ep_001';
visitNo='megdata';

erm_run=1;


% If performing ERM, indicates # of erm runs per visitN0...Almost always=1; If different for different subjects, can be a matrix
% If multiple dimensions, must match length(cfg.amp_sub_folders)
% runs of the data to be processed. If different for different subjects, can be a matrix
% If multiple dimensions, must match length(cfg.amp_sub_folders)
% visitNo of each of the subject(s). if multiple, can be a matrix
% If multiple dimensions, must match length(cfg.amp_sub_folders)
% filename=strcat('Batch_intital_parameters_',cfg.protocol,'cfg');
% save(filename,'cfg','visitNo','run','erm_run');

%% list of manual bad channels

  cfg.manual_badch=[];
% % %
% % %
badch{1}='1142';
% badch{2}='1443 1423 1433 1432 1421 1932 522 1232 813  ';
% badch{3}='2533 522 822 813 812 1232 811 911';
% badch{4}='2533 522 822 823 812 813 912 1232   ';

% badch{1}='1411 811 812 121 511 522 2043';
% badch{2}='1411 811 812 121 511 522 2043 821';
%badch{3}='631 2022 2221 121';
%badch{4}='811 1412 812 821 121 823 522 322 441 1313 2633';


%% Batch script Execution

counter=1;
failed_subjects=cell(length(subject),1);



for isubj=1:1
    
    %   if ~isempty(find(strcmp(dec,subject{isubj})))
    
    for irun=1:1
        
        cfg1=cfg;
        run=irun;
        cfg1.start_run_from=run;
        
        
      
           cfg1.erm_sss=1;
           cfg1.badch{run}='1142';
        
       
        try
            
            master_preprocessing_script(subject,visitNo,run,erm_run,cfg1);
            
        catch
            
            fprintf('Subject Failed ! %s\n',subject);
            failed_subjects{counter,1}= subject;
            
        end
        
        close all
        clear cfg1
        
    end
    
    % end
    
end





