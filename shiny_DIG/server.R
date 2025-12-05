library(tidyverse)
library(janitor) 
library(ggplot2)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(plotly)
library(bslib)
library(ggExtra)

# para1 = ("The DIG (Digitalis Investigation Group) Trial was a randomized, double-blind, multicenter trial with more than 300 centers in the United States and Canada participating. The purpose of the trial was to examine the safety and efficacy of Digoxin in treating patients with congestive heart failure in sinus rhythm. Digitalis was introduced clinically more than 200 years ago and has since become a commonly prescribed medication for the treatment of heart failure; however, there was considerable uncertainty surrounding its safety and efficacy. Small trials indicated that Digoxin alleviated some of the symptoms of heart failure, prolonged exercise tolerance, and generally improved the quality of patients' lives. Unfortunately, these trials were generally small and although they did focus on the effect of treatment on patients’ relief from heart failure symptoms and quality of life, they failed to address the effect of treatment on cardiovascular outcomes. Questions about the safety of Digoxin were also a concern. Digoxin toxicity is uncommon in small trials with careful surveillance, however, the long-term effects of therapeutic levels of Digoxin were less clear.")
# para2 = ("The DIG dataset consists of baseline and outcome data from the main DIG trial. In the main trial, heart failure patients meeting the eligibility criterion and whose ejection fraction was 45% or less were randomized to receive either a placebo or digoxin. Outcomes assessed in the trial included: cardiovascular mortality, hospitalization or death from worsening heart failure, hospitalization due to other cardiovascular causes and hospitalization due to non-cardiovascular causes.")
# para3 = ("It was obtained for the purpose of this assignment and is enclosed with this assignment. The codebook associated with the variables is also enclosed with your assignment.")
# para4 = ("In order to create an anonymous dataset that protects patient confidentiality, most variables have been permuted over the set of patients within treatment group. Therefore, it would be inappropriate to use this dataset for other research or publication purposes.")
# rev = paste(para1, para2, para3, para4, sep = "<p>")
# rev

