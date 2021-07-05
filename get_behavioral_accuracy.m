% clear all
% clc

fid=fopen('/autofs/space/taito_005/users/fahimeh/doc/txt/MEG_behavioral_accuracy.txt');
C=textscan(fid,'%s%f');
subjects=C{1,1};
accuracy=C{1,2}
% subjects=subjects([1:7,9:15,17:21]);
% accuracy=C{1,2}([1:7,9:15,17:21]);