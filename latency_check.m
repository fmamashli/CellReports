clear all
clc

dir='/autofs/space/megraid_research/MEG/cr_auditory/subj_test/180813/';

%fh2 = fiff_setup_read_raw([dir '001b_initial_soundblaster_setting_raw.fif']);
fh2 = fiff_setup_read_raw([dir 'new_soundblaster_drivers.fif']);

f2 = fiff_read_raw_segment(fh2);

misc=f2(307,:);
sti=f2(308,:);

figure;
plot(misc)
hold on
plot(sti)



emg = detrend(misc);

RECT_emg = abs(emg);

k=1;
for ii=1:length(sti)
    
    if sti(ii)>200 && sti(ii)<219
        
        if sti(ii)-sti(ii-1)>0
            
            ii
            
            sample=[RECT_emg(ii:ii+1000)];
            
            figure;
            plot(RECT_emg(ii:ii+1000))
            hold on
            plot(sti(ii:ii+1000)/10)
            
            hold on
            
            line([find(sample>0.7,1,'first') find(sample>0.7,1,'first')],[0 10],'color','black')
                                     
            pause
            
            delay_thresh2(k)=find(sample>0.7,1,'first')/5000;
            k=k+1;
            
            close all
            
        end
    end
    
end

mean(delay_thresh2)
std(delay_thresh2)

% result: mean: 81ms, std:10ms

%%

clear all
clc

dir='/autofs/space/megraid_research/MEG/cr_auditory/no_name/180813/';

fh = fiff_setup_read_raw([dir 'internal_sound_card.fif']);

f2 = fiff_read_raw_segment(fh);

misc=f2(311,:);
sti=f2(312,:);

figure;
plot(misc)
hold on
plot(sti)
% misc=f2(307,:);
% sti=f2(308,:);


emg = detrend(misc);

RECT_emg = abs(emg);

k=1;
for ii=1:length(sti)
    
    if sti(ii)>200 && sti(ii)<219
        
        if sti(ii)-sti(ii-1)>0
            
            ii
            
            sample=[RECT_emg(ii:ii+500)];
            
            figure;
            plot(RECT_emg(ii:ii+500))
            hold on
            plot(sti(ii:ii+500)/10)
            
            hold on
            
            line([find(sample>0.7,1,'first') find(sample>0.7,1,'first')],[0 10],'color','black')
                                     
            pause
            
            delay_thresh2(k)=find(sample>0.7,1,'first')/5000;
            k=k+1;
            
            close all
            
        end
    end
    
end

mean(delay_thresh2)
std(delay_thresh2)

% result: mean:41ms, std:2ms
%%
clear all
clc

dir='/autofs/space/megraid_research/MEG/cr_auditory/subj_latency/180813/';

%fh2 = fiff_setup_read_raw([dir '001b_initial_soundblaster_setting_raw.fif']);
fh2 = fiff_setup_read_raw([dir '/megstim_latency_hardware.fif']);

f2 = fiff_read_raw_segment(fh2);

misc=f2(307,:);
sti=f2(308,:);

figure;
plot(misc)
hold on
plot(sti)



emg = detrend(misc);

RECT_emg = abs(emg);

k=1;
for ii=1:length(sti)
    
    if sti(ii)>200 && sti(ii)<219
        
        if sti(ii)-sti(ii-1)>0
            
            ii
            
            sample=[RECT_emg(ii:ii+1000)];
            
            figure;
            plot(RECT_emg(ii:ii+1000))
            hold on
            plot(sti(ii:ii+1000)/10)
            
            hold on
            
            line([find(sample>0.7,1,'first') find(sample>0.7,1,'first')],[0 10],'color','black')
                                     
            pause
            
            delay_thresh2(k)=find(sample>0.7,1,'first')/5000;
            k=k+1;
            
            close all
            
        end
    end
    
end

mean(delay_thresh2)
std(delay_thresh2)


