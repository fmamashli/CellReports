clear all
clc
close all

fid=fopen('/autofs/space/voima_001/users/fahimeh/JND/list_jnd_files.txt');
C=textscan(fid,'%s%s');
subjects=C{1,1};

for isubj = 1:length(subjects)
    
    tt = load(['/autofs/space/voima_001/users/fahimeh/JND/' subjects{isubj}]);
    
    jnd(isubj) = tt.JND;
    
end
