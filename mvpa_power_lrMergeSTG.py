#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 14 21:22:51 2021

@author: fm897
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 11 10:26:02 2021

@author: fm897
"""

import numpy as np
import matplotlib.pyplot as plt
import csv

# decoding
from sklearn.pipeline import make_pipeline
from sklearn.svm import LinearSVC
from sklearn.svm import SVC
import mne
from mne.decoding import cross_val_multiscore
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import KFold
from scipy import stats
import statsmodels.stats.multitest as smt
from sympy.utilities.iterables import multiset_permutations
from sklearn.tree import DecisionTreeClassifier



data_path = '/autofs/space/voima_001/users/awmrc/'
parcel_name = 'superiortemporal_rh'
save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/'


with open('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=' ')
    subjects = [row[0] for row in csv_reader]

subjects = subjects[0:7] + subjects[8:15] + subjects[16:]

freq_range = {'theta':np.arange(0,5),'alpha':np.arange(5,10),
              'beta':np.arange(10,28),'gamma':np.arange(28,48),
              'highgamma':np.arange(51,72)}

Lnamelh={    
'superiortemporal_rh':np.arange(56,68),
'superiortemporal_lh':np.arange(122,135)}


a = np.array([1, 2, 3, 4, 5, 6])

total_p = []
for p in multiset_permutations(a):
    total_p.append(p)

total_p = np.array(total_p)

pp = np.tile(total_p,3)

pp = pp[20:520,]

"""
freq_name = 'highgamma'
name_tag = 'silent_impuse_'


isubj=0
for subj in subjects[0:19]:  

    save_file = save_dir + 'Power_' + name_tag + \
    parcel_name[:-2] + subj + freq_name

    npzfile = np.load(save_file + '.npz')
    
    X = npzfile['arr_0']
    y = npzfile['arr_1']
    
    if isubj == 0:
        data = X
        target = y
    else:
        data = np.concatenate((data,X), axis = 0)
        target = np.concatenate((target, y), axis =0)
        
    isubj = isubj +1
    


clf = make_pipeline(StandardScaler(), DecisionTreeClassifier())

scores = cross_val_multiscore(clf, data, target, cv=20, 
                              n_jobs=1)

score = np.mean(scores, axis=0)
print(score)

"""


def run_power_decoding(pp,subjects, freq_name, name_tag):
    
    parcel_name = 'superiortemporal_rh'
    save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/'
    

    permuted_score =[]
    for iperm in pp:
        
        subj_score =[]
        original = []
        for subj in subjects[0:21]:  
    
            save_file = save_dir + 'Power_' + name_tag + \
            parcel_name[:-2] + subj + freq_name
        
            npzfile = np.load(save_file + '.npz')
            
            X = npzfile['arr_0']
            y = npzfile['arr_1']
            
            clf = make_pipeline(StandardScaler(), SVC())
            
            scores = cross_val_multiscore(clf, X, y, cv=4, 
                                                  n_jobs=1)
    
            score = np.mean(scores, axis=0)
            
            original.append(score)
            
            kf = KFold(n_splits=4)
            
            scores = np.zeros((4,1))
            ik=0
            for train_index, test_index in kf.split(X):
         
                X_train, X_test = X[train_index], X[test_index]
                y_train, y_test = y[train_index], y[test_index]
    
                scaler = StandardScaler()
                
                X_train = scaler.fit_transform(X_train)
                X_test = scaler.transform(X_test)
    
    
                clf = SVC()
                clf.fit(X_train, iperm)
            
                scores[ik] = clf.score(X_test, a)
                ik = ik + 1
                
            score = np.mean(scores, axis=0)
            
            subj_score.append(score)
            
        permuted_score.append(np.mean(np.array(subj_score)))
    
    return np.array(permuted_score)




def run_decoding_original(subjects, freq_name, name_tag):
    
    parcel_name = 'superiortemporal_rh'
    save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/'
    

    original = []
    for subj in subjects[0:19]:  

        save_file = save_dir + 'Power_' + name_tag + \
        parcel_name[:-2] + subj + freq_name
    
        npzfile = np.load(save_file + '.npz')
        
        X = npzfile['arr_0']
        y = npzfile['arr_1']
        
        clf = make_pipeline(StandardScaler(), DecisionTreeClassifier())
        
        scores = cross_val_multiscore(clf, X, y, cv=4, 
                                              n_jobs=1)
    
        score = np.mean(scores, axis=0)
        
        original.append(score)
    
    return np.array(original)
    
   
    
all_permutation = [] 
original = [] 
name_tag = 'silent_impuse_'
#name_tag = 'impulse_'
  
for key, value in freq_range.items():
    
    freq_name = key  
    print(freq_name)
#    all_permutation.append(run_power_decoding(pp,subjects, freq_name, name_tag))
    original.append(run_decoding_original(subjects, freq_name, name_tag))
    
original = np.array(original)


#all_permutation = np.array(all_permutation)

#np.save('power_decoding_accuracy' + name_tag, original)
#np.save('power_decoding_accuracy_null_' + name_tag, all_permutation)





#all_permutation = np.array(all_permutation)
#perm = all_permutation.max(axis =0)

##


means = np.mean(np.array(original))


#sum(perm>original.mean(axis=0).mean(axis=0))/pp.shape[0]

