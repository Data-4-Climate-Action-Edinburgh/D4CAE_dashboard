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
            choices = c("pedestrian", "cyclist"),
            selected = "pedestrian",
            multiple = TRUE,
            options = list(`actions-box` = TRUE)
          ),
          dateRangeInput(
            inputId = ns("date_range"),
            label = "Select Date Range",
            start = "2020-01-01",
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
      df <- cycle_data_2 %>%
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
        dplyr::summarise(total_count = sum(count, na.rm = TRUE), .groups = "drop")

      p <- ggplot2::ggplot(df, ggplot2::aes(x = date, y = total_count, color = class)) +
        ggplot2::geom_line(size = 1) +
        ggplot2::labs(
          title = "Daily Counts Over Time",
          x = "Date",
          y = "Total Count"
        ) +
        ggplot2::theme_minimal()

      plotly::ggplotly(p)
    })

    # ---- Map Plot ----
    output$map_plot <- leaflet::renderLeaflet({
      req(filtered_data())
      df <- filtered_data() %>%
        dplyr::group_by(location, latitude, longitude) %>%
        dplyr::summarise(avg_count = mean(count, na.rm = TRUE), .groups = "drop")

      leaflet::leaflet(df) %>%
        leaflet::addTiles() %>%
        leaflet::addCircleMarkers(
          lng = ~longitude,
          lat = ~latitude,
          popup = ~paste0("<b>", location, "</b><br>Average Count: ", round(avg_count, 1)),
          radius = ~scales::rescale(avg_count, to = c(4, 12)),
          color = "#0072B2",
          fillOpacity = 0.7
        )
    })

    # ---- Bar Plot ----
    output$bar_plot <- plotly::renderPlotly({
      req(filtered_data())
      df <- filtered_data() %>%
        dplyr::group_by(location) %>%
        dplyr::summarise(mean_count = mean(count, na.rm = TRUE)) %>%
        dplyr::arrange(desc(mean_count)) %>%
        dplyr::slice_head(n = 15)

      p <- ggplot2::ggplot(df, ggplot2::aes(x = reorder(location, mean_count), y = mean_count)) +
        ggplot2::geom_col(fill = "#56B4E9") +
        ggplot2::coord_flip() +
        ggplot2::labs(
          title = "Top 15 Locations by Average Count",
          x = "Location",
          y = "Average Count"
        ) +
        ggplot2::theme_minimal()

      plotly::ggplotly(p)
    })
  })
}

## To be copied in the UI
# mod_cycling_ui("cycling_1")

## To be copied in the server
# mod_cycling_server("cycling_1")
