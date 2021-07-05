#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul 19 11:01:47 2019

@author: fm897
"""

import numpy as np


from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.feature_selection import SelectKBest, f_classif
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC

import mne
from mne.minimum_norm import apply_inverse_epochs, read_inverse_operator
from mne.decoding import (cross_val_multiscore, LinearModel, SlidingEstimator,
                          get_coef)

print(__doc__)

#from joblib import Parallel, delayed

import csv

with open('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=' ')
    subjects = [row[0] for row in csv_reader]

tmin = -.2
tmax = 1.0

#event_id = {'1': 1002, '2': 1005, '3': 1008, '4': 1011, '5': 1014, '6': 1017}  # just use two
event_id = {'1': 2102, '2': 2105, '3': 2108, '4': 2111, '5': 2114, '6': 2117}  # just use two


data_path = '/autofs/space/voima_001/users/awmrc/'
subjects_dir = '/autofs/space/voima_001/users/awmrc/subjects_mri/'

#def compute_scores(X_split):
#    scores = list()
#    for idx in range(X_split.shape[1]):
#        X_vert = X_split[:, idx, :]
#        scores.append(cross_val_multiscore(clf, X_vert, y, cv=5, n_jobs=1))
#        print('Score for vert %d of %d = %f' % (idx, X_split.shape[1], scores[-1].mean()))
#        print('scores %d' % (scores))
#        
#    return scores

from sklearn import decomposition


def compute_ml(X,y):
    
    clf = make_pipeline(StandardScaler(),  # z-score normalization
          #          SelectKBest(f_classif, k=300),  # select features for speed
                    SVC(gamma='auto_deprecated'))
    pca = decomposition.PCA(n_components=100)
    
    scores = list()
    vr = list()
    for idx in range(X.shape[1]):
        
        X_vert = X[:, idx, :]
        pca.fit(X_vert)
        X_vert = pca.transform(X_vert)
        v = pca.explained_variance_ratio_
        vr.append(np.sum(v[:100]))

        scores.append(cross_val_multiscore(clf, X_vert, y, cv=10, n_jobs=1))
        print('Score for vert %d of %d = %f' % (idx, X.shape[1], 
                                                scores[-1].mean()))
#    n_jobs = 5
#    parallel = Parallel(n_jobs=n_jobs)
#    delayed_scores = delayed(compute_scores)
#    scores = parallel(delayed_scores(X_split) for X_split in
#                  np.array_split(X, n_jobs, axis=1))
    
    scores_mean = np.array(scores).mean(axis=1)
    variance_explained =np.array(vr).mean()
    return scores_mean, variance_explained


subj_score = list()
snr = 3.0


for subj in subjects[0:2]:
    
    raws = list()
    events = list()
    if subj == 'awmrc_001':
        runs=['2','3','4','5']
    else:
        runs=['1','2','3','4']
    
    for run in runs:
    
        raw_fname = data_path + subj + '/megdata/' + subj + '_aw_' + run + \
        '_0.5_140fil_raw.fif'

        eventn = data_path + subj + '/megdata/' + subj + '_aw_' + run + \
        '_decim_recode_sss_mergestim-eve.fif'
        
        raws.append(mne.io.read_raw_fif(raw_fname, preload=True))
        events.append(mne.read_events(eventn))
    
    first_samps = list()
    last_samps = list()
    
    for index in range(len(raws)):
        print(index)
        raws[index].info['projs'] = []
        raws[index].pick_types(meg=True, eog=True, stim=True, eeg=False)
        first_samps.append(raws[index].first_samp)
        last_samps.append(raws[index].last_samp)
        
    raw = mne.concatenate_raws(raws, preload=True)
    raw.filter(0.5, 12., fir_design='firwin')
    event = mne.concatenate_events(events,first_samps,last_samps)

    epochs = mne.Epochs(raw, event, event_id, tmin, tmax, proj=True,
                    baseline=(-0.2, -0.05), preload=True,
                    reject=dict(grad=4000e-13, mag=4e-12),
                    decim=1)  # decimate to save memory and increase speed

    
    epochs.pick_types(meg=True)  # remove stim and EOG

    fname_inv = data_path + subj + '/megdata/' + subj + \
    '_aw_0.5_140_calc-inverse_loose_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif'


    inverse_operator = read_inverse_operator(fname_inv)

    stcs = apply_inverse_epochs(epochs, inverse_operator,
                            lambda2=1.0 / snr ** 2, verbose=False,
                            method="dSPM", pick_ori="normal")
    
    "left hemisphere"
    Xl = np.array([stc.lh_data for stc in stcs])  # only keep left hemisphere
    y = epochs.events[:, 2]
    
    Xr = np.array([stc.rh_data for stc in stcs])  # only keep right hemisphere
        
    

    
    ind_time = np.where(epochs.times>0)[0]
    
    scores_meanl, varl = compute_ml(Xl[:,:,ind_time],y)
    
    scores_meanr, varr = compute_ml(Xr[:,:,ind_time],y)

    save_file = data_path + subj + '/megdata/impulseActual_' + subj + \
    '_aw_source_timeseries_12Hz'
    
    np.savez(save_file, Xl = Xl, Xr = Xr, y = y, varr=varr, varl= varl)
    
#    scores_meanl = compute_ml(Xl,y)
#    
#    scores_meanr = compute_ml(Xr,y)
    
    
    stc = stcs[0]  # for convenience, lookup parameters from first stc

#    
    vertices = [stc.lh_vertno, stc.rh_vertno]
    tt = np.concatenate((scores_meanl,scores_meanr),axis=0)
    tt = tt.reshape(len(tt),1)
    a=np.repeat(tt,len(stc.times),axis=1)
    
    stc_feat = mne.SourceEstimate(a, vertices=vertices,
                              tmin=stc.tmin, tstep=stc.tstep, subject=subj) 
    
    fname = data_path + subj + '/megdata/impulseActual_' + subj + '_0to1s_' + \
    'pca100_aw_decoding_scores'
    

    stc_feat.save(fname)

#%%

for subj in subjects[2:21]:

    save_file = data_path + subj + '/megdata/impulseActual_' + subj + \
    '_aw_source_timeseries_12Hz'
    
    npzfile = np.load(save_file + '.npz')
    
    Xl = npzfile['Xl']
    Xr = npzfile['Xr']
    y = npzfile['y']
     
    ind_time = np.where(epochs.times>0)[0]
    
    scores_meanl = compute_ml(Xl[:,:,ind_time],y)
    
    scores_meanr = compute_ml(Xr[:,:,ind_time],y)

    
#    scores_meanl = compute_ml(Xl,y)
#    
#    scores_meanr = compute_ml(Xr,y)
    
    
    stc = stcs[0]  # for convenience, lookup parameters from first stc

#    
    vertices = [stc.lh_vertno, stc.rh_vertno]
    tt = np.concatenate((scores_meanl,scores_meanr),axis=0)
    tt = tt.reshape(len(tt),1)
    a=np.repeat(tt,len(stc.times),axis=1)
    
    stc_feat = mne.SourceEstimate(a, vertices=vertices,
                              tmin=stc.tmin, tstep=stc.tstep, subject=subj) 
    
    fname = data_path + subj + '/megdata/impulseActual_' + subj + '_0to1s_' + \
    'pca180_aw_decoding_scores'
    

    stc_feat.save(fname)

