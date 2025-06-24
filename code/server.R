# Pauline Ward
# June 2025
# Pre-process temperature data for the dashboard 
# Based on diamonds tutorial

library(tidyverse)
library(shiny)

# Process the data
function(input, output){
  rainfall_to_plot <- tibble()
  rainfall_to_plot <- read_csv("../data/rainfall/aggreg_edinburgh_rainfall.csv")
  
  # Import data and convert dates
  rainfall_to_plot <-   rainfall_to_plot_agg |>
    mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y")) 
  
  dataset <- reactive({

    # did the plot first, in wee bit rain script, then put here
     rainfall_to_plot |> ggplot(aes(x = MeasurementDate, y = rainfall_in_mm))+
      geom_line()
    
  })
  output$rainfall_plot <- renderPlot({dataset})
   
}

#---- Old version importing an original single rain station file 
# Import data
# rainfall_to_plot <- read_csv("../data/rainfall/Gogarbank_dailyrain_CSV_Exported_At_202503230838.csv")
