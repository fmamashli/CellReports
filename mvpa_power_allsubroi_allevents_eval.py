#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan  3 14:49:06 2020

@author: fm897
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 30 17:31:08 2019

@author: fm897
"""
# general
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

# statistics
from scipy import stats
import statsmodels.stats.multitest as smt


def find_min_event_num(y,event_id):
    
    event_num = np.empty(event_id.shape[0])
    
    for k in range(len(event_id)):
        event_num[k] = np.sum(y==event_id[k])
        
    return min(event_num)


def make_sub_average(min_event,event_id,xnew_reshape,y):
    
    nslices = 4
    total_trials = np.int(np.floor(min_event/nslices))
    new_x = np.empty([event_id.shape[0]*nslices , xnew_reshape.shape[1]])
    
    new_y = np.empty([event_id.shape[0]*nslices])
    k=0
    for ievent in np.arange(event_id.shape[0]):
        
        M = xnew_reshape[y==event_id[ievent],:]        
#        rp_M = np.random.permutation(M.shape[0])        
        
        for iteration in np.arange(nslices):
            
            new_x[k, :] = \
            M[iteration*total_trials:(iteration+1)*total_trials,:].mean(axis=0)
            
            new_y[k] = event_id[ievent]
            k+=1
            
    return new_x, new_y



def run_pow_decoding_subjects(name_tag,event_id,data_path,subjects,save_dir):
    
    Lname={'caudalmiddlefrontal_rh':np.arange(5,10),
    'lateralorbitofrontal_rh':np.arange(10,17),
    'parsopercularis_rh':np.arange(17,27),
    'rostralmiddlefrontal_rh':np.arange(27,40),
    'precentral_rh':np.arange(40,56),
 #   'superiortemporal_rh':np.arange(56,68),
    'lateralorbitofrontal_lh':np.arange(72,79),
    'parsopercularis_lh':np.arange(79,88),
    'caudalmiddlefrontal_lh':np.arange(88,94),
    'rostralmiddlefrontal_lh':np.arange(94,106),
    'precentral_lh':np.arange(106,122),
  #  'superiortemporal_lh':np.arange(122,135),
    'supramarginal_lh':np.arange(135,145),
    'supramarginal_rh':np.arange(145,153)}
    
    
    
    freq_band = np.unique(np.round(np.logspace(0.5,2.08, num=120)))
    freq_range = {'theta':np.arange(0,5),'alpha':np.arange(5,10),
              'beta':np.arange(10,28),'gamma':np.arange(28,48),
              'highgamma':np.arange(51,72)}


    for key, value in Lname.items():
        
        num_subroi = value.shape[0]
        parcel_name = key
        
        score_subj_frqbnd = np.empty([len(subjects[0:21]),len(freq_range)])
        isubj=0
        for subj in subjects[0:19]:        
        
            save_file = data_path + subj + '/megdata/' + subj + \
            '_aw_psd_3to120Hz_4Hz_' + name_tag + parcel_name + '_large_subroi'
        
        
            npzfile = np.load(save_file + '.npz')
    
            X_psd = npzfile['X_psd']
            y= npzfile['y']
            freqs = npzfile['freqs']
            nfreq = freqs.shape[0]
            min_event = find_min_event_num(y,event_id)
            
    
    
            P = np.empty([num_subroi,X_psd.shape[0],len(freq_band)-1])
            
            
            for ilabel in np.arange(0,num_subroi):
        
                X0 = X_psd[:,ilabel*nfreq:(ilabel+1)*nfreq]
        
                for ifr in range(len(freq_band)-1):            
            
                    P[ilabel,:,ifr] = X0[:,np.where((freqs>freq_band[ifr]) & 
                               (freqs<freq_band[ifr+1]))[0]].mean(axis=1)
            
            nf=0        
            for key, value in freq_range.items():
                            
                xnew = P[:,:,value] 
                
                xnew_reshape = np.reshape(xnew,[xnew.shape[1],
                                                xnew.shape[0]*xnew.shape[2]])
                
                new_x, new_y = make_sub_average(min_event,event_id,
                                                xnew_reshape,y)
                
                clf = make_pipeline(StandardScaler(), SVC())
            
                scores = cross_val_multiscore(clf, new_x, new_y, cv=4, 
                                              n_jobs=1)
                
               # scores = cross_val_multiscore(clf, xnew_reshape, y, cv=10, n_jobs=1)
                score = np.mean(scores, axis=0)
                
                print('Spatio-temporal: %0.1f%%' % (100 * score,))
                
                score_subj_frqbnd[isubj,nf] = score
                
                
                nf+=1
                
                del xnew, xnew_reshape, new_x, new_y
               # del xnew, xnew_reshape
            
            
            isubj+=1
            
        save_file = save_dir + 'MeanTrials_19subjs_5freq_' + name_tag + parcel_name + \
        '_power' 
        np.save(save_file, score_subj_frqbnd)
        
        del score_subj_frqbnd

    
    
data_path = '/autofs/space/voima_001/users/awmrc/'
save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/'


with open('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=' ')
    subjects = [row[0] for row in csv_reader]

subjects = subjects[0:7] + subjects[8:15] + subjects[16:]



#my_events = {'':np.array([1002, 1005, 1008, 1011, 1014, 1017]), 
#             'impulse_':np.array([2002, 2005, 2008, 2011, 2014, 2017]), 
#             'silent_impuse_': np.array([2102, 2105, 2108, 2111, 2114, 2117]), 
#             'stimulus_':np.array([3002, 3005, 3008, 3011, 3014, 3017])}
#    
my_events = {
             'impulse_':np.array([2002, 2005, 2008, 2011, 2014, 2017]), 
             'silent_impuse_': np.array([2102, 2105, 2108, 2111, 2114, 2117])}


for key, value in my_events.items():
    
    name_tag = key
    event_id = value
   
    run_pow_decoding_subjects(name_tag,event_id,data_path,subjects,save_dir)
    
    