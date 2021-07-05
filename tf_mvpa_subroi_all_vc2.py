#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 30 17:31:08 2019

@author: fm897
"""

import numpy as np
import mne
from mne.minimum_norm import read_inverse_operator, compute_source_psd_epochs
import csv


subjects_dir = '/autofs/space/voima_001/users/awmrc/subjects_mri/'
#from untils_awm import read_raw_data




subj_score = list()

data_path = '/autofs/space/voima_001/users/awmrc/'

def get_epochs_subj(subj,event_id,tmin,tmax):

    data_path = '/autofs/space/voima_001/users/awmrc/'
    raws = list()
    events = list()
    if subj == 'awmrc_001':
        runs=['2','3','4','5']
    else:
        runs=['1','2','3','4']

    
    for run in runs:
    
        raw_fname = data_path + subj + '/megdata/' + subj + '_aw_' + run + \
        '_0.5_140fil_raw.fif'

#        eventn = data_path + subj + '/megdata/' + subj + '_aw_' + run + \
#        '_decim_recode_sss_mergestim-eve.fif'
        
        eventn = data_path + subj + '/megdata/' + subj + '_aw_' + run + \
        '_decim_recode_sss-eve.fif'
       
       
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
    event = mne.concatenate_events(events,first_samps,last_samps)
    
    picks = mne.pick_types(raw.info, meg=True, eeg=False, eog=False, stim=False)

    epochs = mne.Epochs(raw, event, event_id, tmin, tmax, baseline = None, 
                        picks=picks, reject=dict(grad=4000e-13, mag=4e-12), 
                        preload=True, detrend = 1)

    fname_inv = data_path + subj + '/megdata/' + subj + \
    '_aw_0.5_140_calc-inverse_loose_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif'


    inverse_operator = read_inverse_operator(fname_inv)

    return epochs, inverse_operator


def psd_labels_source(labels_name,labeldir,subj,epochs, inverse_operator,
                      data_path, parcel_name):
    
    labels_epochs_psd = list()
    fmin, fmax = 3., 120.
    snr = 3.0
    for ilab in range(len(labels_name)):
        
        label_fname = labeldir + subj + '/fsmorphedto_' + subj + '-' + \
        labels_name[ilab][:-1]

        
        label = mne.read_label(label_fname)

        stcs = compute_source_psd_epochs(
                epochs,inverse_operator,lambda2=1.0/snr**2,method="dSPM", 
                bandwidth=4.0, adaptive = True, n_jobs = 10, fmin=fmin, 
                fmax=fmax,pick_ori="normal", label=label,return_generator=True, 
                verbose=True)
    
        psd_epochs = list()
        
        for i, stc in enumerate(stcs):
                
            psd_epochs.append(stc.data.mean(axis=0))
            
        labels_epochs_psd.append(psd_epochs)
        freqs = stc.times     
        
    labels_epochs_psd = np.array(labels_epochs_psd)
    
    X_psd = np.concatenate(labels_epochs_psd,axis=1)
    print(X_psd.shape)
    y = epochs.events[:, 2]  
    
    save_file = data_path + subj + '/megdata/' + subj + \
    '_aw_psd_3to120Hz_4Hz_' + parcel_name + '_large_subroi'
    
    np.savez(save_file, X_psd = X_psd, y = y, freqs = freqs, 
             lname = labels_name)
    
    

with open('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=' ')
    subjects = [row[0] for row in csv_reader]


text_file = open("/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt", "r")
labels = text_file.readlines()  
labels = np.array(labels)

Lname={'caudalanteriorcingulate_rh':np.arange(0,5),
'caudalmiddlefrontal_rh':np.arange(5,10),
'lateralorbitofrontal_rh':np.arange(10,17),
'parsopercularis_rh':np.arange(17,27),
'rostralmiddlefrontal_rh':np.arange(27,40),
'precentral_rh':np.arange(40,56),
'superiortemporal_rh':np.arange(56,68),
'caudalanteriorcingulate_lh':np.arange(68,72),
'lateralorbitofrontal_lh':np.arange(72,79),
'parsopercularis_lh':np.arange(79,88),
'caudalmiddlefrontal_lh':np.arange(88,94),
'rostralmiddlefrontal_lh':np.arange(94,106),
'precentral_lh':np.arange(106,122),
'superiortemporal_lh':np.arange(122,135),
'supramarginal_lh':np.arange(135,145),
'supramarginal_rh':np.arange(145,153)}





#labels_name=labels[17:27]

tmin = 0
tmax = 2.4

#tmax = 2.4

#event_id = {'1': 2102, '2': 2105, '3': 2108, '4': 2111, '5': 2114, '6': 2117} 

event_id = {'1': 1002, '2': 1005, '3': 1008, '4': 1011, '5': 1014, '6': 1017} 

#event_id = {'1': 2002, '2': 2005, '3': 2008, '4': 2011, '5': 2014, '6': 2017} 

#event_id = {'1': 3002, '2': 3005, '3': 3008, '4': 3011, '5': 3014, '6': 3017} 

my_events = {'':np.array([1002, 1005, 1008, 1011, 1014, 1017]), 
             'impulse_':np.array([2002, 2005, 2008, 2011, 2014, 2017]), 
             'silent_impuse_': np.array([2102, 2105, 2108, 2111, 2114, 2117]), 
             'stimulus_': np.array([3002, 3005, 3008, 3011, 3014, 3017])}
    


subj_score =list()
labeldir = '/autofs/space/dodeca_003/users/cueshift_perm/resources/fslabels450/'

for subj in subjects[1:2]:
    
    epochs, inverse_operator = get_epochs_subj(subj,event_id,tmin,tmax)       

    for key, value in Lname.items():
        
        label_names=labels[value]
        parcel_name = key
        
        psd_labels_source(label_names,labeldir,subj,epochs, inverse_operator,
                      data_path, parcel_name)




    