library(tidyverse)
library(janitor) 
library(ggplot2)
library(shiny)
library(shinydashboard)

# read the DIG data set (using select for the needed data set)
dig_df <- read.csv("DIG.csv")
digData <- dig_df %>%
  janitor::clean_names() %>% 
  select(id, trtmt, age, sex, bmi, klevel, creat, diabp, sysbp, hyperten, cvd, whf, dig, hosp, 
         hospdays, death, deathday)
View(dig_df)
View(digData)

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
     tabItem(tabName = "over"),
     tabItem(tabName = "relation"),
     tabItem(tabName = "tables")
   )
 )
)
)





