#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 30 11:31:01 2019

@author: fm897
"""

import mne
import csv

data_path = '/autofs/space/voima_001/users/awmrc/'

runs=['1','2','3','4']
#runs=['2','3','4','5']

merge_events_list=[[2,3],[5,6],[8,9],[11,12],[14,15],[17,18]]

        
with open('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=' ')
    subjects = [row[0] for row in csv_reader]

for subj in subjects[1:2]:

    for run in runs:
        
        eventn = data_path + subj + '/megdata/' + subj + '_aw_' + run + \
        '_decim_recode_sss-eve.fif'
        
        
        events = mne.read_events(eventn)
        
        merged_events = events
        for l in range(len(merge_events_list)):
            
            event_id = merge_events_list[l]
            new_id = merge_events_list[l][0] + 3000
            merged_events = mne.merge_events(merged_events,event_id,new_id,
                                             replace_events=True)

        new_events = eventn = data_path + subj + '/megdata/' + subj + '_aw_' \
        + run + '_decim_recode_sss_mergestim-eve.fif'
            
        mne.write_events(new_events,merged_events)
            
            