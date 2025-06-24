# Pauline Ward
# June 2025
# Pre-process temperature data for the dashboard 
# Based on diamonds tutorial

library(tidyverse)
library(shiny)

# Placeholder code - needs work
function(input, output){
  rainfall_to_plot <- tibble()
  rainfall_to_plot <- read_csv("../data/rainfall/aggreg_edinburgh_rainfall.csv")
  
  dataset <- reactive({
     rainfall_to_plot[sample(nrow(rainfall_to_plot), input$sampleSize),]
    
# do the plot first, in a script, then put here
    
  })
  
   
}