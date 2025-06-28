# Pauline Ward June 2025
# RShiny app - a single app.R script containing ui and server
# Based on Posit tutorial https://shiny.posit.co/r/getstarted/shiny-basics/lesson5/


library(shiny)
library(tidyverse)

# Go back to https://mastering-shiny.org/basic-app.html

rainfall_to_plot <- tibble()
rainfall_to_plot <- read_csv("../data/rainfall/aggreg_edinburgh_rainfall.csv")

# Import data and convert dates
rainfall_to_plot <-   rainfall_to_plot |>
  mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y")) 

# Allows the ui to draw the input options from the rainfall data eg col names
#

# For follow-along with mastering shiny
dataset <- ls("package:datasets")

# UI (previously in ui.R)
ui <- fluidPage(
  "my knee, tiny, just go on and try me", 
  
  titlePanel("Edinburgh Rain by D4CAE"),
  
  sidebarPanel(
    selectInput("the_dataset", label = "Inbuilt Datasets set", choices = dataset),
    verbatimTextOutput("summary"),
    tableOutput("table"),
  #  sliderInput('rainfall_in_mm', 'Amount of rain', min=0, max=nrow(dataset),
    #            value=min(0, nrow(dataset)), step=0.5, round=0),
    
    selectInput('x', 'X', names(dataset)),
    selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
    selectInput('rain_station', 'Rain stationnnnn', c('None', names(dataset))),
    
    checkboxInput('jitter', 'Jitter'),
    checkboxInput('smooth', 'Smooth'),
    
    dateRangeInput(inputId = "myDateRange", label = "Dates for rain, I can't stand the rain"),
    
    selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
    selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))

  ),
  
  mainPanel(
    plotOutput('rainplot')
  )
) 

# Server (previously in server.R)
# Process the data
server <- function(input, output, session){
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
  dataset <- reactive({
    
    # did the plot first, in wee bit rain script, then put here
    rainfall_to_plot |> ggplot(aes(x = MeasurementDate, y = rainfall_in_mm))+
      geom_line()
    
  })
  output$rainfall_plot <- renderPlot({dataset})
  
}

shinyApp(ui, server)
