%clear all; close all;
call_create_pool_ripples(JND,subjid,ripple_dir)


% showfig=0; create_thumbnails_only=1;
 showfig=0; create_thumbnails_only=0;   slfn='stimulus_list.txt'; fid=fopen(slfn,'w');         

 
% DEFINE the subjects name here, creates a directory with this name, needs
% to be defined in the .tem file in presentation, too.

subject=subjid;

fs=44.1*1e3; % sampling reate

dur=1; % sound duration in seconds

t=0:1/fs:dur-(1/fs); %  time [t] axis


% create f vector, in which there are fsteps=20 / octave, within a
% frange of 3 octaves from f0=200 to 1,600
% Hz. These values f will represent the sinusoidal frequencies that are
% summed to the broad band stimulus

fsteps=20 ; % number of frequency steps within an octave
frange=3;
f0=200;
fmax=f0*2.^(frange);
f=2.^(log2(f0):log2(fmax/f0)/(fsteps*frange):log2(fmax));


x=log2(f./f0); % determine the difference between each f and f0 in octaves


% create vector of all RELEVANT ripple velocity (w) values, in which there
% are Nsteps octave steps between the lowest W0 and highest Wmax possible values. 
% Start from W0=4 cycles/s

%The subject "dummy" had a JND = 8 * 1/24 octaves = 1/3 octave
% JND in octave
JND=JND/24;

%JND=1/3; 
halfJND=JND/2;

%Do something here: start from 4 cycles/s, at JND/2 steps, lets get 18 (or so) samples
Wrange=18*halfJND;
W0=4; 
Wmax=W0*2.^(Wrange);
Nsteps=1/halfJND;
W=2.^(log2(W0):log2(Wmax/W0)/(Nsteps*Wrange):log2(Wmax));


% base loudness for 
D0=1;
D=0.9;

% periods of FM, cycles/oct
omega= 1; % use only one FM modulation frequency to keep it simple

imidx=0; % indices needed, but probably optimizable...
velobin=0; % indices needed, but probably optimizable...
for widx=1:length(W) % go through all the ripple velocity values
     S=[];
     mods=[];

     w=W(widx);

    % for tidx=1:length(t);

      psi=pi-2*pi*rand(1); 

      for fidx=1:length(x)

         Modtmp=D0+D*cos(2*pi*(w*t+omega*x(fidx))+psi);
         if(isempty(mods)),mods=Modtmp; else, mods=[mods;Modtmp];end
         Fc=f(fidx);
         swave = cos(2*pi*Fc*t+rand(1)*(pi-2*pi*rand(1)));
         Stmp=swave.*Modtmp;

         if(isempty(S)),S=Stmp;else,S=[S;Stmp];end
      end
    % end

    signal=sum(S,1)./max(abs(sum(S,1))); % sum and scale the amplitude

    
    
    % FIGURE STUFF
    if(create_thumbnails_only)
        imidx=imidx+1;
