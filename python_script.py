#this is a python script for my project

import pandas as pd
import numpy as np
import matplotlib as plt

#define any functions
def highscore(score):
    if score >= 150:
        return "Yes"
    elif score == np.nan:
        return np.nan
    else:
        return "No"


#import the files from the current working directory and store them as DF
path_to_file = "births.csv"
births = pd.read_csv(path_to_file)

path_to_file = "score.csv"
score = pd.read_csv(path_to_file)

#make into pandas dataframes
births = pd.DataFrame(births)
score = pd.DataFrame(score)

#refactor binary data with correct labesl
births['lowbw'] = births['lowbw'].map({1:"Yes",0:"No"})
births['preterm'] = births['preterm'].map({1:"Yes",0:"No"})
births['hyp'] = births['hyp'].map({1:"Yes",0:"No"})
births['sex'] = births['sex'].map({1:"Male",2:"Female"})

#remove NA results
births = births.dropna()

#merge the births data with the score 
births = pd.merge(births, score, how = 'outer')
#reordering by score ascending
births = births.sort_values('score')

#check the correlation between continuous variables

corr_births = births[['bweight','gestwks','matage','score']].copy()
correlation = corr_births.corr(method = 'spearman')

print(correlation)
print(births)

######################## TO DO 
######################## two way dist of cat vars


births["highscore"] = births['score'].apply(highscore)
print(births.tail())


