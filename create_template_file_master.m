clear all; close all; fclose all;


% imgmodality='fMRI';
imgmodality='MEG';
% imgmodality='TMS';

fid=fopen(['init-' imgmodality '-retro-2018.tem'],'w');
flid1=fopen('trial-list-retro2-2018.txt','w');

hdr=importdata(['init-' imgmodality '-retrocue-header.txt']);

for hdri=1:size(hdr,1)
    fprintf(fid,'%s\n',hdr{hdri});
end

fprintf(fid,'\n\n#%s\n',repmat('*',1,110));
fprintf(fid,'#%s\n',repmat('*',1,110));
fprintf(fid,'# SOUND STIMULI');
fprintf(fid,'\n#%s\n',repmat('*',1,110));
fprintf(fid,'#%s\n\n',repmat('*',1,110));

% We can do either so that the stimulus list is always the same and the
% content of the "stereostimuli" directory will be individualized for each
% subject OR we can generate an individualized stimulus list based on the
% JND in each subject

slist=importdata('stimulus_list.txt');

for slisti=1:size(slist,1)
    fprintf(fid,'%s\n',slist{slisti});
end

switch imgmodality
    case 'fMRI'

        % Generate the "ready trials" and optional "rest trials" to be implemented between active trials,
        % which will synchronize the presentation of other trials with the scanner

        fprintf(fid,'\n\n#%s\n',repmat('*',1,110));
        fprintf(fid,'# CUE AND REST TRIALS\n');
        fprintf(fid,'#%s\n',repmat('*',1,110));
        % 

        % These will last until the subsequent acquisition will interrupt them,
        % with the "=" sent by the scanner through USB

        fprintf(fid,'\ntrial { start_delay = 0; trial_duration = forever; trial_type = first_response ;\n');
        fprintf(fid,'picture ready; time = 0;duration = $cuedur; code= "ready" ; target_button = 3;\n');    
        fprintf(fid,'} ready_trial;\n');

        fprintf(fid,'\ntrial { start_delay = 0; trial_duration = forever; trial_type = first_response ;\n');
        fprintf(fid,'picture FIX; time = 0;duration = $cuedur; code= "rest" ; target_button = 3;\n');    
        fprintf(fid,'} NULL;\n');
end


fprintf(fid,'\n\n#%s\n',repmat('*',1,110));
fprintf(fid,'#%s\n',repmat('*',1,110));
fprintf(fid,'# TASK TRIALS');
fprintf(fid,'\n#%s\n',repmat('*',1,110));
fprintf(fid,'#%s\n',repmat('*',1,110));

% Create non-match trials

% differences=[4 8]; base_levels=differences(end)+1:20;

TR=1800; % 

% Make the fixed trial duration to be as close as possible to 24 in one TR
% units

tridurint=ceil(24000/TR)*TR;
tridur=num2str(tridurint); % So you can use also "stimuli_length" definition or something else
%tridur='; % So you can use also "stimuli_length" definition or something else
dt1=1000; % start delay
dt2=1000; % first item dt
dt3=1000; % inter-item dt
dtcue=1000; % memorize cue dt
dt_impulse=3000; % dt for impulse, tms or stimulus

switch imgmodality
    case 'fMRI'
        dt4=16000;
        dt_respwin=ceil(2000/TR)*TR; % make the response window a bit longer for fMRI
        reps=1; % Determines the number of trials within a run -- here 24;
    otherwise
        dt4=2000; % probe dt after the impulse
        dt_respwin=1500;
        reps=4;
end
        
cuedur=1000; % visual cue duration -- needs to be deermined separately in addition to the onset time

ripN=20;
cuecode=ripN+1;
rcuecode=cuecode+1;
impulsecode=cuecode+2;

% Write Trial timing controls

fprintf(fid,'# Task timing parameters that can be modified if necessary.\n');

fprintf(fid,'\n$trial_dur = %s;\n',tridur); % not in use in the self-paced
fprintf(fid,'$start_dt = %d;\n',dt1); % the first cue dt
fprintf(fid,'$fitem_dt = %d;\n',dt2); % the first item dt
fprintf(fid,'$iitem_dt = %d;\n',dt3); % the inter-item dt
fprintf(fid,'$cue_dt = %d;\n',dtcue); % the memorize cue dt
fprintf(fid,'$impulse_dt = %d;\n',dt_impulse); % the impulse dt
fprintf(fid,'$probe_dt = %d;\n',dt4); % probe dt
fprintf(fid,'$resp_dt = %d;\n', dt_respwin);
fprintf(fid,'$cuedur = %d;\n', cuedur); % cue duration

