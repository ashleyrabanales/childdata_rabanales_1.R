# Dive In The Foster Care System

- __Project Purpose:__ I used data from the National Data Archive on Child Abuse and Neglect (NDACAN) 2019, which includes all children in foster care in 2019. The NDACAN data have been provided by the National Data Archive on Child Abuse and Neglect, which is housed at Cornell University and overseen by Children Bureau. The data have been de-identified prior to being made available to researchers in the publicly available version of the data, which are the data we used for all analyses. The NDACAN data contains case-level information on all children in foster care for whom State and Tribal title IV-E agencies have responsibility for placement, care or supervision, and on children who are adopted under the auspices of the State and Tribal title IV-E agency'. Title IV-E agencies are required to submit NDACAN data semi-annually to the Children Bureau. 

- __The Goal__: of using this data is to find if there are association between the a few of the selected categories variables in analyzing, performing, and creating visualization to explain differences, similarities, and discovering new information for NDACAN.

- __Tools used:__ I am using R in VS Code to create my grpahs and visualizations. 
Sources I used to help to finished the project
https://www.statology.org/conditional-mutating-r/

    https://www.datanovia.com/en/blog/ggplot-legend-title-position-and-labels/

    https://ncss-wpengine.netdna-ssl.com/wp-content/themes/ncss/pdf/Procedures/NCSS/Mosaic_Plots.pdf

  
![](documents/regression.png)

- __Results:__
  
The results indicate substantial similarities between the type of abuse, current placement settings, and gender. Most children experience longer waiting times in foster family homes, whether non-relative, relative, or pre-adoptive. Females face a higher likelihood of sexual abuse compared to males, while neglect rates are the highest in both genders.

The latest findings from NDACAN reveal that the majority of children in the foster care system are of white or Black/African American ethnicity, with fewer being Asian or American Indian/Alaskan Native. This demographic variation is significant in understanding where children subjected to abuse end up and how it reflects the foster care system's dynamics.

These findings underscore the need for further exploration, urging others to conduct additional evaluations of the newly introduced variables and codes. Investigating potential associations between these variables and race/ethnicity can offer a more nuanced understanding of the complex interplay between demographic factors and types of abuse.

Statistical analyses, such as regression, were employed to assess significance, using an alpha of 0.05. The results indicate significance in variables encompassing race/ethnicity, sex, neglect, physical abuse, and sexual abuse, as evidenced by p-values below the alpha threshold and weak positive r-squares. However, caution is advised due to multicollinearity issues, as there is insufficient information to draw conclusive results.

To address this, further steps may involve creating new variables or removing existing ones to enhance the correlation representation. The aim is to refine the analysis and gain a clearer understanding of the intricate relationships within the data.
    
![](documents/figure1_curplset_race_sex.png)

- In Figure 1,

I constructed a stacked bar chart illustrating the current placement setting in relation to the race and ethnicity of children from 2019. This involved introducing a waiting time variable to calculate the wait time per day. The chart reveals that a majority of white and Black/African American children have the highest counts in each placement setting, indicating a larger representation of children from these races in the foster care system.

Missing and runaway children are more frequently identified as Black/African American and White, with a smaller proportion being Hispanic or American Indian/Alaskan Native. Group homes may be designated for children with disabilities or mental disorders requiring 24-hour care, and this pattern is evident in the data.

Notably, trail home visits, foster homes (both non-relative and relative), exhibit a tendency for longer wait times, emphasizing the challenges faced by children placed in these settings.
     
- The variable current placement setting is cateegorize by: 

    __Foster family home, non-relative__: A licensed foster family home regarded by the State as a foster care living arrangement.

    __Foster family home, relative__: A licensed or unlicensed home of the child's relatives regarded by the State as a foster care living arrangement for the child, even if there is no payment.
     Foster family home, non-relative: A licensed foster family home regarded by the State as a foster care living arrangement. 
     
    __Group home__: A licensed or approved home providing 24-hour care for children in a small group setting that generally has from seven to twelve children.
     
    __Institution__: A child care facility operated by a public or private agency and providing 24-hour care and/or treatment for children who require separation from their own homes and group living experience. These facilities may include: child care institutions; residential treatment facilities; maternity homes; etc. An institution is larger than a group home, caring for more than 12 children.

    __Missing__: A child who went missing from the foster care setting.
     
    __Pre-adoptive home__: A home in which the family intends to adopt the child. The family may or may not be receiving a foster care payment or an adoption subsidy on behalf of the child. 

    __Runaway__: The child has run away from the foster care setting. 

    __Supervised independent living__: An alternative traditional living arrangement where the child is under the supervision of the agency but without 24-hour adult supervision, is receiving financial support from the child welfare agency, and is in a setting which provides the opportunity for increased responsibility for self-care. 

    __Trial home visit__: The child has been in a foster care placement but, under State agency supervision, has been returned to the principal caretaker for a limited and specified period of time.





![](documents/figure3_type_of_abusement.png)

-  As in Figure 2,

it presents a side-by-side bar chart illustrating the types of abuse leading to removal categorized by sex. The data indicates that males are more prone to experiencing various forms of abuse, ranging from AA Child to Physical Abuse. However, in the case of Sexual Abuse, females exhibit a higher count, signifying that females are twice as likely to be victims of sexual abuse compared to males.

Approximately 90,000 females and 98,000 males were identified as likely to undergo removal due to negligent treatment or maltreatment, encompassing issues like domestic violence, mental, and emotional abuse. The removal rate for DA Parents surpasses that of Alcohol Abuse, demonstrating that instances involving DA Parents result in triple the number of removals compared to those involving Alcohol Abuse. Physical Abuse emerges as the second leading cause of removal for both genders.


- Each variables of Abusement is explain as a condition associated with a child's removal from home and contact with the foster care system -  
    __AAChild__: Alcohol Abuse, he child's compulsive use of or need for alcohol. This element should include infants addicted at birth. include children exposed in utero to alcohol.

    __AA Parent__: Alcohol Abuse, the principal caretaker's compulsive use of alcohol that is not of a temporary nature.

    __DA Child__: Drug Abuse, the child's use of drugs that is not of a temporary nature. Includes infants exposed to drugs during pregnancy. Not limited to narcotics

    __DA Parent__: Drug Abuse, the principal caretaker's compulsive use of drugs that is not of a temporary nature.

    __Neglect__: lleged or substantiated negligent treatment or maltreatment, including failure to provide adequate food, clothing, shelter or care. Such as domestic violence and mental emotional abuse is mapped in the varaiable

    __Physical Abuse__: alleged or substantiated physical abuse, injury or maltreatment of the child by a person responsible for the child's welfare.

    __Sexual Abuse__: alleged or substantiated sexual abuse or exploitation of a child by a person who is responsible for the child's welfare.

![](documents/figure4_mosaic.png)


- Illustrated in Figure 3 is a mosaic plot designed for categorical variables, specifically depicting the relationship between the Removal of Abuse and Placement Setting. It's evident from the plot that Neglect and Physical Abuse have the broadest proportional width in current placements, while AA Child and DA Child exhibit the narrowest widths. Foster homes, both relative and non-relative, emerge as the more common current placement for children removed due to abuse. In contrast, institutional and supervised independent living settings are the least likely destinations for children experiencing abuse and subsequently being placed in the foster care system.






## Folder structure

```
- readme.md
- scripts
---- readme.md 
---- child.r
- data 
---- childdata.csv (privacy)
- documents
---- figure1_curplset_race_sex.png
---- figure3_type_of_abusement.png
---- figure4_mosaic.png
---- regression.png
```
