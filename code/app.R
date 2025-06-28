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

  # while sidebar is a good place for inputs, mainpanel good for outputs
  sidebarPanel(
    selectInput(inputId = "dataset", label = "Inbuilt Datasets set", choices = dataset),
    checkboxInput('jitter', 'Jitter'),
    checkboxInput('smooth', 'Smooth'),
    
    dateRangeInput(inputId = "funDateRange", label = "Dates for something funny"),
    
  ),
  
  # while sidebar is a good place for inputs, mainpanel good for outputs
  mainPanel(
    "My lovely summery summary",
    verbatimTextOutput("lovely_summary"),
    
    "My not-so-stable troubled table",
    tableOutput("troubled_table"),
    
    )
) 

# Server (previously in server.R)
# Process the data
server <- function(input, output, session){
  output$lovely_summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$troubled_table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })

}

shinyApp(ui, server)
