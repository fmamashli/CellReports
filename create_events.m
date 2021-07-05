%  Necessary for functions
clear all
clc
close all

data_rootdir=('/autofs/space/voima_001/users/awmrc/');

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subject=C{1,1};
visitNo=C{1,2};

k=1;
for isubj=3:3
    
    subj=subject{isubj};
    
    for irun=1:4
        
        try
            
            eventfile = [data_rootdir subj '/megdata/' subj '_aw_' num2str(irun) '_decim_sss-eve.fif'];
            
            events = mne_read_events(eventfile);
            
            %   events=events(1:1118,:,:);
            
            newevents=events;
            N=size(newevents,1);
            %memorize item1
            
            item1=find(events(:,3)==21);
            indices1=events(item1-4,1);
            
            item2=find(events(:,3)==22);
            indices2=events(item2-2,1);
            
            impuls_sound=events(item1+2,3)-events(item1-4,3);
            
            impuls_sound2=events(item2+2,3)-events(item2-2,3);
            
            % code for memorize item1: item1+1000
            newevents(N+1:N+length(indices1),1)=events(item1,1);
            newevents(N+1:N+length(indices1),3)=events(item1-4,3)+1000;
            
            clear N
            
            N=size(newevents,1);
            
            % code for memorize item2: item2+1000
            newevents(N+1:N+length(indices2),1)=events(item2,1);
            newevents(N+1:N+length(indices2),3)=events(item2-2,3)+1000;
            
            
            
            clear N
            
            % impuls sound for item1: for impuls sound:add 2100, otherwise add 2000
            N=size(newevents,1);
            
            newevents(N+1:N+length(impuls_sound),1)=double(events(item1+2,1)).*(impuls_sound==225)+double(events(item1+2,1)).*(impuls_sound==200);
            newevents(N+1:N+length(impuls_sound),3)=double(events(item1-4,3)).*(impuls_sound==225)+2000.*(impuls_sound==225)+...
                double(events(item1-4,3)).*(impuls_sound==200)+2100.*(impuls_sound==200);
            
            
            clear N
            
            % impuls sound for item2: for impuls sound:add 2100, otherwise add 2000
            N=size(newevents,1);
            newevents(N+1:N+length(impuls_sound2),1)=double(events(item2+2,1)).*(impuls_sound2==225)+double(events(item2+2,1)).*(impuls_sound2==200);
            newevents(N+1:N+length(impuls_sound2),3)=double(events(item2-2,3)).*(impuls_sound2==225)+2000.*(impuls_sound2==225)+...
                double(events(item2-2,3)).*(impuls_sound2==200)+2100.*(impuls_sound2==200);
            
            
            filename=[data_rootdir subj '/megdata/' subj '_aw_' num2str(irun) '_decim_recode_sss-eve.fif'];
            
            mne_write_events(filename,newevents)
            
            clear newevents
            
        catch
            
            failed{k,1}=eventfile;
            k=k+1;
        end
        
    end
    
end

%% only for awmrc_002
%  Necessary for functions
clear all
clc
close all

data_rootdir=('/autofs/space/voima_001/users/awmrc/');

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt');
C=textscan(fid,'%s%s');
subject=C{1,1};
visitNo=C{1,2};

k=1;
for isubj=2:2
    
    subj=subject{isubj};
    
    for irun=1:4
        
        try
            
            eventfile = [data_rootdir subj '/megdata/' subj '_aw_' num2str(irun) '_decim_sss-eve.fif'];
            
            events = mne_read_events(eventfile);
            
            
            
            newevents=events;
            N=size(newevents,1);
            
            
            % silent impulse sound: 24
            item1=find(events(:,3)==24);
            
            
            indices1=item1(events(item1-2,3)==21);
            
            indices2=item1(events(item1-2,3)==22);
            
            
            
            newevents(N+1:N+length(indices1),1)=events(indices1,1);
            newevents(N+1:N+length(indices1),3)=events(indices1-6,3)+2000;
            
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices2),1)=events(indices2,1);
            newevents(N+1:N+length(indices2),3)=events(indices2-4,3)+2000;
            
            
            % add 1000 for memorization code
            clear N
            
            N=size(newevents,1);
            
            
            newevents(N+1:N+length(indices1),1)=events(indices1-2,1);
            newevents(N+1:N+length(indices1),3)=events(indices1-6,3)+1000;
            
            
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices2),1)=events(indices2-2,1);
            newevents(N+1:N+length(indices2),3)=events(indices2-4,3)+1000;
            
            
            
            % add 3000 for memorization code
            clear N
            
            N=size(newevents,1);
            
            
            newevents(N+1:N+length(indices1),1)=events(indices1-6,1);
            newevents(N+1:N+length(indices1),3)=events(indices1-6,3)+3000;
            
            
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices2),1)=events(indices2-4,1);
            newevents(N+1:N+length(indices2),3)=events(indices2-4,3)+3000;
            
            
            
            clear item1 indices1 indices2
            
            % impulse sound: 23
            item1=find(events(:,3)==23);
            
            
            indices1=item1(events(item1-2,3)==21);
            
            indices2=item1(events(item1-2,3)==22);
            
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices1),1)=events(indices1,1);
            newevents(N+1:N+length(indices1),3)=events(indices1-6,3)+2100-50;
            
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices2),1)=events(indices2,1);
            newevents(N+1:N+length(indices2),3)=events(indices2-4,3)+2100-50;
            
            
            % memorization: add 1000
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices1),1)=events(indices1-2,1);
            newevents(N+1:N+length(indices1),3)=events(indices1-6,3)+1000-50;
            
            
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices2),1)=events(indices2-2,1);
            newevents(N+1:N+length(indices2),3)=events(indices2-4,3)+1000-50;
            
            
            % add 3000 for memorization code
             
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices1),1)=events(indices1-6,1);
            newevents(N+1:N+length(indices1),3)=events(indices1-6,3)+3000-50;
            
            
            clear N
            
            N=size(newevents,1);
            
            newevents(N+1:N+length(indices2),1)=events(indices2-4,1);
            newevents(N+1:N+length(indices2),3)=events(indices2-4,3)+3000-50;
            
                        
            
            filename=[data_rootdir subj '/megdata/' subj '_aw_' num2str(irun) '_decim_recode_sss-eve.fif'];
            
            mne_write_events(filename,newevents)
            
            filename=[data_rootdir subj '/megdata/' subj '_aw_' num2str(irun) '_decim_recode_sss_mergestim-eve.fif'];
            
            mne_write_events(filename,newevents)
            
            
            clear newevents
            
            clear item1 indices1 indices2
            
        catch
            
            failed{k,1}=eventfile;
            k=k+1;
        end
        
    end
    
end


