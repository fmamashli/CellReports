function normr=cross_cond_icoh(subj,L1,L2,cond1,cond2,indf,times)


for iLabel1=1:length(L1)
    
    
    for iLabel2=1:length(L2)
        
        [ iLabel1 iLabel2]
        
        
        load(['/autofs/space/voima_001/users/fahimeh/temp/', subj,'_Coh_1_' L1{iLabel1}(1:end-6) '_' ...
            L2{iLabel2}(1:end-6) '_cond' num2str(cond1) '_140-0.5_fil.mat']);
        
        indt=find(times>0,1,'first'):find(times>2.4,1,'first');
        
        subroi(iLabel1,iLabel2)=median(mean(iCoh(indf,indt)));
        
        clear iCoh
        
        load(['/autofs/space/voima_001/users/fahimeh/temp/', subj,'_Coh_2_' L1{iLabel1}(1:end-6) '_' ...
            L2{iLabel2}(1:end-6) '_cond' num2str(cond2) '_140-0.5_fil.mat']);
        
        
        subroi2(iLabel1,iLabel2)=median(mean(iCoh(indf,indt)));
        
        
        clear iCoh
        
    end
    
    
end

vec1=reshape(subroi,1,size(subroi,1)*size(subroi,2));

vec2=reshape(subroi2,1,size(subroi2,1)*size(subroi2,2));

[r,p]=corr(vec1',vec2','Type','Spearman');
keyboard;
normr=atanh(r);