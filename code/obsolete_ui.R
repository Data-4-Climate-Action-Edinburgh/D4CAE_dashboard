# Pauline Ward June 2025
# user interface of RShiny app
# Based on diamonds tutorial

library(shiny)
library(ggplot2)

dataset <- diamonds 
# Generates an error when I swop in dataset <- rainfall_to_plot
# But I'm going to need to do that, to give user input options based on the rain data!?!

fluidPage(
  
  titlePanel("Edinburgh Rainy Rain from all the stations by D4CAE"),
  
  sidebarPanel(
    
    sliderInput('rainfall_in_mm', 'Amount of rain', min=1, max=nrow(dataset),
                value=min(0, nrow(dataset)), step=0.5, round=0),
    
    selectInput('x', 'X', names(dataset)),
    selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
    selectInput('rain_station', 'Rain stationnnnn', c('None', names(dataset))),
    
    checkboxInput('jitter', 'Jitter'),
    checkboxInput('smooth', 'Smooth'),
    
    selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
    selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
  ),
  
  mainPanel(
    plotOutput('rainplot')
  )
)