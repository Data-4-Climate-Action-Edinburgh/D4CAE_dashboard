#' second_rainfall UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_second_rainfall_ui <- function(id) {
  ns <- NS(id)
  tagList(

    sidebarLayout(
      sidebarPanel(
        selectInput(ns("rain_station"),
                    "Please select a rain station",
                    unique(aggreg_edinburgh_rainfall$rain_station)),
        dateRangeInput(ns("date"),
                    "Please select a date",
                    start = "2024-03-23", end = "2025-03-21",
                    min = "2024-03-23", max = "2025-03-21")
      ),
      mainPanel(

        plotOutput(ns("rainfall_line")),
        tableOutput(ns("rainfall_table"))

      )
    )

  )
}

#' second_rainfall Server Functions
#'
#' @noRd
mod_second_rainfall_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    colors <- c("All Edinburgh stations" = "blue",
                "Comiston" = "green",
                "Gogarbank" = "green",
                "Harelaw" = "green",
                "Murray" = "green",
                "RBGE" = "green")

    line_chart_data <- reactive({

      aggreg_edinburgh_rainfall %>%
        filter(rain_station == input$rain_station,
               between(Timestamp ,input$date[1], input$date[2]))

    })

    table_data <- reactive({

      aggreg_edinburgh_rainfall %>%
        filter(between(Timestamp ,input$date[1], input$date[2]))

    })


    output$rainfall_line <- renderPlot({

      line_chart_data() %>%
        ggplot2::ggplot(aes(Timestamp, rainfall_in_mm, group = rain_station, colour = rain_station)) +
        ggplot2::geom_line()+
        theme_minimal()+
        scale_color_manual(values = colors)+
        theme()

    })

    output$rainfall_table <- renderTable({

      table_data() %>%
          group_by(rain_station) %>%
          summarise(rainfall_in_mm = sum(rainfall_in_mm))


    })


  })
}

## To be copied in the UI
# mod_second_rainfall_ui("second_rainfall_1")

## To be copied in the server
# mod_second_rainfall_server("second_rainfall_1")
