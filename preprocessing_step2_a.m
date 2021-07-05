%% Global Variables

%  Necessary for functions
clear all
clc
close all

cfg.protocol='aw';
% .Ave file for Protocol
cfg.protocol_avedir=('/autofs/space/taito_005/users/awmrc/MEG/descriptors');
cfg.protocol_avename='emo1_fm';
% .Ave file for ERM
cfg.covdir = ('/autofs/space/taito_005/users/awmrc/MEG/descriptors');
% Data Directory
cfg.data_rootdir=('/autofs/space/taito_005/users/awmrc');
% ERM Directory
cfg.erm_rootdir=('/autofs/space/taito_005/users/awmrc/erm');
% for forward calculation
cfg.setMRIdir=('/autofs/space/taito_005/users/awmrc/subjects_mri/');


% Points to all necessary Matlab MEG preprocessing functions
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/Private_SSS');

%% Default Settings

% AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED
%
cfg.do_erm_and_data_sss_main=[];

%                 cfg.do_sss_hpifit=[];
%                 cfg.do_sss_bad_channels=[];
%                 cfg.do_sss_movementcomp_combined=[];
                 cfg.do_sss_no_movementcomp_combined=[];
 %               cfg.do_sss_transform_allrunsto_singlerun=[];
 %                cfg.do_sss_decimation_combined=[];


%s cfg.do_mne_preproc_main=[];

%                  cfg.do_mne_preproc_heartbeat=[];
%                   cfg.do_erm_filtering_mne=[];
%                   cfg.do_erm_noise_covariance_mne=[];
%                   cfg.do_mne_preproc_filtered=[];
                   cfg.do_eve_noise_covariance_mne=[];
                   cfg.do_mne_preproc_grand_average=[];


cfg.do_calc_forward_inverse_main=[];

%                   cfg.do_calc_forward=[];
%                    cfg.do_calc_inverse=[];
                   cfg.do_eve_calc_inverse=[];

cfg.do_epochMEG_main=[];



%% Optional Parameters
cfg.decim_freq=500;
% do_mne_preproc_heartbeat
%cfg.no_projector_application_on_erm=1;
%cfg.apply_projections_erm_only=1;
%cfg.without_movement_option=1;
cfg.erm_sss=1;


cfg.apply_projections_only=[];
%cfg.clean_eog_only=1;

% do_erm_filtering
% cfg.erm_sss=[];



%-- cfg.do_mne_preproc_filtered=[];
cfg.mne_preproc_filt.lpf(1)=140;
cfg.mne_preproc_filt.hpf(1)=0.5;


% normal case!
cfg.epochMEG_event_order(1)=1002;
cfg.epochMEG_event_order(2)=1005;
cfg.epochMEG_event_order(3)=1008;
cfg.epochMEG_event_order(4)=1011;
cfg.epochMEG_event_order(5)=1014;
cfg.epochMEG_event_order(6)=1017;

cfg.epochMEG_event_order(7)=2002;
cfg.epochMEG_event_order(8)=2005;
cfg.epochMEG_event_order(9)=2008;
cfg.epochMEG_event_order(10)=2011;
cfg.epochMEG_event_order(11)=2014;
cfg.epochMEG_event_order(12)=2017;

cfg.epochMEG_event_order(13)=2102;
cfg.epochMEG_event_order(14)=2105;
cfg.epochMEG_event_order(15)=2108;
cfg.epochMEG_event_order(16)=2111;
cfg.epochMEG_event_order(17)=2114;
cfg.epochMEG_event_order(18)=2117;




%% Parameters

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subject=C{1,1};
visitNo=C{1,2};


erm_run=1;


% If performing ERM, indicates # of erm runs per visitN0...Almost always=1; If different for different subjects, can be a matrix
% If multiple dimensions, must match length(cfg.amp_sub_folders)
% runs of the data to be processed. If different for different subjects, can be a matrix
% If multiple dimensions, must match length(cfg.amp_sub_folders)
% visitNo of each of the subject(s). if multiple, can be a matrix
% If multiple dimensions, must match length(cfg.amp_sub_folders)
% filename=strcat('Batch_intital_parameters_',cfg.protocol,'cfg');
% save(filename,'cfg','visitNo','run','erm_run');
      

%% Batch script Execution

counter=1;
failed_subjects=cell(length(subject),1);



for isubj=20:20
    
    %   if ~isempty(find(strcmp(dec,subject{isubj})))
    
    for irun=1:4
        
        cfg1=cfg;
        run=irun;
        cfg1.start_run_from=run;
      %  cfg1.erm_sss=1;
        
    
        
%         if isempty(find(strcmp(dec,subject{isubj})))
%             
%             cfg1.no_erm_decimation=1;
%             cfg1.no_data_decimation=1;
%         end
        
        %   if ~exist([cfg.data_rootdir '/' subject{isubj} '/' visitNo{isubj}  '/' subject{isubj} '_emo1_' num2str(run) '_sss.fif'],'file')
        
        try
            fprintf('Processing single subject %s\n',subject{isubj});
            master_preprocessing_script(subject{isubj},visitNo{isubj},run,erm_run,cfg1);
            
        catch
            
            fprintf('Subject Failed ! %s\n',subject{isubj});
            failed_subjects{counter,1}= subject{isubj};
            
        end
        
        close all
        clear cfg1
        
    end
    
    % end
    
end





