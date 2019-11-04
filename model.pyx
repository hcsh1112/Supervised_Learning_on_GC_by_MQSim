import sklearn.ensemble
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from joblib import load

class PyClass(object):
    def __init__(self):
        self.model = load('./joblib/6hour_RGA_origin.joblib')
        training = pd.read_csv( 'training_12hours_Random_P_20p.csv', sep='\t' )
        training_x = training.iloc[[0]] # pick up one row 
        self.df = training_x.drop(columns=['GC']) # return pd dataframe
        # self.df = training.ix[0,1:]

        '''
        # mapping table
        self.mapping = {}
        value = 0
        for c in range(0,8):
            for w in range(0,4):
                for d in range(0,2):
                    for p in range(0,2):
                        num = str(c) + str(w) + str(d) + str(p)
                        self.mapping.update({num : value})
                        value+=1
        '''
        print("init")

    def predict_one(self, Timetick, invalid_ratio, valid_ratio, free_ratio, victim_block_invalid_page, queue_size):
        # initial
        self.df[:] = 0

        # Timetick
        # Synetic
        self.df['Timetick'] = ( Timetick - 1456095153700917041  ) / ( 1456138798758441716  - 1456095153700917041  )
        # self.df['Timetick'] = Timetick / 10000022162322

        # invalid_ratio
        self.df['invalid_ratio'] = invalid_ratio

        # valid_ratio
        self.df['valid_ratio'] = valid_ratio

        # free_ratio
        self.df['free_ratio'] = free_ratio

        # victim_block_invalid_page
        self.df['victim_block_invalid_page'] = int(victim_block_invalid_page) / 256

        # normalizatio
        # ( X0 - min() ) / ( max() - min() )
        # between 0 and 1 
        self.df['queue_size'] = int(queue_size) / 3 

        '''
        # cwdp
        str_cwdp = 'cwdp_' + str(cwdp)
        self.df[str_cwdp] = 1 
        '''

        # numpy type
        x = (np.array(self.df, dtype='f'))

        # predict
        ans = self.model.predict(x)
        return int(ans[0])

cdef public object createPyClass():
    return PyClass()

cdef public int predict_one_C( object p, long long int Timetick, float invalid_ratio, float valid_ratio, float free_ratio, int victim_block_invalid_page, int queue_size):
    return p.predict_one( Timetick, invalid_ratio, valid_ratio, free_ratio, victim_block_invalid_page, queue_size )
'''
cdef public int CWDP_covert( object p, int C, int W, int D, int P) :
    cwdp = str(C) + str(W) + str(D) + str(P)
    return p.mapping[cwdp]
'''
cdef public void testing():
    print("testing")
