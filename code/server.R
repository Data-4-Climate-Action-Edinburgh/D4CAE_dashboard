# Pauline Ward
# June 2025
# Pre-process temperature data for the dashboard 
# Based on diamonds tutorial

library(tidyverse)
library(shiny)

# Placeholder code - needs work
function(input, output){
  temperature_to_plot <- tibble()
  
  dataset <- reactive({
    req(input$sampleSize)
    diamonds[sample(nrow(diamonds), input$sampleSize),]
    
    diamonds[sample(nrow(diamonds), input$sampleSize),]
    
    
  })
  
   
}