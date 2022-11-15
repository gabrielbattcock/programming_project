#candidate number: 221352
#Programming assessment 2022

#python code

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt 



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
print("Check that the categorical data has been transformed: \n", births.head())

#remove NA results
births = births.dropna()
print("Check that the third value with NA has been dropped: \n", births.head())

#merge the births data with the score 
births = pd.merge(births, score, how = 'outer')
print("The new data set comprising both the trasnformed births data and the score: \n",
    births.head(), "\n",
    births.tail(), "\n"
)
print("As we have used an out join and there are some missing score values, some IDs contain a null score field. \n")

#reordering by score ascending
births = births.sort_values('score')
print("Check that the head is ordered by score: \n", births.head())


#check the correlation between continuous variables 
corr_births = births[['bweight','gestwks','matage','score']].copy()
correlation = corr_births.corr()

print("Presented is a correlation matrix for the continuous variables of the dataset: \n", correlation, "\n")

#two way distribution of cat vars

sex_bw = pd.crosstab(index = births["lowbw"], columns = births["sex"])
print("Two way frequency table between low birth weight and sex: \n", sex_bw, "\n")

preterm_bw = pd.crosstab(index = births["lowbw"], columns = births["preterm"])
print("Two way frequency table between low birth weight and a preterm baby: \n", preterm_bw, "\n")

hyp_bw = pd.crosstab(index = births["lowbw"], columns = births["hyp"])
print("Two way frequency table between low birth weight and hypertension: \n", hyp_bw, "\n")

preterm_hyp = pd.crosstab(index = births["hyp"], columns = births["preterm"])
print("Two way frequency table between a preterm baby and hypertension: \n", preterm_hyp, "\n")

preterm_sex = pd.crosstab(index = births["preterm"], columns = births["sex"])
print("Two way frequency table between a preterm baby and sex: \n", preterm_sex, "\n")

sex_hyp = pd.crosstab(index = births["hyp"], columns = births["sex"])
print("Two way frequency table between hypertension and sex: \n", sex_hyp, "\n")

#create a new binary column for a score of >150
#need to keep the NaNs in so that teh aggregate calculation is correct
births["highscore"] = births['score'].apply(lambda x: np.nan if pd.isnull(x) else "Yes" if x >= 150 else "No")
print("check that the NaNs have been kept: \n", births.head(),'\n', births.tail())

#aggreagated version of data set with average birthweight by highscore and sex
aggregate = births.groupby(['sex','highscore']).agg({'bweight':'mean'})
print("Mean birth weight by sex and highscore : \n", aggregate)

#create a plot of bweight against gestwks as these are the only variables with corr> 0.5

bweight = births['bweight'].to_numpy()
gestwks = births['gestwks'].to_numpy()
fig, ax = plt.subplots()
plt.grid()
ax.scatter(gestwks, bweight, alpha=0.5)
ax.set_xlabel('Gestational weeks')
ax.set_ylabel('Birth weight (g)')
ax.set_title('')
plt.show()
fig.savefig("bweight_plot_py.pdf",dpi=fig.dpi)


#save the final dataset
filepath = 'births_output_py.csv'
births.to_csv(filepath)  

