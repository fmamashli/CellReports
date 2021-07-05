clear all; close all;clc
% logfile dir
dir1='/autofs/space/voima_001/users/awmrc/fmri_log_files/';

load([dir1 'sorted_logfiles_basedontime.mat'])
files=sorted_files;

paradigm_dir='/autofs/space/taito_005/users/fahimeh/doc/paradigm_files/';

data_dir='/autofs/space/voima_001/users/awmrc/';

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/list_dir.txt');
C=textscan(fid,'%s');

list_dir=C{1,1};


for j=97:4:100
    
    fn=files{j}(1:9);
    
    %     if ~mod(j,4)
    %         runnum=mod(j,4)+4;
    %     else
    %         runnum=mod(j,4);
    %     end
    
    inds=find(strncmp(list_dir,fn,9));
    
    for i=1:length(inds)
        
        filename=[paradigm_dir  fn(1:9) '/' num2str(i) '/awmrc_beh.par'];
        
        command=['cp ' filename ' ' data_dir fn '/bold/' list_dir{inds(i)}(end-2:end) '/'];
        [ct,st]=system(command)
        
    end
    
end