function TF_label_source_attn(labrep,Fs,FREQ,times,filename,subj,icond)

addpath /autofs/space/hypatia_001/users/fahimeh_MEG_Analyses/fm_functions/TimeFrequency


for ivertex=1:size(labrep,1)
    
    TF1 = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ,7,'morlet'));
    
    
    time_freq(ivertex,:,:,:)=TF1;   
    
    name=[' ' subj ' vertex' num2str(ivertex) ' condition ' num2str(icond) ' is successfully done ']
    
    clear TF1 TF2
    
end


% -200 to 600 ms
%ind=find(times>-.25,1,'first'):find(times>.99,1,'first');

%time_freq=time_freq(:,ind,:,:);
%times=times(ind);

%save([filename '_TF.mat'],'time_freq','times','Fs','label_n','FREQ','-v7.3')


% compute AutoTF


tfs=permute(time_freq,[4 1 3 2]);

cfg.times=times;
cfg.startTime=-.4;
cfg.endTime=-0.2;
cfg.Total_subtract=1;
cfg.Induced_subtract=1;
cfg.Evoked=0;
cfg.PLF=0;
cfg.ITC=0;

[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(tfs,cfg);

ITC=squeeze(mean(ITC));
PLF=squeeze(mean(PLF));
Evoked=squeeze(mean(Evoked));
Induced=squeeze(mean(Induced));
Total=squeeze(mean(Total));

save([filename  'epochs_AutoTF.mat'],'Total','Induced','Evoked','PLF','ITC','times','Fs','FREQ','-v7.3')




