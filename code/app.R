# Pauline Ward June 2025
# RShiny app - a single app.R script containing ui and server

library(shiny)
library(tidyverse)

rainfall_data <- tibble()
rainfall_data <- read_csv("../data/rainfall/aggreg_edinburgh_rainfall.csv")

# Import data and convert dates
rainfall_data <-   rainfall_data |>
  mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y")) 

rain_stations <- unique(rainfall_data$rain_station)

# TBC https://mastering-shiny.org/basic-app.html#server-function terrible examples as usual

# User Interface object
ui <- fluidPage(

  titlePanel("Edinburgh Rainfall by D4CAE"),
  
  sidebarPanel(
    selectInput(inputId = "chosen_rain_station", 
                label = "Optionally, select a rainfall station", 
                choices = c(None=',', rain_stations)),
    
    sliderInput(inputId = 'rainfall_in_mm', 
                label = 'Amount of rain', 
                min=0, max=nrow(rainfall_data),
                value=min(0, nrow(rainfall_data)), step=0.5, round=0),
    
    dateRangeInput(inputId = "myDateRange", label = "Dates for rain, walking in the rain"),
    
  ),
  
  mainPanel(
    verbatimTextOutput(outputId = "nice_summary"),
    
    plotOutput(outputId = 'rainplot'),
    
    tableOutput(outputId = "fable_table")
  )
) 

# Server - Process the data
server <- function(input, output, session){

  drizzly_dataset <- reactive({
    
    rainfall_data_to_plot <- rainfall_data |> 
      filter(str_detect(rain_station, get(input$chosen_rain_station)))
    
  })
    
  output$nice_summary <- renderPrint({
    
    # For now, just narrow down with hard-wired choice, 'Mint'
    the_relevant_data <- rainfall_data |>
      filter(str_detect(rain_station, get(input$chosen_rain_station))) 
    
    summary(the_relevant_data)
  })
  

  output$rainplot <- renderPlot({
    rainfall_data_to_plot |> ggplot(aes(x = MeasurementDate, y = rainfall_in_mm))+
      geom_line()
    })
  

  output$fable_table <- renderTable({
    rainfall_data_to_plot
    
    # workaround, just display narrowed down table
    #rainfall_data |>
     # filter(str_detect(rain_station, "Murray"))
  })
  }

shinyApp(ui, server)
