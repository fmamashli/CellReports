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
from sklearn.preprocessing import normalize

from sklearn.model_selection import KFold
from scipy import stats
import statsmodels.stats.multitest as smt
from sympy.utilities.iterables import multiset_permutations
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import ExtraTreesClassifier


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


freq_name = 'highgamma'
name_tag = 'silent_impuse_'

#name_tag = 'impulse_'


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
    

from sklearn.feature_selection import mutual_info_classif


X_new = SelectKBest(mutual_info_classif, k=150).fit_transform(data, target)


clf = make_pipeline(StandardScaler(), DecisionTreeClassifier(max_depth=3))

scores = cross_val_multiscore(clf, X_new, target, cv=20, 
                              n_jobs=1)

score = np.mean(scores, axis=0)
print(score)


clf = make_pipeline(StandardScaler(), SVC(C=100000))

scores = cross_val_multiscore(clf, X_new, target, cv=20, 
                              n_jobs=1)

score = np.mean(scores, axis=0)
print(score)



