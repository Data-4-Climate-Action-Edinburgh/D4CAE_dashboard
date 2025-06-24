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
     diamonds[sample(nrow(diamonds), input$sampleSize),]
    
    diamonds[sample(nrow(diamonds), input$sampleSize),]
    
    
  })
  
   
}