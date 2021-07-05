clear all; close all;

% showfig=0; create_thumbnails_only=1;
 showfig=1; create_thumbnails_only=0;   slfn='stimulus_list.txt'; fid=fopen(slfn,'w');         



fs=44.1*1e3; % sampling reate

dur=0.5; % duration in seconds

% create f vector, in which there are 20 steps / octave, from 200 to 1,600
% Hz

f0=200;

f=f0;

ftmp=f0;

for fidx=1:60
   ftmp=ftmp*(2^(1/20));
   f=[f ftmp];
end

x=log2(f./f0);

Nstep=7;


% create w vector, in which there are Nstep steps / octave, from 12 to 24
% Hz

W0=4;

W=W0;

Wtmp=W0;


for Widx=1:Nstep*3-2
   Wtmp=Wtmp*(2^(1/Nstep));
   W=[W Wtmp];
end


% create a t axis
t=0:1/fs:dur-(1/fs);

% phase


% base loudness
D0=1;
D=0.9;

% periods of FM, cycles/oct
omegas=[ 1];



for oidx=1:length(omegas)
    omega=omegas(oidx);
    imidx=0;
    velobin=0;
    for widx=1:length(W)
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

        signal=sum(S,1)./max(abs(sum(S,1)));
        
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

        %sig = randn(15.*Fs,1); % generate 15 s signal 

        fade_samples = round(FADE_LEN.*fs); % figure out how many samples fade is over 
        fade_in_scale = linspace(0,1,fade_samples); % create fade in
        fade_out_scale = linspace(1,0,fade_samples); % create fade out

        % apply fade in and out

        signal(:,1:fade_samples) = signal(:,1:fade_samples).*fade_in_scale;
        signal(:,end-fade_samples+1:end) = signal(:,end-fade_samples+1:end).*fade_out_scale;


        nbits=16;

        wfn=['O-' num2str(omega) '_cpoct-w-' num2str(w,'%4.1f') '_cps-f0-' num2str(f0) '_Hz.wav'];

        % wavwrite(signal,fs,nbits,wfn);
        if(not(create_thumbnails_only))
            audiowrite(wfn,signal,fs);
            GAIN=55;
            dry=signal;
            fid2=fopen([ '/Users/fahimeh/Dropbox/Jyrki/sensimetrics/EQF_027L.bin'],'r');sens14l=fread(fid2,100000,'double'); fclose(fid2); %figure; freqz(c,1,[],44100)
            fid2=fopen([ '/Users/fahimeh/Dropbox/Jyrki/sensimetrics/EQF_027R.bin'],'r');sens14r=fread(fid2,100000,'double'); fclose(fid2); %figure; freqz(c,1,[],44100)
            drysfL = GAIN*filtfilt(sens14l,1,dry); drysfR = GAIN*filtfilt(sens14l,1,dry);

            sfY=[drysfL' drysfR'];

          %  sfn=sprintf('sensfilt/%s',wfn);
            audiowrite(wfn,sfY, fs);  %# Save as an 8-bit, 1 kHz signal
       
        % Create presentation stimulus list
           if(mod(widx,2)),grp='A';velobin=velobin+1;else grp='B';end

%             stimname=['O-' num2str(omega) '_cpoct-w-' num2str(w,'%4.1f') '_cps-f0-' num2str(f0) '_Hz'];
%             stimname=['ripple-grp-' grp '-veloBin-' num2str(velobin)];
            stimname=['ripple_' num2str(widx)];
            sline=sprintf('sound { wavefile {filename = "%s"; };  } %s;',wfn,stimname);
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

end
fclose all;

