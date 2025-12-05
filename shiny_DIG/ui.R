library(tidyverse)
library(janitor) 
library(ggplot2)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(plotly)
library(bslib)
library(ggExtra)

# read the DIG data set (using select for the needed data set)
dig.df <- read.csv("DIG.csv") %>%
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
         hospdays, death)


# Select numeric columns for variable selection dropdowns
dig_n.df <- dig.df %>% select(where(is.numeric))
num_vars <- names(dig_n.df)

# Relation tab reactive filtering
dig_filtered <- reactive({
  dig.df %>%
    filter(
      trtmt    %in% input$trtmt_f,
      sex      %in% input$sex_f,
      hyperten %in% input$hyperten_f,
      cvd      %in% input$cvd_f,
      whf      %in% input$whf_f,
      dig      %in% input$dig_f,
      hosp     %in% input$hosp_f,
      death    %in% input$death_f
    )
})

#View(dig_n.df)
ui <- dashboardPage(skin = "purple",
                    dashboardHeader(
                      title = tags$span("DIG Trial Dashboard",
                                        style = "color: forrestgreen; font-size: 20px; font-weight:bold;")),# for font size and color for the dashboard
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("About the dataset", tabName = "info"),
                        menuItem("Overview", tabName = "over"),
                        menuItem("Analysis of the Data", tabName = "relation"))),
                    
                    dashboardBody(
                      # CSS(cascading style sheet) to style the sidebar menu item
                      tags$head(
                        # to customize the menu item(information, overview, relation) for text color and font size
                        tags$style(HTML("
                        .sidebar-menu li a[data-value='info'] {color: white;font-size: 18px;font-weight: bold;}
                        .sidebar-menu li a[data-value='over'] {color: white;font-size: 18px;font-weight: bold;}
                        .sidebar-menu li a[data-value='relation'] {color: white;font-size: 18px;font-weight: bold;}
                        .tab-content h2 {color: darkmagenta;font-size: 28px;font-weight: bold;}
                        .tab-content h3 {color: indigo;font-size: 25px;}
                        .tab-content h4 {color: indigo;font-size: 22px;}")
                        )),
                      
                      #for the main page 
                      tabItems(
                        tabItem(tabName = "info",
                                fluidRow(box(
                                  h2("About the Trial"),
                                  uiOutput("info_para")),
                                  box(
                                    h3("Legends of the dataset"),
                                    dataTableOutput("legends")),
                                  box(
                                    h3("Dataset"),
                                    style = "height:400px; overflow-y: scroll; overflow-x: scroll;",
                                    dataTableOutput("digds"),
                                    width = 12))),
                        
                        #for overview 
                        tabItem(tabName = "over",
                                fluidRow(box(
                                  h2("Overview of the dataset"),
                                  uiOutput("over_ds"),
                                  width =12),
                                  box(h3("Parallel Coordinate Graph the of Baseline characteristics"),
                                      plotlyOutput("overviewPlot"),
                                      width = 12))),
                        
                        # for analysis tab 
                        tabItem(tabName = "relation",
                                h2("Multiple Variable Analysis"),
                                fluidPage(
                                  box(
                                    h4("Continous variables"),
                                    width = 4,
                                    varSelectInput("xvar","X variable:", dig_n.df[, c("age","bmi","klevel","creat","diabp","sysbp")], selected = "age"),
                                    uiOutput("x_range_slider"),
                                    varSelectInput("yvar","Y variable:", dig_n.df[, c("age","bmi","klevel","creat","diabp","sysbp")], selected = "bmi"),
                                    uiOutput("y_range_slider"),
                                    
                                    #check box  Treatment, Sex, Hypertension, CVD, Worsening HF, Digoxin toxicity, Any hospitalization, Death
                                    h4("Discrete variables"),
                                    fluidRow(
                                      column(
                                        width = 6,
                                        checkboxGroupInput("trtmt_f","Treatment", choices = levels(dig.df$trtmt), selected = levels(dig.df$trtmt)),
                                        checkboxGroupInput("sex_f","Sex", choices = levels(dig.df$sex), selected = levels(dig.df$sex)),
                                        checkboxGroupInput("hyperten_f","Hypertension", choices = levels(dig.df$hyperten), selected = levels(dig.df$hyperten)),
                                        checkboxGroupInput("cvd_f","CVD", choices = levels(dig.df$cvd), selected = levels(dig.df$cvd))),
                                      column(
                                        width = 6,
                                        checkboxGroupInput("whf_f","Worsening HF", choices = levels(dig.df$whf), selected = levels(dig.df$whf)),
                                        checkboxGroupInput("dig_f","Digoxin toxicity", choices = levels(dig.df$dig), selected = levels(dig.df$dig)),
                                        checkboxGroupInput("hosp_f","Any hospitalization", choices = levels(dig.df$hosp), selected = levels(dig.df$hosp)),
                                        checkboxGroupInput("death_f","Death", choices = levels(dig.df$death), selected = levels(dig.df$death))
                                      )),
                                    
                                    #other parameters that include for addition of histogram or density graph on the margin          
                                    hr(),
                                    h4("Other Parameters"),
                                    checkboxInput("show_margins", "Show marginal plots", T),
                                    radioButtons(
                                      "margin_type", "Marginal plot type",
                                      choices = c("Histogram" = "histogram", "Density" = "density"),
                                      selected = "histogram",
                                      inline = T
                                    ),
                                    checkboxInput("add_smoother", "Add smoother", F)
                                  ),
                                  box(
                                    width = 8,
                                    h4("How to make the graph:"),
                                    uiOutput("usergraph")),
                                  
                                  # rendering scatter plot  
                                  box(
                                    width = 8,
                                    plotOutput("relation_plot"))
                                )
                        )
                      )
                    )
)