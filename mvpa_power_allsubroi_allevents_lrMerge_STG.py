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

def load_npzfile(save_file,event_id,num_subroi,freq_band):
    
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
    
    return P, min_event, y


def run_pow_decoding_subjects(name_tag,event_id,data_path,subjects,save_dir):
    
    Lname={        
    'superiortemporal_rh':np.arange(56,68)}
    
    Lnamelh={    
    'superiortemporal_rh':np.arange(56,68),
    'superiortemporal_lh':np.arange(122,135)}
    
    
    freq_band = np.unique(np.round(np.logspace(0.5,2.08, num=120)))
    freq_range = {'theta':np.arange(0,5),'alpha':np.arange(5,10),
              'beta':np.arange(10,28),'gamma':np.arange(28,48),
              'highgamma':np.arange(51,72)}


    for key, value in Lname.items():
        
        #num_subroi = value.shape[0]
        parcel_name = key
        
        score_subj_frqbnd = np.empty([len(subjects[0:21]),len(freq_range)])
        isubj=0
        for subj in subjects[0:21]:        
        
            num_subroi = Lname[parcel_name].shape[0]
            
            save_file = data_path + subj + '/megdata/' + subj + \
            '_aw_psd_3to120Hz_4Hz_' + name_tag + parcel_name + '_large_subroi'
        
            P1, min_event1, y1 = load_npzfile(save_file,event_id,num_subroi,freq_band)
            
            parcel_lh = parcel_name[:-2] + 'lh'
            save_file = data_path + subj + '/megdata/' + subj + \
            '_aw_psd_3to120Hz_4Hz_' + name_tag + parcel_lh + '_large_subroi'
            
            del num_subroi
            
            num_subroi = Lnamelh[parcel_lh].shape[0]
            
            P2, min_event2, y2 = load_npzfile(save_file,event_id,num_subroi,freq_band)
            
            del num_subroi
            
            nf=0        
            for key, value in freq_range.items():
                
                freq_name = key
                xnew = P1[:,:,value] 
                
                xnew_reshape = np.reshape(xnew,[xnew.shape[1],
                                                xnew.shape[0]*xnew.shape[2]])
                
                new_x1, new_y1 = make_sub_average(min_event1,event_id,
                                                xnew_reshape,y1)
                
                del xnew, xnew_reshape
                
                xnew = P2[:,:,value] 
                
                xnew_reshape = np.reshape(xnew,[xnew.shape[1],
                                                xnew.shape[0]*xnew.shape[2]])
                
                new_x2, new_y2 = make_sub_average(min_event2,event_id,
                                                xnew_reshape,y2)
                
                X = np.concatenate((new_x1,new_x2),axis=1)
                
                save_file = save_dir + 'Power_' + name_tag + \
                parcel_name[:-2] + subj + freq_name
        
                np.savez(save_file, X, new_y2)

              #  clf = make_pipeline(StandardScaler(), SVC())
            
               # scores = cross_val_multiscore(clf, X, new_y1, cv=4, 
               #                               n_jobs=1)
                
               # score = np.mean(scores, axis=0)
                
               # print('Spatio-temporal: %0.1f%%' % (100 * score,))
                
               # score_subj_frqbnd[isubj,nf] = score
                
                
              #  nf+=1
                
                del xnew, xnew_reshape, new_x2, new_y2, X
               
            
            
            isubj+=1
            
        save_file = save_dir + 'MeanTrials_lhrh_5freq_21subjs_' + name_tag + \
        parcel_name[:-2] + '_power' 
        
        np.save(save_file, score_subj_frqbnd)
        
        del score_subj_frqbnd

    
    
data_path = '/autofs/space/voima_001/users/awmrc/'
save_dir = '/autofs/space/taito_005/users/fahimeh/resources/power/'


with open('/autofs/space/taito_005/users/fahimeh/doc/txt/list_1.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=' ')
    subjects = [row[0] for row in csv_reader]




#my_events = {'':np.array([1002, 1005, 1008, 1011, 1014, 1017]), 
#             'impulse_':np.array([2002, 2005, 2008, 2011, 2014, 2017]), 
#             'silent_impuse_': np.array([2102, 2105, 2108, 2111, 2114, 2117]), 
#             'stimulus_':np.array([3002, 3005, 3008, 3011, 3014, 3017])}

my_events = { 
             'impulse_':np.array([2002, 2005, 2008, 2011, 2014, 2017]), 
             'silent_impuse_': np.array([2102, 2105, 2108, 2111, 2114, 2117])}



for key, value in my_events.items():
    
    name_tag = key
    event_id = value
   
    run_pow_decoding_subjects(name_tag,event_id,data_path,subjects,save_dir)
    
    