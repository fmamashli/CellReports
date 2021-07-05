#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  9 14:46:24 2020

@author: fm897
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul 19 11:01:47 2019

@author: fm897
"""

import numpy as np
import matplotlib.pyplot as plt


import mne
from mne.minimum_norm import apply_inverse, read_inverse_operator

print(__doc__)

#from joblib import Parallel, delayed

import csv

with open('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=' ')
    subjects = [row[0] for row in csv_reader]

subjects.pop(7)
subjects.pop(14)

text_file = open("/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt", "r")
labels = text_file.readlines()  
labels = np.array(labels)

ilab = 59

tmin = -.4
tmax = 2.0

#event_id = {'1': 1002, '2': 1005, '3': 1008, '4': 1011, '5': 1014, '6': 1017}  # just use two
event_id = {'1': 3002, '2': 3005, '3': 3008, '4': 3011, '5': 3014, '6': 3017}  # just use two

data_path = '/autofs/space/voima_001/users/awmrc/'
subjects_dir = '/autofs/space/voima_001/users/awmrc/subjects_mri/'


snr = 3.0
pick_ori = "normal"
lambda2 = 1.0 / snr ** 2
method = "dSPM"
mode = 'pca_flip'

labeldir = '/autofs/space/dodeca_003/users/cueshift_perm/resources/fslabels450/'
save_dir = '/autofs/space/taito_005/users/fahimeh/resources/decoding_results/timeseries/'

save_tc = np.empty([17,6,1201])
isubj=0

for subj in subjects[2:19]:
    
    raws = list()
    events = list()
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
                    baseline=(-0.4, -.2), preload=True,
                    reject=dict(grad=4000e-13, mag=4e-12),
                    decim=1)  # decimate to save memory and increase speed

    
    epochs.pick_types(meg=True)  # remove stim and EOG

    fname_inv = data_path + subj + '/megdata/' + subj + \
    '_aw_0.5_140_calc-inverse_loose_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif'

    inverse_operator = read_inverse_operator(fname_inv)

    src = inverse_operator['src']
    
    ievent=0
    for key, value in event_id.items():
        
        evoked = epochs[key].average()
       
        stc = apply_inverse(evoked, inverse_operator, lambda2, method, 
                            pick_ori=pick_ori)
        
        label_fname = labeldir + subj + '/fsmorphedto_' + subj + '-' + \
            labels[ilab][:-1]

   
        label = mne.read_label(label_fname)

        stc_label = stc.in_label(label)
    
        tc = stc.extract_label_time_course(label, src, mode=mode)

        save_tc[isubj,ievent,:] = tc[0]
        
        ievent+=1
        
    isubj+=1
    
save_file = save_dir + 'evoked_allsubjs_' + labels[ilab][:-1] 
t = 1e3 * stc_label.times
np.savez(save_file, save_tc = save_tc, t=t)    

#%%
import numpy as np
import matplotlib.pyplot as plt

save_dir = '/autofs/space/taito_005/users/fahimeh/resources/decoding_results/timeseries/'
save_fig_dir = '/autofs/space/taito_005/users/fahimeh/doc/Figures/decoding/time/'

mode = 'pca_flip'

text_file = open("/autofs/space/taito_005/users/fahimeh/doc/txt/label_names.txt", "r")
labels = text_file.readlines()  
labels = np.array(labels)

ilab = 58

save_file = save_dir + 'evoked_allsubjs_' + labels[ilab][:-1]

npzfile = np.load(save_file + '.npz')
    
save_tc = npzfile['save_tc']
t = npzfile['t']

            
fig, ax = plt.subplots(1)

ind_time1 = np.where(t/1000>-.1)[0]
ind_time2 = np.where(t/1000>1)[0]

for ievent in np.arange(0,6):
    
    ax.plot(t[ind_time1[0]:ind_time2[0]], save_tc.mean(axis=0)[ievent,ind_time1[0]:ind_time2[0]], 
        linewidth=2, label=str(ievent))

legend = ax.legend(loc='upper center', shadow=False, fontsize='x-large')

plt.show()

save_fig = save_fig_dir + 'mean_evoked_response_' + labels[ilab][:-1]

fig.savefig(save_fig,format='svg')















#data_path = '/autofs/space/voima_001/users/awmrc/'
#fname_fwd = data_path + 'awmrc_006/megdata/awmrc_006_aw_1-fwd.fif'
##fname_evoked = data_path + '/MEG/sample/sample_audvis-ave.fif'

#run='1'
#subj='awmrc_006'
#
#raw_fname = data_path + subj + '/megdata/' + subj + '_aw_' + run + '_0.5_140fil_raw.fif'
#
#eventn = data_path + subj + '/megdata/' + subj + '_aw_' + run + '_decim_recode_sss-eve.fif'
#
#fname_cov = data_path + 'awmrc_006/megdata/awmrc_006_erm_1_0.5-140fil-cov.fif'
#
#tmin, tmax = 0, 2.4
#event_id = {'1': 1002, '2': 1005, '3': 1008, '4': 1011, '5': 1014, '6': 1017}  # just use two
#
##event_id = {'1': 1002, '2': 1005}
## Setup for reading the raw data
#raw = mne.io.read_raw_fif(raw_fname, preload=True)
#raw.filter(None, 10., fir_design='firwin')
#events = mne.read_events(eventn)
#
## Set up pick list: MEG - bad channels (modify to your needs)
##raw.info['bads'] += ['MEG 2443']  # mark bads
#picks = mne.pick_types(raw.info, meg=True, eeg=False, stim=True, eog=True)
#
## Read epochs
#epochs = mne.Epochs(raw, events, event_id, tmin, tmax, proj=True,
#                    picks=picks, baseline=(None, 0), preload=True,
#                    reject=dict(grad=4000e-13),
#                    decim=5)  # decimate to save memory and increase speed
#
#noise_cov = mne.read_cov(fname_cov)
#inverse_operator = read_inverse_operator(fname_inv)
#
#stcs = apply_inverse_epochs(epochs, inverse_operator,
#                            lambda2=1.0 / snr ** 2, verbose=False,
#                            method="dSPM", pick_ori="normal")
#
#X = np.array([stc.lh_data for stc in stcs])  # only keep left hemisphere
#y = epochs.events[:, 2]
#
## prepare a series of classifier applied at each time sample
#
##scaler = StandardScaler()
##kbest = SelectKBest(f_classif, k=500)
##logistic = LinearModel(LogisticRegression(solver='lbfgs'))
##
##X_scaled = scaler.fit_transform(X, y)
##X_best = kbest.fit_transform(X_scaled, y)
##logistic.fit(X_best, y)
##
##patterns = get_coef(logistic, 'patterns_', inverse_transform=True)
##
##sdfdfdf
#

"""

"""
# time_decod.fit(X, y)
#sdfdfdfd
## Run cross-validated decoding analyses:
#
## Retrieve patterns after inversing the z-score normalization step:
##patterns = get_coef(time_decod, 'patterns_', inverse_transform=True)
#
#




#,multi_class='ovr')





