library(tidyverse)
library(dplyr)
library(tidyr)
library(ggplot2)
library(sf)
library(statar)
library(USAboundaries)
library(leaflet)
library(geofacet)
library(RColorBrewer)
#install.packages('geofacet')




#Q1. how many children were remove in the year of 2019 by state?
#Q2. were children removed because of socioeconomics or abused?
#Q3. is there a difference between races and wait time in adoption?

#https://www.statology.org/conditional-mutating-r/
child_data <- read.csv ("/Users/ashleyrabanales/Desktop/STAT 4210 - Regression/Data Sets/FC2019v1.csv") 
head(child_data)#checking if imported correctly

#creating a new vari for race/enthnicity 

child <- child_data %>%
  mutate (race_ethnicity = 
            case_when(amiakn == 'Yes' ~ 'American Indian or Alaska Native',
              asian == 'Yes' ~ 'Asian',
              blkafram == 'Yes' ~ 'Black/African American',
              hawaiipi == 'Yes' ~ 'Hawaiian or Other Pacific Islander',
              white == 'Yes'~ 'White',
              hisorgin == 'Yes' ~ 'Hispanic')) 

# Drop incomplete values in race 
child = child[!child$race_ethnicity=="",]
child = child[complete.cases(child$race_ethnicity),]

head(child$race_ethnicity) # check if it came out correctly 

#checking which has the highest abusement
tab(child, phyabuse)#Yes:  12.12  NA: 4.76
tab(child, sexabuse) #Yes:  3.82  NA: 4.76
tab(child, neglect) #Yes:  62.42  NA: 4.76 ######
tab(child, aaparent)#low Yes:  5.27  NA: 4.76
tab(child, daparent)#high Yes:  33.99  NA: 4.76 ####
tab(child, aachild) #low Yes:  0.33  NA: 5.19
tab(child, dachild) #low Yes: 1.96 NA: 4.76 

#creating new variable for all abuse
child <- child %>%
  mutate (removal_abuse = 
            case_when(phyabuse == 'Yes' ~ 'Physical Abuse', #Removal Reason-Physical Abuse
              sexabuse == 'Yes' ~ 'Sexual Abuse',
              neglect  == 'Yes' ~ 'Neglect',
              aaparent == 'Yes' ~ 'AA Parent',
              daparent == 'Yes'~ 'DA Parent',
              aachild == '1' ~ 'AA Child',
              dachild == "Yes" ~ 'DA Child')) 

# Drop incomplete values in abuse 
child = child[!child$removal_abuse=="",]
child = child[complete.cases(child$removal_abuse),]

print(child$removal_abuse)
#omitted 470435 entries  were NA's

# Generate wait time variable
child$wait_time <- as.Date(as.character(child$cursetdt), format="%Y-%m-%d") - 
as.Date(as.character(child$latremdt), format="%Y-%m-%d")
child$wait_time <- as.numeric(child$wait_time)

###REGRESSION
#set child age as a numeric variable
child$ageatstart <- as.numeric(child$ageatstart)
# Some children are scheduled for foster care even before they are born.
# In this case, wait time will be negative value, so we need to clean it
child = child[!child$wait_time <0,]
# Some children run away. In this case, wait time will be 0. 
# We need to drop those cases.
tab(child, curplset) # There are 9963 children who are missing or ran away
child = child[!child$curplset=="Missing",]
child = child[!child$curplset=="Runaway",]
child = child[!child$curplset == "NA",]

# Drop incomplete NA values in race / abuse
child = child[!child$race_ethnicity=="",]
child = child[!child$neglect=="",]

# Drop incomplete values in sex
child = child[!child$sex=="",]

# Run regression model
regression_model <- lm(wait_time ~ race_ethnicity + sex, data=child)
print(summary(regression_model))


###################BARPLOT
#library(RColorBrewer)
#ageatstart, st, totalrem

  child_2 <- child %>%
  group_by(sex, wait_time, curplset, race_ethnicity, ageatstart, ageadopt, removal_abuse) %>%
  summarize(rem1dt = length(2019))
str_sub(child_2$rem1dt, 1,4) = '2019'

ggplot(data = child_2) +
  geom_bar(mapping = aes(x = curplset, fill = race_ethnicity)) + 
  scale_fill_brewer(palette="Pastel1") +
  labs(x = "Placement Setting",
       y = "Wait Time", 
       title = "Figure 1: Current Placement Setting", fill = "Race/Ethnicity",
       subtitle = "Wait Time By Race/Enthicity and Sex") +
  theme(strip.text.y = element_text(
    size = 15, face = "times.new.roman"
  )) +
theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust=1)) +
  theme(plot.title = element_text(face="bold", size=14
  )) +  theme(plot.subtitle = element_text(face="bold", size=14))

ggsave(filename = "figure1_curplset_race_sex.png", width = 6, height = 4)


##############
#summary of stats
#remember to remove children who went missing and runaway
#child_2 = child_2[!child_2$wait_time <0,]

#ggplot(data = child_2) +
 # stat_summary(
    mapping = aes(x = race_ethnicity, y = wait_time),
    fun.min = min,
    fun.max = max,
    fun = median,
    cex=0.5
  #) + theme(axis.text.x = element_text(angle = 45, hjust=1)) +
  #labs(x = "Race",
 # y = "Wait Time",
#title = "Figure 2: Statistics Summary of",
#subtitle = "Wait Time By Race, 2019",
#xlab= "Variable Lable", ylab="density",) +
 # theme(plot.title = element_text(face="bold", size=18,
 #                 )) +
 # theme(plot.subtitle = element_text(face="bold", size=18,))

#ggsave(filename = "figure2_statsum.png", width = 6, height = 4)

#####HISTOGRAM###
library(RColorBrewer)
#removing Nas
#child_2 = child_2[!child_2$removal_abuse=="",]
child_2 = child_2[complete.cases(child_2$removal_abuse),]
#removing sex na's
child_2 = child_2[!child_2$sex=="",]
child_2 = child_2[complete.cases(child_2$sex),]


ggplot(data = child_2, mapping = aes(x= removal_abuse , fill = sex)) + 
  geom_bar(position = "dodge") + 
  scale_fill_brewer(palette = "Pastel1") +
  labs(x = "Type of Abuse",
       y = "Count",
       legend = "Sex",
       title = "Figure 2: Type of Abusement Removal",
       subtitle = "by Sex, 2019") +
theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust=1)) +
  theme(plot.title = element_text(face="bold", size=14
  )) +  theme(plot.subtitle = element_text(face="bold", size=14))

ggsave(filename = "figure3_type_of_abusement.png", width = 6, height = 4)


#####MOSAIC PLOT################

install.packages("ggmosaic")
library(ggmosaic)
library(ggplot2)

#child$Waited_Over_Year <- ifelse(child$wait_time > 365, c("yes"), c("no"))

mosaic_examp <- ggplot(data = child_2) +
  geom_mosaic(aes(x = product(sex, ageadopt), fill =neglect)) +   
    labs (y="Race", x="Sexual Abuse", title = "Figure 4: Mosaic Plot of",
          subtitle = "Race and Sexual Abuse") +  
theme(plot.title = element_text(face="bold", size=18,)) + 
  theme(plot.subtitle = element_text(face="bold", size=18,))
mosaic_examp 

ggsave(filename = "figure4_mosaic.png", width = 6, height = 4)







## Read in Grad School Admit Data ##


#gs <- readr::read_csv("binary.csv")

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