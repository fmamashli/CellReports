clear all
clc
close all

cfg.protocol='aw';
%Data Directory
cfg.data_rootdir=('/autofs/space/taito_005/users/awmrc/');

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/aw_list_proj.txt');
C=textscan(fid,'%s%s%s%s%s');

subject=C{1,1};
visitNo=C{1,2};
runs=C{1,3};

k=1;
for isubj=1:8
    
    subj=subject{isubj};
    run=runs{isubj};
    
    eventfile=[cfg.data_rootdir subj '/' visitNo{isubj} '/' subj '_' ,cfg.protocol, '_' num2str(run) '_decim_sss-eve.fif'];
    
    try 
        
    events=mne_read_events(eventfile);
    
    
    sound1=find(events(:,3)==21 | events(:,3)==22)-4;
    sound2=find(events(:,3)==21 | events(:,3)==22)-2;
    probe=find(events(:,3)==21 | events(:,3)==22)+2;
    
        
    L=size(events,1);
    newevents=events;
    
    for ievent=1:length(sound1)
        
        newevents(L+ievent,1)=events(sound1(ievent),1);
        newevents(L+ievent,2)=0;
        newevents(L+ievent,3)=600;
        
    end
    
    clear L
    
    L=size(newevents,1);
    
    for ievent=1:length(sound2)
        
        newevents(L+ievent,1)=events(sound2(ievent),1);
        newevents(L+ievent,2)=0;
        newevents(L+ievent,3)=700;
        
    end
    
    clear L
    
    L=size(newevents,1);
    
    for ievent=1:length(probe)
        
        newevents(L+ievent,1)=events(probe(ievent),1);
        newevents(L+ievent,2)=0;
        newevents(L+ievent,3)=800;
        
    end
    
    filename=[cfg.data_rootdir subj '/' visitNo{isubj} '/' subj '_' ,cfg.protocol, '_' num2str(run) '_decim_sss_new-eve.fif'];
    
    mne_write_events(filename,newevents)
    
    catch
       
        failed_subjec{k,1}=eventfile;
        k=k+1;
        
    end
    
end