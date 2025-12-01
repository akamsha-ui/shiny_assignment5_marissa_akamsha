library(janitor)
library(tidyverse)
dig.df <- read.csv("DIG.csv")
View(dig.df)
dig.df <- dig.df %>%
  janitor::clean_names()%>%
  mutate(
    trtmt = factor(trtmt, levels = c(0,1), labels = c("Placebo", "Treatment")), 
    sex = factor(sex, levels = c(1,2), labels = c("Males", "Females")),
    #hyperten = factor(hyperten, levels = c(0,1)), 
    hyperten = factor(hyperten, levels = c(0,1), labels = c("No","Yes")),
    cvd = factor(cvd, levels = c(0,1), labels = c("No","Yes")),
    whf = factor(whf, levels = c(0,1), labels = c("No","Yes")), 
    dig = factor(dig, levels = c(0,1), labels = c("No","Yes")), 
    hosp = factor(hosp, levels = c(0,1), labels = c("No","Yes")), 
    death = factor(death, levels = c(0,1), labels = c("Alive","Death"))
  ) %>%
  
  select(id, trtmt, age, sex, bmi, klevel, creat, diabp, sysbp, hyperten, cvd, whf, dig, hosp, hospdays, death, deathday)

library(bslib)
library(shiny)

ui <- fluidPage(
)
server <- function(input, output, session) {
  output$q <- renderText({
  
  })
}
shinyApp(ui = ui, server = server)