#%%
import pandas as pd
import matplotlib as plt
import numpy as np
from plotnine import *
#%%

child = pd.read_csv("/Users/ashleyrabanales/Desktop/STAT 4210 - Regression/Data Sets/.FC2019v1.csv.icloud")

child.describe(exclude=[np.number])  

child.describe()

# Drop incomplete values in race 
child = child[!child$race_ethnicity=="",]
child = child[complete.cases(child$race_ethnicity),]

#creating a new vari for race/enthnicity 

