function [M,accuracy_main,roi_to_roi]=load_awm_decode(name_tag)

dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';


if strcmp(name_tag,'1002to1017')
    t1=0.5;
    t2=2;
else
    t1=0;
    t2=1;
end

load([dpath, name_tag, '_connectivity_5freq_subjects_accuracy_' num2str(t1) 'to' num2str(t2) 's.mat'])

accuracy_main=accuracy(:,[1:5,7:13],:);

fid=fopen([dpath , name_tag,'_connectivity_5freq_corrected_pvalues.txt']);
C=textscan(fid,'%s');
corr_p=C{1,1};

for i=2:length(corr_p)
    
    corrected_main(i-1) = str2double(corr_p{i});
    
end


P=reshape(corrected_main,5,12);


for jj=1:5
    
    k=1;   
    for ii=1:12
        
        if P(jj,ii)<0.05
            
        data(k,:)=squeeze(accuracy_main(jj,ii,:));
        k=k+1;
        
        end
        
        
    end
   
    
    M(jj,:)=mean(data);
    
    clear data k    
end