%             subplot(ceil(length(W)/4),ceil(length(W)/4),imidx)
        subplot(5,4,imidx)
        imagesc(t,f,mods);
        set(gca,'Ydir','Normal','fontsize',6,'ytick',[f(1) f(end)],'xtick',[t(1) t(end)]);
        set(gca,'yticklabel',{'',''},'xticklabel',{'',''});

        %set(gca,'visible','off')
        %title(['\omega = ' num2str(w,'%4.1f') ' cps']);
        title([num2str(w,'%4.1f') ' cps'],'fontsize',18);
    elseif(showfig)

        figure; imagesc(t,f,mods);
        set(gca,'Ydir','Normal','fontsize',21)
        ffn=['modulators-omega-' num2str(omega) '-w-' num2str(round(w)) '-f0-' num2str(f0) '.eps'];
        print('-depsc','-painters',ffn);
        title(['\sigma = ' w ' Hz']);

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % create a fade in and fade out ramp vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    FADE_LEN = 0.01; % 10 ms fade in and out 

  
    fade_samples = round(FADE_LEN.*fs); % figure out how many samples fade is over 
    fade_in_scale = linspace(0,1,fade_samples); % create fade in
    fade_out_scale = linspace(1,0,fade_samples); % create fade out

    % apply fade in and out

    signal(:,1:fade_samples) = signal(:,1:fade_samples).*fade_in_scale;
    signal(:,end-fade_samples+1:end) = signal(:,end-fade_samples+1:end).*fade_out_scale;


    nbits=16; 
    % the parametric file name with all the information
    sdir=[subject '_parametric_sfiles'];
    if(~exist(sdir,'dir')), mkdir(sdir);end
    wfn=[sdir '/O-' num2str(omega) '_cpoct-w-' num2str(w,'%4.1f') '_cps-f0-' num2str(f0) '_Hz.wav'];
    
    % the file name that indicates the ripple velocity bin number, starting
    % from the initial W0 value which is bin 1. THE PURPOSE IS TO DETERMINE
    % HOW MANY BINS THE SUBJECTS JND IS!
    
    sdir=[ subject '_ripple_vel_bin_sfiles'];
    if(~exist(sdir,'dir')), mkdir(sdir);end
    %wbinfn=[sdir '/wbin_' num2str(widx) '_within_' num2str(W0) '-' num2str(Wmax) '_cps_range.wav'];
    wbinfn=[sdir '/wbin_' num2str(widx) '.wav'];
    generic_wbinfn='$subject\_ripple_vel_bin_sfiles';
    

    % wavwrite(signal,fs,nbits,wfn);
    if(not(create_thumbnails_only))
        audiowrite(wfn,signal,fs);
        audiowrite(wbinfn,signal,fs);

    % Create presentation stimulus list
       if(mod(widx,2)),grp='A';velobin=velobin+1;else grp='B';end

%             stimname=['O-' num2str(omega) '_cpoct-w-' num2str(w,'%4.1f') '_cps-f0-' num2str(f0) '_Hz'];
%             stimname=['ripple-grp-' grp '-veloBin-' num2str(velobin)];
        stimname=['ripple_' num2str(widx)];
%         sline=sprintf('sound { wavefile {filename = "%s"; };  } %s;',wfn,stimname);
        sline=sprintf('sound { wavefile {filename = "%s"; };  } %s;',generic_wbinfn,stimname);
        fprintf(fid,'%s\n',sline);
    end
    % langis=fliplr(signal);
    % 
    % wfn=['itset-w0-' num2str(w) 'f0-' num2str(f0) '.wav'];
    % 
    % audiowrite(wfn,langis,fs);
    % 

    if(showfig)
        snd=signal;
        Fs=fs;
        Freq=f;

        figure
        t = (1:length(snd))/Fs;
        subplot(221)
        plot(t,snd,'k-')
        ylabel('Amplitude (au)');
        ylabel('Time (ms)');
        xlim([min(t) max(t)]);
        axis square;
        box off;

        subplot(223)
        nfft = 2^11;
        window      = 2^7; % resolution
        noverlap    = 2^5; % smoothing
        spectrogram(snd,window,noverlap,nfft,Fs,'yaxis');
        cax = caxis;
        caxis([0.7*cax(1) 1.1*cax(2)])
        ylim([min(Freq) max(Freq)])
        set(gca,'YTick',(1:2:20)*1000,'YTickLabel',1:2:20);
        axis square;

        subplot(224)
        pa_getpower(snd,Fs,'orientation','y'); % obtain from PandA
        ylim([min(Freq) max(Freq)])
        ax = axis;
        xlim(0.6*ax([1 2]));
        set(gca,'Yscale','linear','YTick',(1:2:20)*1000,'YTickLabel',1:2:20)
        axis square;
        box off;

        ffn=['actual-omega-' num2str(omega) '-w-' num2str(round(w)) '-f0-' num2str(f0) '.tiff'];

        print('-dtiff','-r600',ffn)

    end
end
if(create_thumbnails_only)
    colormap(gray)
    ffn=['thumbnails-omega-' num2str(omega) '-f0-' num2str(f0) '.eps'];
    print('-depsc','-painters',ffn);
end

fclose all;

