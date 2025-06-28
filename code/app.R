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
    tableOutput("troubled_table"),

  ),
  
  mainPanel(
    verbatimTextOutput("lovely_summary"),
    checkboxInput('jitter', 'Jitter'),
    checkboxInput('smooth', 'Smooth'),
    
    dateRangeInput(inputId = "funDateRange", label = "Dates for something funny"),
    )
) 

# Server (previously in server.R)
# Process the data
server <- function(input, output, session){
  output$lovely_summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$table <- renderTable({
    dataset <- get(input$chosen_inbuilt_dataset, "package:datasets")
    dataset
  })

}

shinyApp(ui, server)
