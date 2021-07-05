clear all; close all;clc
% logfile dir
dir1='/autofs/space/taito_005/users/awmrc/fmri_log_files/';

% Notes:
%For the subj 001, we should use the files 001b, that is, the latter session.
%(Also I will have to look at this subject’s individual runs, as there may have occurred some “napping”.)

%Also, with better time, we can analyze the bias vs. d’. For example, in 014 to my recollection,
%there was a “negative bias”, which is acceptable: the subject only responded “yes” when they were absolutely sure.

load([dir1 'sorted_logfiles_basedontime.mat'])
files=sorted_files;

%total_trials=24;

for j=1:length(files)
    
    fn=files{j};
    
    
    [out1,out2]=importPresentationLog([dir1 fn]);
    
    
    tt=strcmp(out2.code,'3');
    out2.code(tt)=[];
    
    tt=strcmp(out2.code,'rest');
    out2.code(tt)=[];
    
    tt=strcmp(out2.code,'ready');
    out2.code(tt)=[];
    
    tt=strcmp(out2.code,'respond');
    out2.code(tt)=[];
    
    codes=out2.code;
    
    
    match=strncmp(codes,'match',5);
    
    index_cor1=find(match==1);
    
    truepositive=find(strcmp(codes,'1'));
    
    count=0;
    for i=1:length(index_cor1)
        
        if sum(index_cor1(i)+1==truepositive)
            count = count+1;
        end
        
    end
    
    
    nonmatch=strncmp(codes,'nonmatch',8);
    inval=strncmp(codes,'inval',5);
    %  miss=strncmp(codes,'miss',4);
    
    
    %index_cor2=[find(nonmatch==1);find(inval==1);find(miss==1)];
    index_cor2=[find(nonmatch==1);find(inval==1)];
    
    
    truenegative=find(strcmp(codes,'2'));
    
    countn=0;
    for i=1:length(index_cor2)
        
        if sum(index_cor2(i)+1==truenegative)
            countn = countn+1;
        end
        
    end
    
    total_trials=length(find(match))+length(find(nonmatch))+length(find(inval));
    % (true positive + true negative)/total_trials
    accuracy(j,1)=(count+countn)/total_trials;
    
    clear codes match truepositive truenegative nonmatch inval index_cor1 index_cor2
    
end

k=1;
for i=1:4:length(files)
    
    subj_ac(k,1)=mean(accuracy(i:i+3));
    subj{k,1}=files{i}(1:9);
    k=k+1;
end


%%
clear all; close all;clc
% logfile dir
dir1='/autofs/space/voima_001/users/awmrc/meg_log_files/';


% fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_meg_log.txt');
% C=textscan(fid,'%s');
%
% files=C{1,1};

load([dir1 'sorted_MEG_logfiles_basedontime.mat'])
files=sorted_files;

for j=1:length(files)
    
    fn=files{j};
    [out1,out2]=importPresentationLog([dir1 fn]);
    
    codes=out2.code;
    
    
    truepositive=sum(strcmp(codes(find(strncmp(codes,'match',5))+1),'1'));
    
    
    truenegative=sum(strcmp(codes(find(strncmp(codes,'nonmatch',8))+1),'2'))+ sum(strcmp(codes(find(strncmp(codes,'inval',5))+1),'2'));
    
    
    total_trials=length(find(strncmp(codes,'match',5)))+length(find(strncmp(codes,'nonmatch',8)))+length(find(strncmp(codes,'inval',5)));
    % (true positive + true negative)/total_trials
    accuracy(j,1)=(truepositive+truenegative)/total_trials;
    
    clear codes  truepositive truenegative
    
end

k=1;
for i=1:4:length(files)
    
    subj_ac(k,1)=mean(accuracy(i:i+3,1));
    subj{k,1}=files{i}(1:9);
    k=k+1;
end

subj_ac([8,20])=[];

mean(subj_ac)
std(subj_ac)

%% testing impulse sound effect
clear all; close all;clc
% logfile dir
dir1='/autofs/space/voima_001/users/awmrc/meg_log_files/';


% fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_meg_log.txt');
% C=textscan(fid,'%s');
%
% files=C{1,1};

