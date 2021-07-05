function normr=cross_cond_icoh_l(subj,L1,L2,cond1,cond2,indf)

subroi=zeros(length(L1),length(L2));
subroi2=zeros(length(L1),length(L2));

for iLabel1=1:length(L1)
    
    
    for iLabel2=1:length(L2)
        
        [ iLabel1 iLabel2]
        
        
        tt=  load(['/autofs/space/voima_001/users/awmrc/',subj,'/megdata/', subj,'_Coh_1_' L1{iLabel1}(1:end-6) '_' ...
            L2{iLabel2}(1:end-6) '_cond' num2str(cond1) '_140-0.5_fil.mat']);
        
        
        time=resample(tt.times,100,500);
        
        indt=find(time>0,1,'first'):find(time>2.4,1,'first');
        
        subroi(iLabel1,iLabel2)=median(mean(tt.iCoh(indf,indt)));
        
        clear tt
        
        tt=  load(['/autofs/space/voima_001/users/awmrc/',subj,'/megdata/', subj,'_Coh_2_' L1{iLabel1}(1:end-6) '_' ...
            L2{iLabel2}(1:end-6) '_cond' num2str(cond2) '_140-0.5_fil.mat']);
        
        
        subroi2(iLabel1,iLabel2)=median(mean(tt.iCoh(indf,indt)));
        
        
        clear tt
        
    end
    
    
end

vec1=subroi(:);

vec2=subroi2(:);

[r,p]=corr(vec1,vec2,'Type','Spearman');

normr=atanh(r);