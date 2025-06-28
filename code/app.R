# Pauline Ward June 2025
# RShiny app - a single app.R script containing ui and server


library(shiny)
library(tidyverse)

# Go back to https://mastering-shiny.org/basic-app.html
# TBC https://mastering-shiny.org/basic-app.html#server-function terrible examples as usual

# For follow-along with mastering shiny
# do not rename, apparently
dataset <- ls("package:datasets")

# UI (previously in ui.R)
ui <- fluidPage(

  titlePanel("Not Edinburgh Rain by D4CAE"),
  
  sidebarPanel(
    selectInput(inputId = "dataset", label = "Inbuilt Datasets set", choices = dataset),
    verbatimTextOutput("lovely_summary"),
    tableOutput("troubled_table"),

 
    
    selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
    selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))

  ),
  
  mainPanel(
 #   selectInput('x', 'X', names(dataset)),
#    selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
    
    checkboxInput('jitter', 'Jitter'),
    checkboxInput('smooth', 'Smooth'),
    
    dateRangeInput(inputId = "funDateRange", label = "Dates for something funny"),
    )
) 

# Server (previously in server.R)
# Process the data
server <- function(input, output, session){
  output$yummy_summary <- renderPrint({
    dataset <- get(input$chosen_inbuilt_dataset, "are you familiar with package:datasets")
    summary(dataset)
  })
  
  output$table <- renderTable({
    dataset <- get(input$chosen_inbuilt_dataset, "package:datasets")
    dataset
  })

}

shinyApp(ui, server)
