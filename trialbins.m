function [rBinsStruct,rBinsArray] = trialbins(reps)

% rBins = trialbins(reps) where reps refers to "repetitions".
% Creates a structure "rBinsStruct" of ripple bins for a set of reps x 24 trials. The
% structure contains 3 fields: match, invalid, and nonmatch. Each field has
% 3 columns. The first column contains the memory item (MI), the second
% column contains the respective competing item (CI), and the third column
% contains the ripple bin of probes (P). Use these to generate a set of
% respective presentation trials (presumably such that the position of MI
% vs. CI will be randomly either 1st or 2nd in the actual stimulus trial).
% The function also creates an array of all possible ripple bins.
%                                                                          
%                                                                               
% BACKGROUND:
%
% 1) Uses the results of Visccher et al. as the guideline: they produced a
% vector of 20 sounds spaced by 1/2 JNDs. Assuming everything will be a little more
% difficult here, let's make it 9+9=18.
% 
% 2) To get an equal distribution of actively memorized items, the memory
% item (MI) can be one of 6 different bins at 1.5 JND, i.e., 3 unit steps. 
% REASON: a) algorithms likely perform more poorly than the human due to
% noise, b) it is also possible to do a multiclass SVM with not too large
% number of classes, c) the ability to permanent learning of all these
% stimuli will be ensured by the interference due to other stimuli (see below).
%
% 3) The CIs can also be one of 6 possible bins separated by 3 unit steps.
% This distribution will be MIs+1, to avoid the possibility that the
% subject learns all 6 MI stimuli.
% 
% 4) CI and the probe (P) will differ from MI by at least 1 JND in all trials.
%
% 5) a) 50% of trials will be "match trials": P == MI.
%    b) 25% of trials will be "invalid trials": P == CI.
%    c) 25% of trials will be "nonmatch trials": P ~= MI && P ~= CI.
%
% 5) Therefore, to be able to draw randomly trials where in each trial type
% class (match, invalid, or nonmatch), there is an equal number of those
% where the MI is the 1st and MI is the 2nd item in the trial.

MIs=2:3:18; %This will produce a range which is centered in 1:18.
MIs=repmat(MIs,1,reps);

rippleBins.match=zeros(2*length(MIs),3);
rippleBins.invalid=zeros(length(MIs),3);
rippleBins.nonmatch=zeros(length(MIs),3);

ttypes=fieldnames(rippleBins);

test=0;
while test==0
    for fi=1:length(ttypes)
        finame=ttypes{fi};

        % adapt to the differing probabilities
        tmpMIs=MIs;
        while(length(rippleBins.(finame))>length(tmpMIs))
            tmpMIs=[tmpMIs MIs];
        end
        tmpCIs=tmpMIs-1;

        for i=1:length(rippleBins.(finame))
            % set the MI
            MI=tmpMIs(i);
            % Set the CI from one of possible remaining stimuli, randomly
            totalPool=setdiff(tmpCIs,[MI-1,MI+1]); % possible values, i.e., all CIs excluding those differing from the MI by only one unit 
            CI=totalPool(randi(length(totalPool))); % select randomly one of the possible values
            % Set the probe from one of the possible values, excluding MI, CI, and
            % values differing from them by only one unit (i.e., 1/2 JND).
            remainingPool=setdiff(1:18,[MI,MI-1,MI+1,CI,CI-1,CI+1]);% possible values, i.e., 1:18 excluding MI and those differing from the MI by only one unit
            %testaus=[testaus remainingPool];
            P=remainingPool(randi(length(remainingPool)));
            % Populate the matrix:
            rippleBins.(finame)(i,1)=MI;
            rippleBins.(finame)(i,2)=CI;
            % To ensure an equal distribution of MIs in all cases:
            switch finame
                case 'invalid' 
                    rippleBins.(finame)(i,3)=CI;
                case 'nonmatch'
                    rippleBins.(finame)(i,3)=P;
                case 'match'
                    rippleBins.(finame)(i,3)=MI;
            end
        end
    end
    
    % Confirm that across all trials, there will be as equal distribution
    % of the 6 different possible CIs.
    
    tmp1=struct2cell(rippleBins);
    tmp2=cell2mat(tmp1);
    CIdist=tmp2(:,2);
    [NCI,X]=hist(CIdist,6);
    if(max(NCI)/min(NCI)<1.5)
        test=1;
    end
    disp(['Ratio of the least vs. most common CI count = ' num2str(max(NCI)/min(NCI),'%6.2f')]);
    
end

rBinsStruct=rippleBins;
rBinsArray=tmp2;

end

