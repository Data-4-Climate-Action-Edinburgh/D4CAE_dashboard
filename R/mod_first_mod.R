#' first_mod UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_first_mod_ui <- function(id) {
  ns <- NS(id)
  tagList(

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
      plotOutput('rainfall_plot')
    )

  )
}

#' first_mod Server Functions
#'
#' @noRd
mod_first_mod_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # rainfall_to_plot <- tibble()
  # rainfall_to_plot <- read_csv("../data/rainfall/aggreg_edinburgh_rainfall.csv")

  # Import data and convert dates
  rainfall_to_plot <-   rainfall_to_plot |>
    mutate(MeasurementDate = as.POSIXct(rainfall_to_plot$Timestamp, format = "%d/%m/%Y"))

  dataset <- reactive({

    # did the plot first, in wee bit rain script, then put here
    plot <- rainfall_to_plot |> ggplot(aes(x = MeasurementDate, y = rainfall_in_mm))+
      geom_line()

    plot

  })

  output$rainfall_plot <- renderPlot({dataset})

  })
}

## To be copied in the UI
# mod_first_mod_ui("first_mod_1")

## To be copied in the server
# mod_first_mod_server("first_mod_1")
