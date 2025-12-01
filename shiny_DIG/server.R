#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#library(tidyverse,janitor)
library(tidyverse,janitor,ggplot)
dig_new.df <- dig.df %>%
  
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




library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })

}
