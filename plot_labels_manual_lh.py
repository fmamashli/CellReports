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
hemi = "lh"
surf = "inflated"

brain = Brain(subject_id, hemi, surf, background='white',
              subjects_dir='/autofs/cluster/transcend/MRI/WMA/recons/')

#label_dir='/autofs/space/hypatia_001/users/fahimeh_MEG_Analyses/fmm/resources/fslabelsSK/'
label_dir='/autofs/space/dodeca_003/users/cueshift_perm/resources/fslabels450/'

mylist=['parsopercularis_1-lh.label',
'parsopercularis_2-lh.label',
'parsopercularis_3-lh.label',
'parsopercularis_4-lh.label',
'parsorbitalis_1-lh.label',
'parsorbitalis_2-lh.label',
'parstriangularis_1-lh.label',
'parstriangularis_2-lh.label',
'parstriangularis_3-lh.label',
'parstriangularis_3-lh.label',
'superiortemporal_1-lh.label',
'superiortemporal_2-lh.label',
'superiortemporal_3-lh.label',
'superiortemporal_4-lh.label',
'superiortemporal_5-lh.label',
'superiortemporal_10-lh.label',
'superiortemporal_11-lh.label',
'superiortemporal_6-lh.label',
'superiortemporal_7-lh.label',
'superiortemporal_8-lh.label',
'superiortemporal_9-lh.label',
'transversetemporal_1-lh.label',
'transversetemporal_2-lh.label',
'supramarginal_1-lh.label',
'supramarginal_2-lh.label',
'supramarginal_3-lh.label',
'supramarginal_4-lh.label',
'supramarginal_5-lh.label',
'supramarginal_6-lh.label',
'supramarginal_7-lh.label',
'supramarginal_8-lh.label',
'caudalmiddlefrontal_1-lh.label',
'caudalmiddlefrontal_2-lh.label',
'caudalmiddlefrontal_3-lh.label',
'caudalmiddlefrontal_4-lh.label',
'caudalmiddlefrontal_5-lh.label',
'caudalmiddlefrontal_6-lh.label',
'lateralorbitofrontal_1-lh.label',
'lateralorbitofrontal_2-lh.label',
'lateralorbitofrontal_3-lh.label',
'lateralorbitofrontal_4-lh.label',
'lateralorbitofrontal_5-lh.label',
'lateralorbitofrontal_6-lh.label',
'lateralorbitofrontal_7-lh.label',
'rostralmiddlefrontal_10-lh.label',
'rostralmiddlefrontal_11-lh.label',
'rostralmiddlefrontal_12-lh.label',
#'rostralmiddlefrontal_13-lh.label',
'rostralmiddlefrontal_1-lh.label',
'rostralmiddlefrontal_2-lh.label',
'rostralmiddlefrontal_3-lh.label',
'rostralmiddlefrontal_4-lh.label',
'rostralmiddlefrontal_5-lh.label',
'rostralmiddlefrontal_6-lh.label',
'rostralmiddlefrontal_7-lh.label',
'rostralmiddlefrontal_8-lh.label',
'rostralmiddlefrontal_9-lh.label',
'precentral_10-lh.label',
'precentral_11-lh.label',
'precentral_12-lh.label',
'precentral_13-lh.label',
'precentral_14-lh.label',
'precentral_15-lh.label',
'precentral_16-lh.label',
'precentral_1-lh.label',
'precentral_2-lh.label',
'precentral_3-lh.label',
'precentral_4-lh.label',
'precentral_5-lh.label',
'precentral_6-lh.label',
'precentral_7-lh.label',
'precentral_8-lh.label',
'precentral_9-lh.label']
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

for i in np.arange(0,9):
    
    brain.add_label(label_dir + mylist[i], color='sienna',alpha=0.5)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)
    
for i in np.arange(10,23):
    
    brain.add_label(label_dir + mylist[i], color='khaki',alpha=0.4)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)
    
for i in np.arange(23,31):
    
    brain.add_label(label_dir + mylist[i], color='lightblue',alpha=0.4)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)
    
for i in np.arange(31,37):
    
    brain.add_label(label_dir + mylist[i], color='yellow',alpha=0.8)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)

for i in np.arange(37,43):
    
    brain.add_label(label_dir + mylist[i], color='paleturquoise',alpha=0.8)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)

for i in np.arange(43,56):
    
    brain.add_label(label_dir + mylist[i], color='palegreen',alpha=0.4)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)
 
for i in np.arange(56,72):
    
    brain.add_label(label_dir + mylist[i], color='lightsalmon',alpha=0.6)
    brain.add_label(label_dir + mylist[i], color='black',borders=True)

    
save_fig = '/autofs/space/taito_005/users/fahimeh/doc/Figures/coherence/results/'

brain.show_view("lateral")
#brain.save_image(save_fig + 'All_labels_color_' + hemi + '.tiff')
brain.save_image(save_fig + 'All_labels_color_borders_' + hemi + '.tiff')
