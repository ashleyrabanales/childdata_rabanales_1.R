
# %%
import numpy as py
# %%
type(bmi) # specific type of variable
#float, loating point: a number that has both an integer and fractional part, separated by a point.
#int -  integer: a number without a fractional part.
#str - A string is Python's way to represent text
# Bool -  boolean: a type to represent logical values. Can only be True or False (the capitalization is important!).

#python list
fam = [1.73, 1.68, 1.72, 1.89]

#adding strings to name
fam2= [["a", 1.73],
        ["b", 1.68],
        ["e", 1.72], 
        ["w", 1.89]]
print(fam2)

#or
#%%
a = 1.73,
b = 1.68
e = 1.72,
w = 1.89
#%%
fam4 = ["ash", a,
        "bob", b,
        "ellie", e,
        "will", w]

# %%

#Subsetting List
#%%
fam2= [["a", 1.73],
        ["b", 1.68],
        ["e", 1.72], 
        ["w", 1.89]]
fam2[3] #selecting list 
fam2[-3] #selects the height




#List Slicing
#example
fam2[3:5]
#print , [ start (inclusive) : end (exclusive)]
#syntax: the index you specify before the colon, 
# so where the slice starts, is included, while the index 
# you specify after the colon, where the slice ends, is not

fam2 [:4]#star from 0 till 4th

fam2[5:]
#If you leave out the index where the slice should end, 
# you include all elements up to and including the last element in the list, like here
#%%
#Practice
# Create the areas list
areas = ["hallway", 11.25, "kitchen", 18.0, "living room", 20.0, "bedroom", 10.75, "bathroom", 9.50]
#%%
# Print out second element from areas
print(areas[_])
#%%
# Print out last element from areas
print(areas[__])
#%%
# Print out the area of the living room
print(areas[_])
#%%
#%%