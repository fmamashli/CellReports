#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 22 15:43:24 2020

@author: fm897
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 22 15:14:31 2020

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

from scipy import stats as stats

from mne import spatial_src_connectivity
from mne.stats import spatio_temporal_cluster_test, summarize_clusters_stc


print(__doc__)

#from joblib import Parallel, delayed

import csv

with open('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=' ')
    subjects = [row[0] for row in csv_reader]

# remove left handed people
subjects.pop(7)
subjects.pop(14)
#event_id = {'1': 1002, '2': 1005, '3': 1008, '4': 1011, '5': 1014, '6': 1017}  # just use two
#event_id = {'1': 3002, '2': 3005, '3': 3008, '4': 3011, '5': 3014, '6': 3017}  # just use two


data_path = '/autofs/space/voima_001/users/awmrc/'
subjects_dir = '/autofs/space/voima_001/users/awmrc/subjects_mri/'
save_dir ='/autofs/space/taito_005/users/fahimeh/doc/Figures/decoding/time/'

#name_tag='memorization'
name_tag='impulseActual'

if name_tag=='memorization':
    time_tag='_0.5to2s_'
else:
    time_tag='_0to1s_'


data_subj = np.empty([17,20484,10])
isubj=0
for subj in subjects[2:19]:
     
    
    fname = data_path + subj + '/megdata/'+ name_tag + '_' + subj + time_tag + \
    'pca100_aw_decoding_scores'
 #   fname = data_path + subj + '/megdata/memorization_' + subj + '_pca100_aw_decoding_scores'
    
    stc_feat = mne.read_source_estimate(fname)

    morph = mne.compute_source_morph(stc_feat, subj, 'fsaverage', smooth=5,
                               warn=False,
                               subjects_dir=subjects_dir)
    
    stc_xhemi = morph.apply(stc_feat)


    data_subj[isubj,:,:] = stc_xhemi.data[:,:10]
    
    isubj+=1

#%% conducting cluster statistics
    
src_fname = '/autofs/cluster/transcend/MRI/WMA/recons/fsaverageSK/bem/' + \
'fsaverage-ico-5-src.fif'
src = mne.read_source_spaces(src_fname)
print('Computing connectivity.')
connectivity = spatial_src_connectivity(src)

p_threshold = 0.05

n_subjects1=len(subjects[2:19])
n_subjects2=len(subjects[2:19])

f_threshold = stats.distributions.f.ppf(1. - p_threshold / 2.,
                                        n_subjects1 - 1, n_subjects2 - 1)
print('Clustering.')

X1=np.transpose(data_subj,[0,2,1])
X2=np.ones(X1.shape)*1/6
X=[X1,X2]

T_obs, clusters, cluster_p_values, H0 = clu =\
    spatio_temporal_cluster_test(X, connectivity=connectivity, n_jobs=1,
                                 threshold=f_threshold, n_permutations =10,  
                                 tail=1, buffer_size=None)
#    Now select the clusters that are sig. at p < 0.05 (note that this value
#    is multiple-comparisons corrected).
good_cluster_inds = np.where(cluster_p_values < 0.12)[0]

fsave_vertices = [np.arange(10242), np.arange(10242)]

subjects_dir ='/autofs/cluster/transcend/MRI/WMA/recons/'

stc_all_cluster_vis = summarize_clusters_stc(clu, p_thresh=0.12,
                                             vertices=fsave_vertices,
                                             subject='fsaverageSK')

brain = stc_all_cluster_vis.plot('fsaverageSK', hemi='both',
                                 views='lateral', subjects_dir=subjects_dir,
                                 time_label='Duration significant (ms)')
                                 

#%% testing with t-test to see the t-values

t_values=np.empty([20484,10])
for ivert in np.arange(data_subj.shape[1]):
    
    t,p = stats.ttest_1samp(data_subj[:,ivert,0],1/6)
    t_values[ivert,:10]=t


vertices = [stc_xhemi.lh_vertno, stc_xhemi.rh_vertno]


stc_feat = mne.SourceEstimate(t_values, vertices=vertices,
                          tmin=stc_xhemi.tmin, tstep=stc_xhemi.tstep, subject='fsaverage') 

brain = stc_feat.plot(subject = 'fsaverage', views=['lat'], transparent=True,
                  initial_time=stc_feat.times[0], time_unit='s',
                  subjects_dir=subjects_dir, hemi = 'split', background = 'white',
                  clim=dict(kind='value', lims=(1.75, 2.5, 4)), size = (1200,600))

filen = save_dir + '/'+ name_tag +'_tvalues_' + subj + '.png'
brain.save_image(filen)

#%%
vertices = [stc_xhemi.lh_vertno, stc_xhemi.rh_vertno]

#data = data_subj.mean(axis=0)
data = np.median(data_subj,axis=0)
stc_feat = mne.SourceEstimate(data, vertices=vertices,
                          tmin=stc_xhemi.tmin, tstep=stc_xhemi.tstep, subject='fsaverage') 

brain = stc_feat.plot(subject = 'fsaverage', views=['lat'], transparent=True,
                  initial_time=stc_feat.times[0], time_unit='s',
                  subjects_dir=subjects_dir, hemi = 'split', background = 'white',
                  clim=dict(kind='value', lims=(0.18, 0.19, 0.20)), size = (1200,600))
filen = save_dir + '/'+ name_tag +'_mean_decoding_cortex_' + subj + '.png'
brain.save_image(filen)