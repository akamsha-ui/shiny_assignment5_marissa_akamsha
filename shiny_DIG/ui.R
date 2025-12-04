library(tidyverse)
library(janitor) 
library(ggplot2)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(plotly)

# read the DIG data set (using select for the needed data set)
dig.df <- read.csv("DIG.csv")
dig_new.df <- dig.df %>%
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


#UI page layout

dig_n.df <- dig_new.df %>% select(where(is.numeric))

#View(dig_n.df)
ui <- dashboardPage(skin = "green",
                    dashboardHeader(
                      title = tags$span("DIG Trial Dashboard",
                                        style = "color: white; font-size: 20px; font-weight:bold;")  
                      ),
                    
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("About the dataset", tabName = "info"),
                        menuItem("Overview", tabName = "over"),
                        menuItem("Analysis for two variables", tabName = "relation"))),
                    
                    dashboardBody(
                      skin = "red",
                      # CSS to style the sidebar menu item
                      tags$head(
                        tags$style(HTML("/*Style 'About the dataset' menuItem*/
        .sidebar-menu li a[data-value='info'] {
          color: white !important;       /*text color*/
          font-size: 18px !important;      /*font size */
          font-weight: bold !important;    /*bold*/
        }
      
      /*Style 'Overview' menuItem*/
        .sidebar-menu li a[data-value='over'] {
          color: white !important;       /*text color*/
          font-size: 18px !important;      /*font size*/
          font-weight: bold !important;    /*bold*/
        }
      /*Style 'Analysis for two variables' menuItem*/
        .sidebar-menu li a[data-value='relation'] {
          color: white !important;       /*text color*/
          font-size: 18px !important;      /*font size*/
          font-weight: bold !important;    /*bold*/
        }
       "))
        ),
        #for the tab
        tabItems(
          tabItem(tabName = "info",
                  h2("About the Trial"),
                  uiOutput("info_para"),
                  h3("Legends of the dataset"),
                  dataTableOutput("legends"),
                  h3("Dataset"),
                  dataTableOutput("digds")),
         
          #for overview 
          tabItem(tabName = "over",
                  h2("Overview of the dataset"),
                  uiOutput("over_ds"),
                  h3("Parallel Coordinate Graph the of Baseline characteristics"),
                  plotlyOutput("overviewPlot")),
         
          # for analysis 
           tabItem(tabName = "relation",
                  h2("Two Variable Analysis"),
                  varSelectInput("xvar","X axis variable:", dig_n.df),
                  varSelectInput("yvar","Y axis variable:", dig_n.df),
                  )
         
    )
  )
)
