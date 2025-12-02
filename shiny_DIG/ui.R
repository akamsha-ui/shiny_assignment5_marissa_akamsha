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
library(shiny)
library(shinydashboard)
# read the DIG data set (using select for the needed data set)
#setwd("C:/Users/ak/Documents/my_git_hub_assignment/final_a5/shiny_assignment5_marissa_akamsha/shiny_DIG")
dig_df <- read.csv("DIG.csv")
digData <- dig_df %>%
  janitor::clean_names() %>% 
  select(id, trtmt, age, sex, bmi, klevel, creat, diabp, sysbp, 
         hyperten, cvd, whf, dig, hosp, hospdays, death, deathday)
#View(dig_df)
#View(digData)
#UI page layout
ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "DIG Trial Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("info", tabName = "About the data set"),
      menuItem("over", tabName = "Overview"),
      menuItem("Analysis for two variables", tabName = "relationships"),
      menuItem("Summary Tables", tabName = "tables")
    )
  ),
 # for the dashboard layout
   dashboardBody(
    tabItems(
      tabItem(tabName = "info",
              h2("DIG Trial Dashboard"),
              p("Explore key aspects and relationships in the DIG Trial dataset.")
      ),
    )
)
)





