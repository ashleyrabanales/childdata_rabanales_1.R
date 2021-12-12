install.packages("ggplot2")
install.packages("GGally")
install.packages("MASS")
install.packages("VIM")

library(ggplot2)
library(GGally)
library(MASS)
library(VIM)


#Stepwise selection
#p-value, adj rsq, akaike info criterion AIC
library(MASS)
wine <- read.csv("/Users/ashleyrabanales/Desktop/STAT 4210 - Regression/Data2/winequality.csv")

full_model <- lm(quality ~ ., data = wine)
print(summary(full_model))


stepAIC(full_model, direction ="both")

#final model <- lm(model)
print(summary(final_model))





