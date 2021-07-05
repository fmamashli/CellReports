function subroi=cross_cond_icoh_subroi(subj,L1,L2,cond1,indf,tag,t1,t2)

subroi=zeros(length(L1),length(L2));

t=-.5:.002:3;

for iLabel1=1:length(L1)
    
    
    for iLabel2=1:length(L2)
        
        [iLabel1 iLabel2]
        
        
        fn1=['/autofs/space/voima_001/users/awmrc/',subj,'/megdata/', subj,'_Coh_' num2str(tag) '_split4_' L1{iLabel1}(1:end-6) '_' ...
            L2{iLabel2}(1:end-6) '_cond' num2str(cond1) '_140-0.5_fil.mat'];
        
        tt=load(fn1);
                
        
        time=resample(t,100,500);
        
        indt=find(time>t1,1,'first'):find(time>t2,1,'first');
        
        subroi(iLabel1,iLabel2)=median(mean(tt.iCoh(indf,indt)));
        
        
        
        clear tt
        
    end
    
    
end


% vec1=subroi(:);
%
% vec2=subroi2(:);
%
% [r,p]=corr(vec1,vec2,'Type','Spearman');
%
% normr=atanh(r);