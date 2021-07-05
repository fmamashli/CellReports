% creat manual projection
clear all
clc
close all

cfg.data_rootdir=('/autofs/space/taito_005/users/awmrc');
cfg.protocol='aw';

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/aw_list_proj.txt');
C=textscan(fid,'%s%s%s%s%s');

subject=C{1,1};
visitNo=C{1,2};
runs=C{1,3};
ecgproj=C{1,4};
eogproj=C{1,5};


X=eogproj;
tag='decim_eog';

% subj='051301';
% visitNo{1}='2';
% run=2;

for isubj=83:84
    
    
    subj=subject{isubj};
    run=str2double(runs{isubj});
    
    if ~strcmp(X{isubj},'done') && ~strcmp(X{isubj},'N')
        
        proj_fif=[cfg.data_rootdir '/'  subj '/' visitNo{isubj}  '/' subj '_' cfg.protocol '_' num2str(run) '_' tag '_proj.fif'];
        
        if exist(proj_fif,'file') && ~strcmp(X{isubj}(1:end-1),'copy') 
            % read proj
            [fid,tree]=fiff_open(proj_fif);
            infoproj=fiff_read_proj(fid,tree);
                  
                        
            Projs=X{isubj};
            
            for j=1:length(Projs)
                projdata(1,j)=infoproj(1,str2num(Projs(j)));
            end
            
            fid = fiff_start_file(proj_fif);
            fiff_write_proj(fid, projdata);
            fclose(fid);
            
            clear Projs projdata
            
            
        elseif strcmp(X{isubj},'copy1') || strcmp(X{isubj},'copy2') || strcmp(X{isubj},'copy3')
            
            runcopy=X{isubj}(end);
            
            proj_fif_run1=[cfg.data_rootdir '/'  subj '/' visitNo{isubj}  '/' subj '_' cfg.protocol '_' num2str(runcopy) '_' tag '_proj.fif'];
            proj_fif_run2=[cfg.data_rootdir '/'  subj '/' visitNo{isubj}  '/' subj '_' cfg.protocol '_' num2str(run) '_' tag '_proj.fif'];
%             
            command=['cp ' proj_fif_run1 ' ' proj_fif_run2];
            [st,ct]=system(command)
            
            if st~=0
                error('failed subj')
            end
            
        end
        
    end
    
end