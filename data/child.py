#%%
import pandas as pd
import matplotlib as plt
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.graphics.mosaicplot import mosaic
from itertools import product
#%%
#https://medium.com/analytics-vidhya/hello-everyone-4f9400e008dc
child = pd.read_csv("/Users/ashleyrabanales/Desktop/STAT 4210 - Regression/Data Sets/FC2019v1.csv")
#%%
child.describe(exclude=[np.number])  
child.describe()


# Drop incomplete values in race 
#R-m code into python
child = child[!child$race_ethnicity=="",]
child = child[complete.cases(child$race_ethnicity),]

#creating a new vari for race/enthnicity 



chart.save("screenshots/altair_diamonds_price_density.png")