library(tidyverse)
library(janitor) 
library(ggplot2)
library(shiny)
library(shinydashboard)

# para1 = ("The DIG (Digitalis Investigation Group) Trial was a randomized, double-blind, multicenter trial with more than 300 centers in the United States and Canada participating. The purpose of the trial was to examine the safety and efficacy of Digoxin in treating patients with congestive heart failure in sinus rhythm. Digitalis was introduced clinically more than 200 years ago and has since become a commonly prescribed medication for the treatment of heart failure; however, there was considerable uncertainty surrounding its safety and efficacy. Small trials indicated that Digoxin alleviated some of the symptoms of heart failure, prolonged exercise tolerance, and generally improved the quality of patients' lives. Unfortunately, these trials were generally small and although they did focus on the effect of treatment on patients’ relief from heart failure symptoms and quality of life, they failed to address the effect of treatment on cardiovascular outcomes. Questions about the safety of Digoxin were also a concern. Digoxin toxicity is uncommon in small trials with careful surveillance, however, the long-term effects of therapeutic levels of Digoxin were less clear.")
# para2 = ("The DIG dataset consists of baseline and outcome data from the main DIG trial. In the main trial, heart failure patients meeting the eligibility criterion and whose ejection fraction was 45% or less were randomized to receive either a placebo or digoxin. Outcomes assessed in the trial included: cardiovascular mortality, hospitalization or death from worsening heart failure, hospitalization due to other cardiovascular causes and hospitalization due to non-cardiovascular causes.")
# para3 = ("It was obtained for the purpose of this assignment and is enclosed with this assignment. The codebook associated with the variables is also enclosed with your assignment.")
# para4 = ("In order to create an anonymous dataset that protects patient confidentiality, most variables have been permuted over the set of patients within treatment group. Therefore, it would be inappropriate to use this dataset for other research or publication purposes.")
# rev = paste(para1, para2, para3, para4, sep = "<p>")
# rev

#server code
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
  output$legends <- renderTable({legends.df}) #rendering
  
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
  output$digds <- renderTable({dig.df}) #rendering
  
  ##here
  
  p.df <- read.csv("DIG.csv") %>%
    janitor::clean_names() %>% 
    select(trtmt, sex, age, bmi, klevel, creat, diabp, sysbp, hyperten, cvd, whf, dig, hosp, death) %>%
    na.omit() 
  p.df <- p.df%>%
    filter(row_number() != 833)
  p.df <- (p.df[-c(940),])
  p <- plot_ly(
    type = "parcoords",
    line = list(
      color     = p.df$trtmt,
      colorscale = list(c(0, "#A2CD5A"), c(1, "#FF7F00")),
      showscale = TRUE,
      alpha     = 0.4),
    dimensions = list(
      list(tickvals = c(0, 1), ticktext = c("Placebo", "Treatment"), label    = "TRTMT", values   = p.df$trtmt),
      list(range  = c(min(p.df$age,   na.rm = TRUE), max(p.df$age,   na.rm = TRUE)), label  = "AGE", values = p.df$age),
      list(range  = c(min(p.df$bmi,   na.rm = TRUE), max(p.df$bmi,   na.rm = TRUE)), label  = "BMI", values = p.df$bmi),
      list(range  = c(min(p.df$klevel, na.rm = TRUE), max(p.df$klevel, na.rm = TRUE)), label  = "KLEVEL", values = p.df$klevel),
      list(range  = c(min(p.df$creat, na.rm = TRUE), max(p.df$creat, na.rm = TRUE)), label  = "CREAT", values = p.df$creat),
      list(range  = c(min(p.df$diabp, na.rm = TRUE), max(p.df$diabp, na.rm = TRUE)), label  = "DIABP", values = p.df$diabp),
      list(range  = c(min(p.df$sysbp, na.rm = TRUE), max(p.df$sysbp, na.rm = TRUE)), label  = "SYSBP", values = p.df$sysbp),
      list(tickvals = c(1, 2), ticktext = c("Male", "Female"), label    = "SEX", values   = p.df$sex))) %>%
    layout(margin = list(t = 100), annotations = list(x = 0.5, y = 1.22, text = "Baseline Characteristics of Study Participants by Treatment Group", showarrow = FALSE, font = list(size = 15, color = "black")))
  output$overviewPlot <- renderPlotly({ggplotly(p)})
  
  
  output$overviewSummary <- renderTable({
    digData %>%
      summarise(Mean = mean(.data[[input$variable]], na.rm = TRUE),
                Median = median(.data[[input$variable]], na.rm = TRUE),
                SD = sd(.data[[input$variable]], na.rm = TRUE),
                Min = min(.data[[input$variable]], na.rm = TRUE),
                Max = max(.data[[input$variable]], na.rm = TRUE))
  })
  output$relationshipPlot <- renderPlot({
    ggplot(digData, aes_string(x=input$xvar, y=input$yvar)) +
      geom_point() +
      theme_minimal() +
      labs(title=paste(input$yvar, "vs", input$xvar))
  })
  
  output$relationshipSummary <- renderTable({
    digData %>%
      group_by(.data[[input$xvar]]) %>%
      summarise(Mean = mean(.data[[input$yvar]], na.rm = TRUE))
  })
}
