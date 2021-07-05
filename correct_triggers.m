clear all; close all;clc
% logfile dir
%dir='/autofs/cluster/transcend/fahimeh/Jyrki/doc/logfiles/';
dird='/autofs/space/voima_001/users/awmrc/meg_log_files/';
%dir='/autofs/space/taito_005/users/fahimeh/doc/logfiles/';
subjdir='/autofs/space/voima_001/users/awmrc/';

files={'awmrc_002-MEG-retro-2018-run1-FINAL1.log';
    'awmrc_002-MEG-retro-2018-run2-FINAL.log';
    'awmrc_002-MEG-retro-2018-run1-FINAL2.log';
    'awmrc_002-MEG-retro-2018-run2-FINAL1.log'};

mistakes=[3     6     9    12 97   100   103   106   109   112];

for j=1:1
    
    fn=files{j};
    [out1,out2]=importPresentationLog([dird fn]);
    
    ind_imp=find(strncmp(out2.code,'impulse',7));
    
    invalids=find(strncmp(out2.code(ind_imp+1),'invalid',7));
    
    events=mne_read_events([subjdir fn(1:9) '/megdata/' fn(1:9) '_aw_' num2str(j) '_sss-eve.fif']);
    
    
    Invalid_eve=double(events(1,1))+round((out2.time(ind_imp(invalids)+1)-out2.time(2))/10);
    
    C=out2.code(ind_imp(invalids)+1);
    
    event_new=events;
    
    for cc=1:2:length(C)
        
        event_new(size(events,1)+cc,3)=str2num(C{round(cc/2)}(end-1:end))+400;
        event_new(size(events,1)+cc,1)=Invalid_eve(round(cc/2));
        
        event_new(size(events,1)+cc+1,2)=str2num(C{round(cc/2)}(end-1:end))+400;
        event_new(size(events,1)+cc+1,1)=Invalid_eve(round(cc/2))+20;
        
    end
    
    
    clear C
    
    ind_silent=find(strncmp(out2.code,'silent',6));
    imp_silent=cat(1,ind_imp,ind_silent);
    nonmatch=find(strncmp(out2.code(imp_silent+1),'nonmatch',8));
    nonmatch_eve=double(events(1,1))+round((out2.time(imp_silent(nonmatch)+1)-out2.time(2))/10);
    
    C=out2.code(imp_silent(nonmatch)+1);
    
    event_new2=event_new;
    
    for cc=1:2:length(C)*2
        
        event_new2(size(event_new,1)+cc,3)=str2num(C{round(cc/2)}(17:end))+300;
        event_new2(size(event_new,1)+cc,1)=nonmatch_eve(round(cc/2));
        
        event_new2(size(event_new,1)+cc+1,2)=str2num(C{round(cc/2)}(17:end))+300;
        event_new2(size(event_new,1)+cc+1,1)=nonmatch_eve(round(cc/2))+20;
        
    end
    
    
    click2=events(find((events(:,3)==256))-2,3)
    for ii=1:length(mistakes)
        if ~isempty(find(click2==mistakes(ii)))
            fprintf('mistakes found')
        end
    end
    
    clear click2
%     mne_write_events([subjdir fn(1:9) '/megdata/' fn(1:9) '_aw_' num2str(j) '_raw-total-eve.fif'],event_new2)
    
end

xx=[9,12,15,18];
for i=1:4
tt=dec2bin(250+xx(i));
l=length(tt);
ff(i)=bin2dec(tt(l-7:l))
end

xx=[3,6,9,12,15,18];
for i=1:6
tt=dec2bin(350+xx(i));
l=length(tt);
ff(i)=bin2dec(tt(l-7:l))
end
% 
% 



