# ============================
# RAINFALL UI MODULE (Rewritten)
# ============================
mod_rainfall_ui <- function(id) {
  ns <- NS(id)

  tagList(
    fluidPage(
      fluidRow(
        column(
          width = 3,
          h4("Filters"),

          # ---- Single Station Dropdown ----
          selectInput(
            inputId = ns("station_select"),
            label = "Select Station",
            choices = NULL,
            selected = NULL
          ),


          # ---- Month-Year Selector ----
          sliderInput(
            inputId = ns("month_range"),
            label = "Select Date Range (Month-Year)",
            min = as.Date("2016-04-01"),
            max = Sys.Date(),
            value = c(as.Date("2016-04-01"), Sys.Date()),
            timeFormat = "%b %Y",
            step = 30 # approx months
          )
        ),

        column(
          width = 9,
          tabsetPanel(
            tabPanel(
              "Rainfall Over Time",
              shinycssloaders::withSpinner(
                plotly::plotlyOutput(ns("rain_time_plot"), height = "450px")
              )
            ),
            tabPanel(
              "Total Rainfall by Station",
              shinycssloaders::withSpinner(
                plotly::plotlyOutput(ns("rain_station_plot"), height = "450px")
              )
            ),
            tabPanel(
              "Monthly Summary Table",
              shinycssloaders::withSpinner(
                DT::dataTableOutput(ns("rain_table"))
              )
            )
          )
        )
      )
    )
  )
}


# ============================
# RAINFALL SERVER MODULE (Rewritten)
# ============================
mod_rainfall_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # ---- Use reactive data if provided ----
    get_data <- reactive({ if (is.reactive(data)) data() else data })

    # ---- Update station dropdown ----
    observe({
      df <- get_data()

      stations <- unique(df$rain_station)

      # Simple: alphabetical except last item
      stations <- sort(stations[stations != "Edinburgh average"])
      stations <- c(stations, "Edinburgh average")


      updateSelectInput(session, "station_select", choices = stations, selected = stations[1])
    })


    # ---- Prepare and filter data ----
    filtered_data <- reactive({
      df <- get_data()

      req(input$station_select, input$month_range)

      # ---- Convert "May 2024" to Date ----
      df <- df %>%
        dplyr::mutate(
          Timestamp = dplyr::coalesce(
            suppressWarnings(lubridate::ymd(Timestamp)),
            lubridate::my(Timestamp)
          ),
          Month = lubridate::floor_date(Timestamp, "month")
        )

      df %>%
        dplyr::filter(
          rain_station == input$station_select,
          Month >= input$month_range[1],
          Month <= input$month_range[2]
        )
    })


    barchart_data <- reactive({
      df <- get_data()

      req(input$station_select, input$month_range)

      # ---- Convert "May 2024" to Date ----
      df <- df %>%
        dplyr::mutate(
          Timestamp = dplyr::coalesce(
            suppressWarnings(lubridate::ymd(Timestamp)),
            lubridate::my(Timestamp)
          ),
          Month = lubridate::floor_date(Timestamp, "month")
        )

      df %>%
        dplyr::filter(
          rain_station != "Edinburgh average",
          Month >= input$month_range[1],
          Month <= input$month_range[2]
        )
    })


    # ---- Rainfall Over Time Plot ----
    output$rain_time_plot <- plotly::renderPlotly({
      df <- filtered_data() %>%
        dplyr::group_by(Month) %>%
        # Not clear if the below should be sum or mean????
        dplyr::summarise(total_rain = mean(rainfall_in_mm, na.rm = TRUE), .groups = "drop")


      plotly::ggplotly(rain_time_plot(df)) %>%
        plotly::layout(
          hovermode = "x unified",
          yaxis = list(title = ""),
          annotations = list(
            list(
              x = -0.125, y = 0.5,
              text = "Rainfall\n(mm)",
              xref = "paper", yref = "paper",
              showarrow = FALSE,
              textangle = 0,
              font = list(size = 16)
            )
          )
        )

    })



    # ---- Total Rainfall by Station ----
    output$rain_station_plot <- plotly::renderPlotly({
      df <- barchart_data() %>%
        dplyr::group_by(rain_station) %>%
        dplyr::summarise(total_rain = sum(rainfall_in_mm, na.rm = TRUE), .groups = "drop") %>%
        dplyr::arrange(total_rain)

      plotly::ggplotly(rain_station_plot(df), tooltip = "text")
    })


    # ---- Nicer Data Table ----
    output$rain_table <- DT::renderDataTable({
      filtered_data() %>%
        dplyr::mutate(
          Month = format(Month, "%b %Y"),
          rainfall_in_mm = round(rainfall_in_mm, 2)
        ) %>%
        dplyr::select(Month, rain_station, rainfall_in_mm) %>%
        dplyr::arrange(desc(Month))
    }, options = list(pageLength = 20, autoWidth = TRUE))
  })
}
