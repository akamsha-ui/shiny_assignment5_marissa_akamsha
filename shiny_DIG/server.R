library(tidyverse)
library(janitor) 
library(ggplot2)
library(shiny)
library(shinydashboard)

dig.df <- read.csv("DIG.csv")
#View(dig.df)
dig.df <- dig.df %>%
  janitor::clean_names() %>%
  mutate(
    trtmt = factor(trtmt, levels = c(0,1), labels = c("Placebo", "Treatment")),
    sex = factor(sex, levels = c(1,2), labels = c("Males", "Females")),
    hyperten = factor(hyperten, levels = c(0,1), labels = c("No","Yes")),
    cvd = factor(cvd, levels = c(0,1), labels = c("No","Yes")),
    whf = factor(whf, levels = c(0,1), labels = c("No","Yes")),
    dig = factor(dig, levels = c(0,1), labels = c("No","Yes")),
    hosp = factor(hosp, levels = c(0,1), labels = c("No","Yes")),
    death = factor(death, levels = c(0,1), labels = c("Alive","Death"))
  ) %>%
  select(id, trtmt, age, sex, bmi, klevel, creat, diabp, sysbp, hyperten, cvd, whf, dig, hosp, hospdays, death, deathday)

setwd("C:/Users/Marissa/Documents/1. College/1. Masters/3. HDS5105 - Statistical Computing for 
      Biomedical Data/6. Rstudio/shiny_assignment5_marissa_akamsha/shiny_DIG")
dig_df <- read.csv("DIG.csv")
digData <- dig_df %>%
  janitor::clean_names() %>% 
  select(id, trtmt, age, sex, bmi, klevel, creat, diabp, sysbp, hyperten, cvd, whf, dig, hosp, 
         hospdays, death, deathday)


para1 = ("The DIG (Digitalis Investigation Group) Trial was a randomized, double-blind, multicenter trial with more than 300 centers in the United States and Canada participating. The purpose of the trial was to examine the safety and efficacy of Digoxin in treating patients with congestive heart failure in sinus rhythm. Digitalis was introduced clinically more than 200 years ago and has since become a commonly prescribed medication for the treatment of heart failure; however, there was considerable uncertainty surrounding its safety and efficacy. Small trials indicated that Digoxin alleviated some of the symptoms of heart failure, prolonged exercise tolerance, and generally improved the quality of patients' lives. Unfortunately, these trials were generally small and although they did focus on the effect of treatment on patients’ relief from heart failure symptoms and quality of life, they failed to address the effect of treatment on cardiovascular outcomes. Questions about the safety of Digoxin were also a concern. Digoxin toxicity is uncommon in small trials with careful surveillance, however, the long-term effects of therapeutic levels of Digoxin were less clear.")
para2 = ("The DIG dataset consists of baseline and outcome data from the main DIG trial. In the main trial, heart failure patients meeting the eligibility criterion and whose ejection fraction was 45% or less were randomized to receive either a placebo or digoxin. Outcomes assessed in the trial included: cardiovascular mortality, hospitalization or death from worsening heart failure, hospitalization due to other cardiovascular causes and hospitalization due to non-cardiovascular causes.")
para3 = ("It was obtained for the purpose of this assignment and is enclosed with this assignment. The codebook associated with the variables is also enclosed with your assignment.")
para4 = ("In order to create an anonymous dataset that protects patient confidentiality, most variables have been permuted over the set of patients within treatment group. Therefore, it would be inappropriate to use this dataset for other research or publication purposes.")
rev = paste(para1, para2, para3, para4, sep = "<p>")
rev

# Define server logic required to draw a histogram
function(input, output, session) {
  output$info_para <- renderText({
    HTML("<p>The DIG (Digitalis Investigation Group) Trial was a randomized, double-blind, 
         multicenter trial with more than 300 centers in the United States and Canada participating. 
         The purpose of the trial was to examine the safety and efficacy of Digoxin in treating patients 
         with congestive heart failure in sinus rhythm. Digitalis was introduced clinically more than 200 
         years ago and has since become a commonly prescribed medication for the treatment of heart failure; 
         however, there was considerable uncertainty surrounding its safety and efficacy. Small trials 
         indicated that Digoxin alleviated some of the symptoms of heart failure, prolonged exercise 
         tolerance, and generally improved the quality of patients' lives. Unfortunately, these trials were
         generally small and although they did focus on the effect of treatment on patients’ relief from 
         heart failure symptoms and quality of life, they failed to address the effect of treatment on 
         cardiovascular outcomes. Questions about the safety of Digoxin were also a concern. Digoxin 
         toxicity is uncommon in small trials with careful surveillance, however, the long-term effects 
         of therapeutic levels of Digoxin were less clear.<p>
         <p>The DIG dataset consists of baseline and outcome data from the main DIG trial. In the 
         main trial, heart failure patients meeting the eligibility criterion and whose ejection 
         fraction was 45% or less were randomized to receive either a placebo or digoxin. Outcomes 
         assessed in the trial included: cardiovascular mortality, hospitalization or death from 
         worsening heart failure, hospitalization due to other cardiovascular causes and 
         hospitalization due to non-cardiovascular causes.<p>
         <p>It was obtained for the purpose of this assignment and is enclosed with this assignment. 
         The codebook associated with the variables is also enclosed with your assignment.<p>
         <p>In order to create an anonymous dataset that protects patient confidentiality, most 
         variables have been permuted over the set of patients within treatment group. 
         Therefore, it would be inappropriate to use this dataset for other research or 
         publication purposes.<p>")
  })
  }

