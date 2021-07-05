clear all
clc


possible_sets=perms(1:6);

dpath='/autofs/space/taito_005/users/fahimeh/resources/coherence/large_subroi/';

set1=[possible_sets,possible_sets,possible_sets];
set2=[possible_sets(1:end-1,:),possible_sets(2:end,:),possible_sets(2:end,:)];
set3=[possible_sets(2:end-2,:),possible_sets(3:end-1,:),possible_sets(3:end-1,:)];

total_perm=[set1(1:700,:);set2(1:700,:);set3(1:700,:)];

save([dpath 'total_permutations.mat'],'total_perm','set1','set2','set3')

%%
    
    training_targets_p=[possible_sets(),possible_sets(i+1,)


possible_unique_combos=nchoosek(1:size(possible_sets,2),3);

possible_unique_combos=possible_unique_combos(randperm(size(possible_unique_combos,1)),:);

% combos=possible_unique_combos(1:Nperm,:);

% release memory

% possible_unique_combos=[];
Nclass=6;

target_train_set=zeros(18,Nperm+1);

targets_train=[(1:Nclass)';(1:Nclass)';(1:Nclass)'];

targets_train=targets_train(:);

 

target_train_set(:,1)=targets_train;

for targi=2:Nperm+1

    xyz=possible_unique_combos(targi,:);

    target_train_set(:,targi)=[possible_sets(:,xyz(1));possible_sets(:,xyz(2));possible_sets(:,xyz(3))];

end

% release memory

possible_unique_combos=[];