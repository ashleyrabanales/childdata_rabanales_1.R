library(tidyverse)
install.packages("jsonlite")
library(jsonlite)
library(ggplot2)
library(dbplyr)
library(sf)
library(statar)
library(lubridate)

library(tidyverse)
library(sf) #sf and stars packages operate on simple feature obj. 
library(USAboundaries)
library(leaflet)

install.packages("remotes")
remotes::install_github("ropensci/USAboundaries")
remotes::install_github("ropensci/USAboundariesData")
install.packages("USAboundaries")
install.packages("USAboundariesData", repos = "http://packages.ropensci.org", type = "source")
install.packages("leaflet")

child <- read.csv ("/Users/ashleyrabanales/Desktop/STAT 4210 - Regression/Data Sets/FC2019v1.csv") 
print(child)#checking if imported correctly


# Generate wait time variable
child$wait_time <- as.Date(as.character(child$cursetdt), format="%Y-%m-%d") - 
  as.Date(as.character(child$latremdt), format="%Y-%m-%d")
child$wait_time <- as.numeric(child$wait_time)

# Eliminate children with missing race
child = child[!(child$race=="Race missing or unknown"),]

# creating the level factor variable / setting white as primary
child$race <- relevel(factor(child$race), "White")

#set child age as a numeric variable
child$ageatstart <-as.numeric(child$ageatstart)

#setting neglect/race for yes & factor
child_data$neglect <- relevel(factor(child_data$neglect), "Yes")

na.omit(child2$neglect)






child2 <- child %>%
  str_sub(child$rem1dt, 1,4) 

  str_sub(child$rem1dt, 1,4) = '2019'

substr(df$"year col name", 1,5) = '2019'

child2$rem1dt <- substr(rem1dt$"year col name", 1,5) = '2019'


#Regression for wait time by each race 
options(scipen=99)
regression_model <- lm(wait_time ~ ageatstart + race, data=child) 
print(summary(regression_model))

regressions_results = lm(wait_time ~ race, data = child)
residuals = resid(regressions_results)

plot(fitted(regressions_results), residuals,
     ylab = "Residuals", xlab="Predicted Wait Time", 
     main ="Figure 1: Regression Line of Wait Time by Neglect and Race")
abline(0,0)

tab(child, rem1dt) #(1st day removal) + age

library(tidyverse)

## Read in Grad School Admit Data ##


gs <- readr::read_csv("binary.csv")

## Integrity Check ##

summary(child)
str(child)

## Since "rank" is technically a categorical variable (rank "1" means high prestige
## undergrad school,rank "4" means lowest prestige) let's make sure we have a
## reasonable amount of 0's and 1' for admit within each level of rank

table(gs$admit,gs$rank)
table(gs$admit)

## Okay, it looks like we won't have a problem with imbalanced class sizes ##

## Let's go ahead and fit our logistic regression model ##

child$neglect <- factor(child$neglect)

gs$rank1 <- relevel(gs$rank,ref="4") #set rank 4 as baseline rank
## creating a new column

## logistic regression
lmod <- glm(neglect ~ race + wait_time , data = child, family = "binomial")

##glm stands for generalized linear model

## Despite Logistic Regression not having quite as restrictive assumptions
## as linear, we still have to make sure we don't have too much multicollinearity ##


## variance inflation factor
car::vif(lmod)

## Okay, great! Let's check out the summary of our model ##

summary(lmod)

## We can build an ROC curve to assess the predictive capability of the model ##

my_roc <- ROSE::roc.curve(lmod$y,fitted(lmod),plotit = T)
## ROSE::roc.curve(model$y, fitted(model), plot yes/no)
my_roc

## While Logistic Regression doesn't estimate coefficients using sums of squares,
## we can still obtain a pseudo-R^2 value ##

DescTools::PseudoR2(lmod,which="McKelveyZavoina")

## The summary output gives gross output like from last week. Using the broom package,
## we can tidy this up ##

lmod %>%
  broom::tidy(conf.int=T,exponentiate=T)

exp(lmod$coefficients) #untransforming coefficients
## exp stands for e^

## Because the exponentiated coefficients are standardized values, this would be
## a great application of the confidence interval plot generated last week ##


##Intrepreting gpa
## As gpa increase by 1 point, the odds of admissions into grad school increase
## by 123%

# 2.23 - 1*100= 123%

p <- lmod %>%
  broom::tidy(conf.int=T,exponentiate=T) %>%
  dplyr::mutate(Sig = if_else(p.value < 0.05,"Significant",
                              "Non-Significant")) %>%
  ggplot(aes(x=term,y=estimate)) +
  geom_errorbar(aes(ymin=conf.low,ymax=conf.high,color=factor(Sig)),width=0.1) +
  geom_point(aes(color=factor(Sig))) +
  geom_hline(aes(yintercept = 1),color="black",linetype="dashed") +
  labs(x = "Variable",
       y = "Estimated Exponentiated Coefficient",
       color = "Statistical \n Significance") +
  theme_classic() + coord_flip() +
  ggtitle("Confidence Intervals for Logistic Regression Analysis") +
  theme(plot.title = element_text(hjust=0.5))

p

library(plotly)
plotly::ggplotly(p)