matches=[];


% GENERATE THE POSSIBLE RIPPLE BIN SETS:

[rippleBins, rippleBinsArray]=trialbins(reps);


conditions=fieldnames(rippleBins);

pcn=0;


% The following loop generates two "match" (MV) trials, one "invalid" (MI) 
% and one "non-match" (NM) trial at every itereation, the order being 
% MV, MI, MV, NM. I think the purpose was that in each these cases the
% items will be the same in each iteration.

for condi=1:length(conditions)
    condition=conditions{condi};
    ripBins=rippleBins.(condition);
    
    % CREATE the uniformly distributed mem item position vector
    mposits=[ones(length(ripBins)/2,1); 2*ones(length(ripBins)/2,1)];
    mposits=mposits(randperm(length(mposits)));
    
    for tri=1:size(ripBins,1)
        switch imgmodality
            case 'fMRI'
                fprintf(fid,'\ntrial { start_delay = 0; trial_duration = %s;\n',tridur);
            otherwise
                fprintf(fid,'\ntrial { start_delay = 1000; trial_duration = forever; trial_type = first_response ;\n');
                fprintf(fid,'incorrect_feedback = wrong; correct_feedback = correct;\n');
                fprintf(fid,'picture ready; time = $start_dt;duration = $cuedur; code= "ready" ;\n');
        end
        
        % Determine the position of memory item vs. competing item
        positions=[mposits(tri),setdiff(1:2,mposits(tri))];
        Mpos=positions(1);
        
        fprintf(fid,'sound ripple_%d; delta_time= $fitem_dt;  code= "ripple_%d" ; port_code= %d;\n',ripBins(tri,positions(1)),ripBins(tri,positions(1))+pcn,ripBins(tri,positions(1))+pcn);
        fprintf(fid,'sound ripple_%d; delta_time= $iitem_dt;  code= "ripple_%d" ; port_code= %d;\n',ripBins(tri,positions(2)),ripBins(tri,positions(2))+pcn,ripBins(tri,positions(2))+pcn);
        fprintf(fid,'picture memorize%s; delta_time = $cue_dt; duration = $cuedur; code= "memorize%s" ; port_code= %d;\n',num2str(Mpos),num2str(Mpos), cuecode); 
        switch imgmodality
            case 'MEG'
                fprintf(fid,'sound impulse_sound; delta_time= $impulse_dt;  code= "impulse_sound" ; port_code= %d;\n',impulsecode);
        end
        
        switch condition
            case 'match'
                 fprintf(fid,'sound ripple_%d; delta_time= $probe_dt;  target_button= 1; code= "%s_ripple_%d" ; port_code= %d;\n',ripBins(tri,3),condition,ripBins(tri,3)+pcn,ripBins(tri,3)+pcn+100);
            case 'invalid'
                 fprintf(fid,'sound ripple_%d; delta_time= $probe_dt;  target_button= 2; code= "%s_ripple_%d" ; port_code= %d;\n',ripBins(tri,3),condition,ripBins(tri,3)+pcn,ripBins(tri,3)+pcn+200);
            case 'nonmatch'
                 fprintf(fid,'sound ripple_%d; delta_time= $probe_dt;  target_button= 2; code= "%s_ripple_%d" ; port_code= %d;\n',ripBins(tri,3),condition,ripBins(tri,3)+pcn,ripBins(tri,3)+pcn+300);
        end
                 
               
                
        fprintf(fid,'picture respond; delta_time = $resp_dt; duration = $cuedur; code= "respond" ;  port_code= %d;\n',rcuecode);
        fprintf(fid,'} %s_mpos_%d_tr_%d;\n',condition,Mpos,tri); % TO DO: CHECK THAT THE tri is the correct index
        fprintf(flid1,'%s_mpos_%d_tr_%d;\n',condition,Mpos,tri); % TO DO: CHECK THAT THE tri is the correct index
    
    end
end

fclose all;

