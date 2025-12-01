
library(shiny)
ui <- fluidPage(
)
server <- function(input, output, session) {
  output$q <- renderText({
  
  })
}
shinyApp(ui = ui, server = server)