library(tidyverse)
library(janitor) 
library(ggplot2)
library(shiny)
library(shinydashboard)

# read the DIG data set (using select for the needed data set)
dig_new.df <- dig_df %>%
  janitor::clean_names() %>% 
  mutate(
    trtmt = factor(trtmt, levels = c(0,1), labels = c("Placebo", "Treatment")),
    sex = factor(sex, levels = c(1,2), labels = c("Males", "Females")),
    hyperten = factor(hyperten, levels = c(0,1), labels = c("No","Yes")),
    cvd = factor(cvd, levels = c(0,1), labels = c("No","Yes")),
    whf = factor(whf, levels = c(0,1), labels = c("No","Yes")),
    dig = factor(dig, levels = c(0,1), labels = c("No","Yes")),
    hosp = factor(hosp, levels = c(0,1), labels = c("No","Yes")),
    death = factor(death, levels = c(0,1), labels = c("Alive","Death"))) %>%
  select(id, trtmt, age, sex, bmi, klevel, creat, diabp, sysbp, hyperten, cvd, whf, dig, hosp, 
         hospdays, death, deathday)
<<<<<<< HEAD
View(dig_df)
View(digData)
=======

>>>>>>> 2c0e7c78d963f39da5bf91a33922d6739047845f

#UI page layout
ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "DIG Trial Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About the dataset", tabName = "info"),
      menuItem("Overview", tabName = "over"),
      menuItem("Analysis for two variables", tabName = "relation"),
      menuItem("Summary Tables", tabName = "tables")
    )
  ),
 # for the dashboard layout
 dashboardBody(
   tabItems(
     tabItem(tabName = "info",
             h2("DIG Trial Dashboard"),
             verbatimTextOutput("info_para"),
             h3("Dataset"),
             div(style = "height:400px; overflow-y: scroll; overflow-x: scroll;", tableOutput("digds"))),
     tabItem(tabName = "over"),
     tabItem(tabName = "relation"),
     tabItem(tabName = "tables")
   )
 )
)






