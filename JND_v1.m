clear all
clc
close all


% Require Jyrki update:
%%%% please update this
dir='/autofs/cluster/transcend/fahimeh/Jyrki/resources/ripple_vel_bin_sfiles-1s/';
% provide the direcotry path you want to save subject ripple sound, JND, stimulus_list.txt
% or just replace with your desired directory, we can remove input func
% this has to inclued the last '/': e.g. /autofs/, not /autofs
%ripple_dir=input('what is the directory path to store the data: \n','s');
ripple_dir='/autofs/cluster/transcend/fahimeh/Jyrki/resources/';
%presentation_destination=input('what is the directory path for presentation stimuli: \n','s');
presentation_destination='/autofs/cluster/transcend/fahimeh/Jyrki/resources/copy/';
%%%%
% the rest should work ...

duration=1;

subjid=input('please enter your subject ID: \n','s');

delay=1;
% initial bin difference
step=8;
k=1;
answer=zeros(1);
S=zeros(1);
reversal_count=0;

while(reversal_count<12)
    
                    
    f1=0;f2=0;
    while(f1==0 || f2==0)
        
        A=randperm(90);
        temp=['wbin_' num2str(A(1)) '_within_3-48_cps_range.wav'];
        soundfile1=[dir temp];
        temp=['wbin_' num2str(A(1)+step*sign(randn(1))) '_within_3-48_cps_range.wav'];
        soundfile2=[dir temp];
        
        f1=exist(soundfile1,'file');
        f2=exist(soundfile2,'file');
        
        if f1~=0 && f2~=0
            break
        end
        
    end
    
    
    [y1,Fs]=audioread(soundfile1);    
    [y2,Fs]=audioread(soundfile2);
    
    % play the sounds
    soundsc(y1,Fs)
    pause(delay)
    soundsc(y2,Fs)
    
    X=input('Press 1 if two files sound different and 0 if not: \n');
    
    pause(delay)
    
    answer(k)=X;
                   
    S(k)=step;
                  
    
    if k>1
        
        % change the step size
        if sum(answer(k-1:k))==2
            step=step-1;
        elseif answer(k)==0
            step=step+1;
        elseif step==0
            step=step+1;
        end
        
        % count the number of reversals
        D=sign(diff(S));
        D(D==0)=1;
        reversal_count=length(find(D(1:end-1).*D(2:end)==-1));                       
        
        if reversal_count==12
            inds=S(find(D(1:end-1).*D(2:end)==-1)+1);
            JND=mean(inds(3:12));
            fprintf('Thank you! The experiment is finished :) \n')
            break;
        end
        
    end
    
     k=k+1;  
    
end

showfig=0;

if showfig
plot(S,'o','MarkerFaceColor','blue','Markersize',10)
print([ripple_dir 'JND_plot_' subjid '_delay' num2str(delay) '_duration' duration],'-dpng')
end

save([ripple_dir 'JND_' subjid '_delay' num2str(delay) '_duration' duration '.mat'],'JND')

call_create_pool_ripples(JND,subjid,ripple_dir,presentation_destination)