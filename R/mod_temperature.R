#' temperature_mod UI Function
#'
#' @description A shiny Module to display temperature data.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_temperature_ui <- function(id) {
  ns <- NS(id)
  tagList(

    fluidPage(
      fluidRow(
        column(
          width = 3,
          h4("Filters"),
          sidebarPanel(
            dateRangeInput(
              inputId = ns("date_range"),
              label = "Select Date Range",
              start = "1990-01-01", # To be adjusted
              end = Sys.Date()
            ),

          ),

          mainPanel(
            plotOutput('temperature_plot')
          )
        ) # end of column
        ) # end fluidRow
      ) # end fluidPage
    ) # end tagList
} # end function


#' temperature_mod Server Functions
#'
#' @noRd
mod_temperature_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns


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
