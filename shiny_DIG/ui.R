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
library(shinydashboard)


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
#dashboardHeader(title = "Digoxin Toxicity Trial Analysis")
dashboardPage(skin = "purple",
  dashboardHeader(title = "Digoxin Toxicity Trial Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About the dataset", tabName = "about", icon = icon("dashboard")),
      menuItem("Analysis", tabName = "analysis", icon = icon("th"))
    )),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              fluidRow(
                box(plotOutput("plot1", height = 250)),
                box(title = "Controls",
                    sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    )
  )
  
)