#server code
function(input, output, session) {
  
  ##About the dataset page
  output$info_para <- renderUI({
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
         hospitalization due to non-cardiovascular causes.<p>")})
  
  # creating the legends table for the DIG data set
  Variable <- c("id", "trtmt", "age", "sex", "bmi", "klevel", "creat", "diabp", "sysbp", "hyperten", 
                "cvd", "whf", "dig", "hosp", "hospdays", "death", "deathday")
  Type <- c("num", "fac", "num", "fac", "num", "num", "num", "num", "num", 
            "fac", "fac", "fac", "fac", "fac", "num", "fac", "num")
  Label <- c("Patient ID", "Treatment type",  "Calculated: age at randomization", "Sex of patient", "Body Mass Index of patient",
             "Serum Potassium level", "Serum Creatinine (mg/dL)", "Diastolic BP (mmHg)", 
             "Sysolic BP (mmHg)", "History of Hypertension", "Hospitalization due to Cardiovascular Disease",
             "Hospitalization due to Worsening Heart Failure", "Hospitalization due to Digoxin Toxicity", 
             "Any Hospitalization", "Days randomization to First Any Hosp",
             "Vital Status of Patient", "Days till last followup or death")
  legends.df <- data.frame(Variable, Type, Label)
  output$legends <- renderDataTable({legends.df}) #rendering
  
  # read the DIG data set (using select for the needed data set)
  dig.df <-read.csv("DIG.csv") %>%
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
    select(id, trtmt, age, sex, bmi, klevel, creat, diabp, sysbp, hyperten, 
           cvd, whf, dig, hosp, hospdays, death, deathday)
  
  output$digds <- renderDataTable({dig.df}) #rendering
  
  ##overview page
  output$over_ds <- renderText({
    HTML("<p>The parallel coordinate plot below visualizes the baseline characteristics for all continuous variables in the dataset, with the placebo group shown in orange and the treatment group shown in cyan. 
    The two treatment groups are Placebo group (as orange lines) and Treatment group (as cyan lines). <p>
         <p>An outlier value of 434 in the Serum Potassium (KLEVEL) variable, likely due to a data entry error, was removed to improve clarity.<p>
         <p>This plot allows us to compare multivariate patterns between the two groups across several baseline variables, including age, sex, body mass index, serum potassium, serum creatinine, diastolic blood pressure, and systolic blood pressure, and helps reveal differences, similarities, and potential trends among the treatment groups.<p>")})
  p.df <- read.csv("DIG.csv") %>%
    janitor::clean_names() %>% 
    select(trtmt, sex, age, bmi, klevel, creat, diabp, sysbp, hyperten, cvd, whf, dig, hosp, death) %>%
    na.omit() 
  p.df <- p.df%>%
    filter(row_number() != 833)
  p <- plot_ly(
    type = "parcoords",
    line = list(
      color     = p.df$trtmt,
      colorscale = list(c(0, "#ff7f00"), c(1, "#12C0DE")),
      showscale = TRUE, alpha = 0.2),
    dimensions = list(
      list(tickvals = c(0, 1), ticktext = c("Placebo", "Treatment"), label    = "Treatment", values   = p.df$trtmt),
      list(range  = c(min(p.df$age,   na.rm = TRUE), max(p.df$age,   na.rm = TRUE)), label  = "Age", values = p.df$age),
      list(range  = c(min(p.df$bmi,   na.rm = TRUE), max(p.df$bmi,   na.rm = TRUE)), label  = "BMI", values = p.df$bmi),
      list(range  = c(min(p.df$klevel, na.rm = TRUE), max(p.df$klevel, na.rm = TRUE)), label  = "Serum Potassium Level", values = p.df$klevel),
      list(range  = c(min(p.df$creat, na.rm = TRUE), max(p.df$creat, na.rm = TRUE)), label  = "Serum Creatinine Level", values = p.df$creat),
      list(range  = c(min(p.df$diabp, na.rm = TRUE), max(p.df$diabp, na.rm = TRUE)), label  = "Diastolic BP", values = p.df$diabp),
      list(range  = c(min(p.df$sysbp, na.rm = TRUE), max(p.df$sysbp, na.rm = TRUE)), label  = "Systolic BP", values = p.df$sysbp),
      list(tickvals = c(1, 2), ticktext = c("Male", "Female"), label    = "Sex", values   = p.df$sex)))
  output$overviewPlot <- renderPlotly({ggplotly(p)}) #rendering
  
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

  output$x_range_slider <- renderUI({
    req(input$xvar)
    x_data <- dig_filtered()[[input$xvar]]
    sliderInput("x_range", paste("Range of ", input$xvar, ":"), 
                min = round(min(x_data, na.rm = TRUE), 1),
                max = round(max(x_data, na.rm = TRUE), 1),
                value = c(min(x_data, na.rm = TRUE), max(x_data, na.rm = TRUE)),
                step = (max(x_data, na.rm = TRUE) - min(x_data, na.rm = TRUE)) / 100)
  })
  
  output$y_range_slider <- renderUI({
    req(input$yvar)
    y_data <- dig_filtered()[[input$yvar]]
    sliderInput("y_range", paste("Range of ", input$yvar, ":"), 
                min = round(min(y_data, na.rm = TRUE), 1),
                max = round(max(y_data, na.rm = TRUE), 1),
                value = c(min(y_data, na.rm = TRUE), max(y_data, na.rm = TRUE)),
                step = (max(y_data, na.rm = TRUE) - min(y_data, na.rm = TRUE)) / 100)
  })
  
  dig_filtered_range <- reactive({
    df <- dig_filtered()
    
    if (!is.null(input$x_range)) {
      df <- df %>% filter(between(!!sym(input$xvar), input$x_range[1], input$x_range[2]))
    }
    if (!is.null(input$y_range)) {
      df <- df %>% filter(between(!!sym(input$yvar), input$y_range[1], input$y_range[2]))
    }
    df
  })
  
  output$x_range_slider <- renderUI({
    req(input$xvar)
    x_data <- dig_filtered()[[input$xvar]]
    sliderInput("x_range", paste("Range of ", input$xvar, ":"), 
                min = round(min(x_data, na.rm = TRUE), 1),
                max = round(max(x_data, na.rm = TRUE), 1),
                value = c(min(x_data, na.rm = TRUE), max(x_data, na.rm = TRUE)),
                step = (max(x_data, na.rm = TRUE) - min(x_data, na.rm = TRUE)) / 100)
  })
  
  
  # instruction on how to generate the graph       
  output$usergraph <- renderText({
    HTML("<p>A scatter plot is ideal for showing the relationship between two continuous variables.<p> 
         <p>For example, if you set Age on the X-axis and BMI on the Y-axis (both continuous variables), 
         the scatter plot will display how BMI values vary across different ages, helping you identify 
         patterns, trends, or potential correlations between the two variables. Using the range selectors, can 
         further narrow the displayed data by specifying the desired ranges for each continuous variable.<p>
         <p>Additionally, selecting the relevant discrete variables (using the discrete variable checkbox) 
         allows you to filter the data more effectively and customize the graph output according to your specific needs.<p>
         <p>You can further enhance your visualization by adding additional parameters such as 
         marginal plots (here, histograms or density plots) and a trend line to provide deeper insights into the data.<p>
         <p>Finally you will be able to download the plotted graph with the top left conner of the box.<p>")})
  
  # Plot rendering
  output$relation_plot <- renderPlot({
    req(input$xvar, input$yvar)
    df <- dig_filtered()
    
    p <- ggplot(df, aes(x = !!input$xvar, y = !!input$yvar, color = trtmt)) +
      geom_point(alpha = 0.7) +
      theme_minimal() +
      labs(title = paste("Graph of", as_label(input$yvar), "vs", as_label(input$xvar)),
           x = as_label(input$xvar),
           y = as_label(input$yvar),
           color = "Treatment") +
      theme(plot.title = element_text(hjust = 0.5),
            legend.position = "bottom")
    
    if (isTRUE(input$add_smoother)) {
      p <- p + geom_smooth(se = T)   
    }
    
    if (isTRUE(input$show_margins)) {
      p <- ggExtra::ggMarginal(
        p,
        type = input$margin_type,
        margins = "both",
        size = 8,
        groupColour = TRUE,
        groupFill = TRUE
      )
    }
    p
  }, res = 100)
}