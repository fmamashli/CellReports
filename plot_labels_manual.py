#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  4 10:34:43 2019

@author: fm897
"""

import os
from surfer import Brain
import numpy as np

subject_id = "fsaverageSK"
hemi = "rh"
surf = "inflated"

brain = Brain(subject_id, hemi, surf, background='white',
              subjects_dir='/autofs/cluster/transcend/MRI/WMA/recons/')

#label_dir='/autofs/space/hypatia_001/users/fahimeh_MEG_Analyses/fmm/resources/fslabelsSK/'
label_dir='/autofs/space/dodeca_003/users/cueshift_perm/resources/fslabels450/'

mylist=['parsopercularis_1-rh.label',
'parsopercularis_2-rh.label',
'parsopercularis_3-rh.label',
'parsopercularis_4-rh.label',
'parsorbitalis_1-rh.label',
'parsorbitalis_2-rh.label',
'parstriangularis_1-rh.label',
'parstriangularis_2-rh.label',
'parstriangularis_3-rh.label',
'parstriangularis_4-rh.label',
'superiortemporal_1-rh.label',
'superiortemporal_2-rh.label',
'superiortemporal_3-rh.label',
'superiortemporal_4-rh.label',
'superiortemporal_5-rh.label',
'superiortemporal_10-rh.label',
'superiortemporal_11-rh.label',
'superiortemporal_6-rh.label',
'superiortemporal_7-rh.label',
'superiortemporal_8-rh.label',
'superiortemporal_9-rh.label',
'transversetemporal_1-rh.label',
#'transversetemporal_2-rh.label',
'supramarginal_1-rh.label',
'supramarginal_2-rh.label',
'supramarginal_3-rh.label',
'supramarginal_4-rh.label',
'supramarginal_5-rh.label',
'supramarginal_6-rh.label',
'supramarginal_7-rh.label',
'supramarginal_8-rh.label',
'caudalmiddlefrontal_1-rh.label',
'caudalmiddlefrontal_2-rh.label',
'caudalmiddlefrontal_3-rh.label',
'caudalmiddlefrontal_4-rh.label',
'caudalmiddlefrontal_5-rh.label',
#'caudalmiddlefrontal_6-rh.label',
'lateralorbitofrontal_1-rh.label',
'lateralorbitofrontal_2-rh.label',
'lateralorbitofrontal_3-rh.label',
'lateralorbitofrontal_4-rh.label',
'lateralorbitofrontal_5-rh.label',
'lateralorbitofrontal_6-rh.label',
'lateralorbitofrontal_7-rh.label',
'rostralmiddlefrontal_10-rh.label',
'rostralmiddlefrontal_11-rh.label',
'rostralmiddlefrontal_12-rh.label',
#'rostralmiddlefrontal_13-rh.label',
'rostralmiddlefrontal_1-rh.label',
'rostralmiddlefrontal_2-rh.label',
'rostralmiddlefrontal_3-rh.label',
'rostralmiddlefrontal_4-rh.label',
'rostralmiddlefrontal_5-rh.label',
'rostralmiddlefrontal_6-rh.label',
'rostralmiddlefrontal_7-rh.label',
'rostralmiddlefrontal_8-rh.label',
'rostralmiddlefrontal_9-rh.label',
'precentral_10-rh.label',
'precentral_11-rh.label',
'precentral_12-rh.label',
'precentral_13-rh.label',
'precentral_14-rh.label',
'precentral_15-rh.label',
'precentral_16-rh.label',
'precentral_1-rh.label',
'precentral_2-rh.label',
'precentral_3-rh.label',
'precentral_4-rh.label',
'precentral_5-rh.label',
'precentral_6-rh.label',
'precentral_7-rh.label',
'precentral_8-rh.label',
'precentral_9-rh.label']
#mylist=['parsopercularis_1-rh.label',
#'parsopercularis_2-rh.label',
#'parsopercularis_3-rh.label',
#'parsopercularis_4-rh.label',
#'parsorbitalis_1-rh.label',
#'parsorbitalis_2-rh.label']
#mylist=['transversetemporal_1-rh.label',
#'transversetemporal_2-rh.label']

#mylist=['parsopercularis_1-rh.label',
#'parsopercularis_2-rh.label',
#'parsopercularis_3-rh.label',
#'parsopercularis_4-rh.label',


freq_r=['alpha','beta','gamma']
index=2

#for i in np.arange(0,10):
#    
#    brain.add_label(label_dir + mylist[i], color='sienna',alpha=0.5)
#    brain.add_label(label_dir + mylist[i], color='black',borders=True)
#    
for i in np.arange(10,22):
    
   # brain.add_label(label_dir + mylist[i], color='khaki',alpha=0.4)
    brain.add_label(label_dir + mylist[i], color='khaki',alpha=0.4)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)
    
#for i in np.arange(22,30):
#    
#    brain.add_label(label_dir + mylist[i], color='lightblue',alpha=0.4)
#    brain.add_label(label_dir + mylist[i], color='black',borders=True)
#    
#for i in np.arange(30,36):
#    
#    brain.add_label(label_dir + mylist[i], color='yellow',alpha=0.8)
#    brain.add_label(label_dir + mylist[i], color='black',borders=True)

for i in np.arange(36,42):
    
    brain.add_label(label_dir + mylist[i], color='paleturquoise',alpha=0.8)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)

#for i in np.arange(42,54):
#    
#    brain.add_label(label_dir + mylist[i], color='palegreen',alpha=0.5)
#    brain.add_label(label_dir + mylist[i], color='black',borders=True)
# 
#for i in np.arange(54,70):
#    
#    brain.add_label(label_dir + mylist[i], color='lightsalmon',alpha=0.8)
#    brain.add_label(label_dir + mylist[i], color='black',borders=True)

    
#save_fig = '/autofs/space/taito_005/users/fahimeh/doc/Figures/coherence/results/'
save_fig = '/autofs/space/taito_005/users/fahimeh/doc/Figures/Power/'

brain.show_view("lateral")
#brain.save_image(save_fig + 'All_labels_color_' + hemi + '.tiff')
brain.save_image(save_fig + 'Power_significant_' + hemi + '.tiff')
