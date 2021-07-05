function subroi=cross_cond_power_subroi_all(subj,L1,cond1,indf,tag,t1,t2)

subroi=zeros(length(L1));

%t=-.5:.002:3;

for iLabel1=1:length(L1)
    
               
        fn1=['/autofs/space/voima_001/users/awmrc/',subj,'/megdata/TF_split4_half',
            tag,'_',subj,'_',L1{iLabel1}(1:end-6),'_cond',num2str(cond1),'epochs_AutoTF.mat'];
        
        tt=load(fn1);
                
        
        time=tt.time;
        
        indt=find(time>t1,1,'first'):find(time>t2,1,'first');
        
        subroi(iLabel1,iLabel2)=median(mean(tt.iCoh(indf,indt)));
        
                
        clear tt
        
    
    
    
end
