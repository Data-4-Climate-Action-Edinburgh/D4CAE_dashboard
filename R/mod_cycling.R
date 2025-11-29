#' cycling UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_cycling_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      fluidRow(
        column(
          width = 3,
          h4("Filters"),
          shinyWidgets::pickerInput(
            inputId = ns("class_select"),
            label = "Select Class",
            choices = c("Pedestrians" = "pedestrian", "Cyclists" = "cycle"),
            selected = "pedestrian",
            multiple = TRUE,
            options = list(`actions-box` = TRUE)
          ),
          dateRangeInput(
            inputId = ns("date_range"),
            label = "Select Date Range",
            start = "2016-01-01", # We have cycling and walking data from 2016
            end = Sys.Date()
          )
        ),
        column(
          width = 9,
          tabsetPanel(
            tabPanel(
              "Time Trends",
              shinycssloaders::withSpinner(plotly::plotlyOutput(ns("time_plot"), height = "500px"))
            ),
            tabPanel(
              "Map",
              shinycssloaders::withSpinner(leaflet::leafletOutput(ns("map_plot"), height = "500px"))
            ),
            tabPanel(
              "Average Counts by Location",
              shinycssloaders::withSpinner(plotly::plotlyOutput(ns("bar_plot"), height = "500px"))
            )
          )
        )
      )
    )
  )
}

#' cycling Server Functions
#'
#' @noRd
mod_cycling_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    filtered_data <- reactive({
      # req(data)
      df <- cyc_ped_data %>%
        dplyr::filter(
          class %in% input$class_select,
          startTime >= input$date_range[1],
          endTime <= input$date_range[2]
        )
      df
    })

    # ---- Time Series Plot ----
    output$time_plot <- plotly::renderPlotly({
      req(filtered_data())

      df <- filtered_data() %>%
        dplyr::group_by(class, date = lubridate::as_date(startTime)) %>%
        dplyr::summarise(
          total_count = sum(count, na.rm = TRUE),
          .groups = "drop"
        )

      p <- time_plot(df)

      plotly::ggplotly(p) %>%
        plotly::layout(
          hovermode = "x unified",
          yaxis = list(title = ""),
          annotations = list(
            list(
              x = -0.125, y = 0.5,
              text = "Count",
              xref = "paper", yref = "paper",
              showarrow = FALSE,
              textangle = 0,
              font = list(size = 16)
            )
          )
        )
    })


    # ---- Map Plot ----
    output$map_plot <- leaflet::renderLeaflet({
      req(filtered_data())
      df <- filtered_data() %>%
        dplyr::group_by(location, latitude, longitude) %>%
        dplyr::summarise(avg_count = mean(count, na.rm = TRUE), .groups = "drop")

      map_plot(df)

    })

    # ---- Bar Plot ----
    output$bar_plot <- plotly::renderPlotly({
      req(filtered_data())

      df <- filtered_data() %>%
        dplyr::group_by(location) %>%
        dplyr::summarise(
          mean_count = mean(count, na.rm = TRUE),
          .groups = "drop"
        ) %>%
        dplyr::arrange(desc(mean_count)) %>%
        dplyr::slice_head(n = 15)

      p <- bar_plot(df)

      plotly::ggplotly(p, tooltip = "text")
    })

  })
}

## To be copied in the UI
# mod_cycling_ui("cycling_1")

## To be copied in the server
# mod_cycling_server("cycling_1")
