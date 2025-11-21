# ============================
# RAINFALL UI MODULE
# ============================
mod_rainfall_ui <- function(id) {
  ns <- NS(id)

  tagList(
    fluidPage(
      fluidRow(
        column(
          width = 3,
          h4("Filters"),
          shinyWidgets::pickerInput(
            inputId = ns("station_select"),
            label = "Select Stations",
            choices = unique(aggreg_edinburgh_rainfall$rain_station),
            multiple = TRUE,
            options = list(`actions-box` = TRUE)
          ),
          dateRangeInput(
            inputId = ns("date_range"),
            label = "Date Range",
            start = "2024-03-23",
            end = "2025-03-21"
          )
        ),

        column(
          width = 9,
          tabsetPanel(
            tabPanel(
              "Rainfall Over Time",
              shinycssloaders::withSpinner(
                plotOutput(ns("rain_time_plot"), height = "450px")
              )
            ),
            tabPanel(
              "Total Rainfall over 12 months by Station",
              shinycssloaders::withSpinner(
                plotOutput(ns("rain_station_plot"), height = "450px")
              )
            ),
            tabPanel(
              "Daily Summary Table",
              shinycssloaders::withSpinner(
                tableOutput(ns("rain_table"))
              )
            )
          )
        )
      )
    )
  )
}


# ============================
# RAINFALL SERVER MODULE
# ============================
mod_rainfall_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # ---- Convert data to reactive if needed ----
    get_data <- reactive({
      if (is.reactive(data)) data() else data
    })

    # ---- Update station picker ----
    observe({
      df <- get_data()

      shinyWidgets::updatePickerInput(
        session,
        inputId = "station_select",
        choices = sort(unique(df$rain_station)),
        selected = unique(df$rain_station)
      )
    })

    # ---- Filtered data ----
    filtered_data <- reactive({
      df <- get_data()

      req(input$station_select, input$date_range)

      df %>%
        dplyr::filter(
          rain_station %in% input$station_select,
          Timestamp >= input$date_range[1],
          Timestamp <= input$date_range[2]
        )
    })

    # ---- Rainfall Over Time ----
    output$rain_time_plot <- renderPlot({
      df <- filtered_data() %>%
        dplyr::group_by(Timestamp) %>%
        dplyr::summarise(total_rain = sum(rainfall_in_mm, na.rm = TRUE), .groups = "drop")

      rain_time_plot(df)
    })

    # ---- Total Rainfall over 12 months by Station ----
    output$rain_station_plot <- renderPlot({
      df <- filtered_data() %>%
        dplyr::group_by(rain_station) %>%
        dplyr::summarise(total_rain = sum(rainfall_in_mm, na.rm = TRUE), .groups = "drop") %>%
        dplyr::arrange(total_rain)

      rain_station_plot(df)

    })

    # ---- Summary Table ----
    output$rain_table <- renderTable({
      filtered_data() %>%
        dplyr::group_by(Timestamp, rain_station) %>%
        dplyr::summarise(daily_rain_mm = sum(rainfall_in_mm, na.rm = TRUE), .groups = "drop") %>%
        dplyr::arrange(desc(Timestamp))
    })
  })
}
