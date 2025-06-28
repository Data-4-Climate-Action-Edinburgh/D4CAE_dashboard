# Pauline Ward June 2025
# RShiny app - a single app.R script containing ui and server

library(shiny)
library(tidyverse)

rainfall_data <- tibble()
rainfall_data <- read_csv("../data/rainfall/aggreg_edinburgh_rainfall.csv")

# Import data and convert dates
rainfall_data <-   rainfall_data |>
  mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y")) 

# Allows the ui to draw the input options from the rainfall data eg col names
dataset <- rainfall_data

rain_stations <- unique(rainfall_data$rain_station)

# TBC https://mastering-shiny.org/basic-app.html#server-function terrible examples as usual

# User Interface object
ui <- fluidPage(

  titlePanel("Edinburgh Rainfall by D4CAE"),
  
  sidebarPanel(
    selectInput(inputId = "chosen_rain_stations", label = "Optionally, select a rainfall station", choices = c(None=',', rain_stations)),
    sliderInput('rainfall_in_mm', 'Amount of rain', min=0, max=nrow(dataset),
                value=min(0, nrow(dataset)), step=0.5, round=0),
    
    dateRangeInput(inputId = "myDateRange", label = "Dates for rain, walking in the rain"),

  ),
  
  mainPanel(
    verbatimTextOutput("nice_summary"),
    
    tableOutput("fable_table")
    
 #    plotOutput('rainplot')
  )
) 

# Server - Process the data
server <- function(input, output, session){
  
  output$nice_summary <- renderPrint({
    # not working
   # selected_stn <- get(input$chosen_rain_stations)
    
    # For now, just narrow down with hard-wired choice, 'Mint'
    the_relevant_data <- rainfall_data |>
      filter(str_detect(rain_station, "Murray")) # selected_stn)) 
    
    summary(the_relevant_data)
  })
  
  output$fable_table <- renderTable({
    # not working? 
    #dataset_pour_la_table <- get(input$chosen_rain_stations)
    #dataset_pour_la_table
    
    # workaround, just display narrowed down table
    rainfall_data |>
      filter(str_detect(rain_station, "Murray"))
  })
  
  dataset <- reactive({
    
    # did the plot first, in wee bit rain script, then put here 
 #   rainfall_to_plot |> ggplot(aes(x = MeasurementDate, y = rainfall_in_mm))+
  #    geom_line()
    
  })
#  output$rainfall_plot <- renderPlot({dataset})
  
}

shinyApp(ui, server)
