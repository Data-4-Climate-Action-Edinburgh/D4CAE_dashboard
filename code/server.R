# Pauline Ward
# June 2025
# Pre-process temperature data for the dashboard 
# Based on diamonds tutorial

library(tidyverse)
library(shiny)

# Placeholder code - needs work
function(input, output){
  rainfall_to_plot <- tibble()
#  rainfall_to_plot <- read_csv("../data/rainfall/aggreg_edinburgh_rainfall.csv")
  
  # Import data
  rainfall_to_plot <- read_csv("../data/rainfall/Gogarbank_dailyrain_CSV_Exported_At_202503230838.csv")
  
  rainfall_to_plot <-   rainfall_to_plot |>
    mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y"))
  
  dataset <- reactive({
#     rainfall_to_plot[sample(nrow(rainfall_to_plot), input$sampleSize),]
# do the plot first, in a script, then put here
 
    
    rainfall_to_plot |> ggplot(aes(x = MeasurementDate, y = Value))+
      geom_line()
    
  })
  output$rainfall_plot <- renderPlot({dataset})
   
}