## Another useful graph might be one of the predicted probabilities.
## Here, let's say, for a fixed value of UG GPA (3.5), we want to see
## how the predicted probability of admission differs across GRE scores as well as
## between prestige of undergraduate institution.

new_gs1 <- tibble(gpa = rep(3.5,100), #repeats 3.5 100 times
                  rank1 = rep(1,100), #repeats 1 100 times
                  gre = seq(200,800,length.out = 100)) #sequence of GRE scores
## creates fake data
## column names of fake data must be same as real data column names

new_gs2 <- tibble(gpa = rep(3.5,100),
                  rank1 = rep(2,100), #rank is at rank 2
                  gre = seq(200,800,length.out = 100))

new_gs3 <- tibble(gpa = rep(3.5,100),
                  rank1 = rep(3,100),
                  gre = seq(200,800,length.out = 100))

new_gs4 <- tibble(gpa = rep(3.5,100),
                  rank1 = rep(4,100),
                  gre = seq(200,800,length.out = 100))

new_gs <- dplyr::bind_rows(new_gs1,new_gs2,new_gs3,new_gs4)
#bind 4 datasets together

new_gs$rank1 <- factor(new_gs$rank1) #changes rank to be categorical

new_gs$probs <- predict.glm(lmod,newdata=new_gs,type="response")
## predict.glm gives predictions based on data and linear model
## type = response gives predicted probabilities

new_gs

new_gs %>%
  ggplot(aes(x=gre,y=probs)) + #specify x and y axes
  geom_line(aes(color=rank1)) + labs(x = "GRE Scores",
                                     y = "Predicted Probability of Admission",
                                     color = "Undergraduate School \n Prestige") +
  theme_classic() + ggtitle("Predicted Probability of Graduate School Admission",
                            subtitle = "for fixed Undergraduate GPA of 3.5") +
  theme(plot.title=element_text(hjust=0.50),
        plot.subtitle=element_text(hjust=0.50))

## Model Validation ##

set.seed(12345)

## Split up gs into a training and testing set ##

####
samp <- sample(c("train","test"), nrow(gs), replace = T, prob = c(.7, .3))

#samp <- sample(c(TRUE,FALSE),nrow(gs),replace=T,prob=c(0.70,0.30))
# sample(vector to sample from, how many times to sample,
## replace yes/no, probabilities associated with each value in vector)
## we want about 70% of data in training set, 30% in test

samp


gs_train <- gs[samp == "train",] #only keep rows where samp = train

gs_test <- gs[samp == "test",] #only keep rows where samp = test

## Build Model using Training Set ##

tmod <- glm(admit ~ gre + gpa + rank1, data = gs_train, family = "binomial")

## Assess VIF ##

car::vif(tmod)

## ROC curve ##

ROSE::roc.curve(tmod$y,fitted(tmod),plotit = T)

## Okay, so the training model has a lot of the same characteristics as the
## traditional approach we have seen previously. So now, how do we assess
## classification accuracy? ##

## First, obtain predicted probabilities for testing set ##

gs_test$pred_probs <- predict.glm(tmod,newdata=gs_test,type="response")

## Let's say that a probability of > 0.50 indicates a successful admission and
## < 0.50 is an unsuccessful admission ##

my_table <- table(gs_test$admit,gs_test$pred_probs > 0.50)
addmargins(my_table)

## Specificity ##
## proportion of true negatives that were classified as negative

pt <- table(gs_test$admit,gs_test$pred_probs > 0.50)

pt[1,1]/sum(pt[1,])

##first row, first column / first row total
## gives specificity
## 82/87

## This means we are 94.25% accurate in predicting unsuccessful admissions ##

## Sensitivity ##
## proportion of true positives that were classified as positive

pt[2,2]/sum(pt[2,])

## This means we're not so good at detecting successful admissions ##


## Optional ##
## However, the cut off point of 0.50, while commonly used and logical,
## is arbitrarily chosen. How do we choose a cut off point that well
## categorizes our observations?? ##

cp <- seq(0.50,0.95,by=0.01) #potential cutoff values
sn <- vector("double",length(cp)) #sensitivity
sp <- vector("double",length(cp)) #specificity

for(i in 1:length(cp)){
  
  tab <- table(gs_test$admit,gs_test$pred_probs > cp[i])
  
  sp[i] <- ifelse(dim(tab)[2] == 1,0,tab[1,1]/sum(tab[1,]))
  
  sn[i] <- ifelse(dim(tab)[2] == 1,0,tab[2,2]/sum(tab[2,]))
  
}

p <- ggplot() +
  geom_line(aes(x = cp, y = sn),color='blue') + #sensitivity in blue
  geom_line(aes(x = cp, y = sp),color='red') + #specificity in red
  theme_classic() + labs(x = "Cut Points",
                         y = "Probabilities") +
  scale_x_continuous(breaks = seq(0.50,0.90,by=0.05))

p

plotly::ggplotly(p)
## We want to choose a cut point such that sensitivity & specificity are maximized ##

## To me this looks like around 0.52 ##

## Let's try it ##

table(gs_test$admit,gs_test$pred_probs > 0.52) %>%
  prop.table()

pt <- table(gs_test$admit,gs_test$pred_probs > 0.52)

## Sensitivity ##

pt[1,1]/sum(pt[1,])

## Specificity ##

pt[2,2]/sum(pt[2,])