load([dir1 'sorted_MEG_logfiles_basedontime.mat'])
files=sorted_files;

for j=1:length(files)
    
    fn=files{j};
    [out1,out2]=importPresentationLog([dir1 fn]);
    
    codes=out2.code;
    
    
    %truepositive=sum(strcmp(codes(find(strncmp(codes,'match',5))+1),'1'));
    
    % silent true positive
    silent_ind=find(strncmp(codes,'match',5)).*strncmp(codes(find(strncmp(codes,'match',5))-1),'silent_impulse_sound',20);
    
    silent=silent_ind(silent_ind~=0);
    
    truepositive=sum(strcmp(codes(silent+1),'1'));
    
    l1=length(silent);
    
    clear silent silent_ind
    % silent true negative
    
    silent_ind=find(strncmp(codes,'nonmatch',8)).*strncmp(codes(find(strncmp(codes,'nonmatch',8))-1),'silent_impulse_sound',20);
    
    silent=silent_ind(silent_ind~=0);
    
    trueneg1 = sum(strcmp(codes(silent+1),'2'));
    
    l2=length(silent);
    
    clear silent silent_ind
    
    silent_ind=find(strncmp(codes,'inval',5)).*strncmp(codes(find(strncmp(codes,'inval',5))-1),'silent_impulse_sound',20);
    
    silent=silent_ind(silent_ind~=0);
    
    trueneg2 = sum(strcmp(codes(silent+1),'2'));
    
    l3=length(silent);
    
    clear silent silent_ind
    %  truenegative=sum(strcmp(codes(find(strncmp(codes,'nonmatch',8))+1),'2'))+ sum(strcmp(codes(find(strncmp(codes,'inval',5))+1),'2'));
    
    
    total_trials=l1+l2+l3;
    % (true positive + true negative)/total_trials
    accuracy_silent(j,1)=(truepositive+trueneg1+trueneg2)/total_trials;
    
    clear codes  truepositive trueneg1 trueneg2 l1 l2 l3 total_trials
    
end

%%
for j=1:length(files)
    
    fn=files{j};
    [out1,out2]=importPresentationLog([dir1 fn]);
    
    codes=out2.code;
    
    
    %truepositive=sum(strcmp(codes(find(strncmp(codes,'match',5))+1),'1'));
    
    % silent true positive
    silent_ind=find(strncmp(codes,'match',5)).*strncmp(codes(find(strncmp(codes,'match',5))-1),'impulse_sound',13);
    
    silent=silent_ind(silent_ind~=0);
    
    truepositive=sum(strcmp(codes(silent+1),'1'));
    
    l1=length(silent);
    
    clear silent silent_ind
    % silent true negative
    
    silent_ind=find(strncmp(codes,'nonmatch',8)).*strncmp(codes(find(strncmp(codes,'nonmatch',8))-1),'impulse_sound',13);
    
    silent=silent_ind(silent_ind~=0);
    
    trueneg1 = sum(strcmp(codes(silent+1),'2'));
    
    l2=length(silent);
    
    clear silent silent_ind
    
    silent_ind=find(strncmp(codes,'inval',5)).*strncmp(codes(find(strncmp(codes,'inval',5))-1),'impulse_sound',13);
    
    silent=silent_ind(silent_ind~=0);
    
    trueneg2 = sum(strcmp(codes(silent+1),'2'));
    
    l3=length(silent);
    
    clear silent silent_ind
    %  truenegative=sum(strcmp(codes(find(strncmp(codes,'nonmatch',8))+1),'2'))+ sum(strcmp(codes(find(strncmp(codes,'inval',5))+1),'2'));
    
    
    total_trials=l1+l2+l3;
    % (true positive + true negative)/total_trials
    accuracy_impulse(j,1)=(truepositive+trueneg1+trueneg2)/total_trials;
    
    clear codes  truepositive trueneg1 trueneg2 l1 l2 l3 total_trials
    
end



%%
k=1;
for i=1:4:length(files)
    
    subj_ac(k,1)=mean(accuracy(i:i+3,1));
    subj{k,1}=files{i}(1:9);
    k=k+1;
end