#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
library(tidyverse)
library(janitor) 
library(ggplot2)
library(bslib)
library(shiny)

dig.df <- read.csv("DIG.csv")
dig.df <- dig.df %>%
  janitor::clean_names() %>%
  # mutate(
  #   trtmt = factor(trtmt, levels = c(0,1), labels = c("Placebo", "Treatment")), 
  #   sex = factor(sex, levels = c(1,2), labels = c("Males", "Females")),
  #   #hyperten = factor(hyperten, levels = c(0,1)), 
  #   hyperten = factor(hyperten, levels = c(0,1), labels = c("No","Yes")),
  #   cvd = factor(cvd, levels = c(0,1), labels = c("No","Yes")),
  #   whf = factor(whf, levels = c(0,1), labels = c("No","Yes")), 
  #   dig = factor(dig, levels = c(0,1), labels = c("No","Yes")), 
  #   hosp = factor(hosp, levels = c(0,1), labels = c("No","Yes")), 
  #   death = factor(death, levels = c(0,1), labels = c("Alive","Death"))
  # ) %>%
  select(id, trtmt, age, sex, bmi, klevel, creat, diabp, sysbp, hyperten, cvd, whf, dig, hosp, hospdays, death, deathday)

# Define UI for application that draws a histogram
page_sidebar(
  title = "Digoxin toxicity trial data analysis",
  sidebar = sidebar("About"),
  "main contents"
)


