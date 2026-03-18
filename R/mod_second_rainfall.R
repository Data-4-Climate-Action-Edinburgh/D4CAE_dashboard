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

          # ---- Station Dropdown ----
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
            step = 30
          )
        ),

        column(
          width = 9,

          tabsetPanel(

            # =====================================
            # RAINFALL OVER TIME
            # =====================================
            tabPanel(
              "Rainfall Over Time",

              div(
                style = "display:flex; justify-content:flex-end; gap:10px; margin-top:10px;",

                actionButton(ns("how_time"), "How to use", class = "btn-primary"),
                actionButton(ns("desc_time"), "What does this show?", class = "btn-warning")
              ),

              shinycssloaders::withSpinner(
                plotly::plotlyOutput(ns("rain_time_plot"), height = "450px")
              )
            ),

            # =====================================
            # TOTAL RAINFALL BY STATION
            # =====================================
            tabPanel(
              "Total Rainfall by Station",

              div(
                style = "display:flex; justify-content:flex-end; gap:10px; margin-top:10px;",

                actionButton(ns("how_station"), "How to use", class = "btn-primary"),
                actionButton(ns("desc_station"), "What does this show?", class = "btn-warning")
              ),

              shinycssloaders::withSpinner(
                plotly::plotlyOutput(ns("rain_station_plot"), height = "450px")
              )
            ),

            # =====================================
            # MONTHLY TABLE
            # =====================================
            tabPanel(
              "Monthly Summary Table",

              div(
                style = "display:flex; justify-content:flex-end; gap:10px; margin-top:10px;",

                actionButton(ns("how_table"), "How to use", class = "btn-primary"),
                actionButton(ns("desc_table"), "What does this show?", class = "btn-warning")
              ),

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
# RAINFALL SERVER MODULE
# ============================
mod_rainfall_server <- function(id, data) {

  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    # ---- Get Data ----
    get_data <- reactive({
      if (is.reactive(data)) data() else data
    })

    # ---- Update station dropdown ----
    observe({
      df <- get_data()

      stations <- unique(df$rain_station)
      stations <- sort(stations[stations != "Edinburgh average"])
      stations <- c(stations, "Edinburgh average")

      updateSelectInput(
        session,
        "station_select",
        choices = stations,
        selected = stations[1]
      )
    })

    # ---- Filtered Data ----
    filtered_data <- reactive({
      df <- get_data()

      req(input$station_select, input$month_range)

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

    # ---- Bar chart data ----
    barchart_data <- reactive({
      df <- get_data()

      req(input$month_range)

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

    # ---- Rainfall Over Time ----
    output$rain_time_plot <- plotly::renderPlotly({

      df <- filtered_data() %>%
        dplyr::group_by(Month) %>%
        dplyr::summarise(
          total_rain = mean(rainfall_in_mm, na.rm = TRUE),
          .groups = "drop"
        )

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
              font = list(size = 16)
            )
          )
        )
    })

    # ---- Total Rainfall by Station ----
    output$rain_station_plot <- plotly::renderPlotly({

      df <- barchart_data() %>%
        dplyr::group_by(rain_station) %>%
        dplyr::summarise(
          total_rain = sum(rainfall_in_mm, na.rm = TRUE),
          .groups = "drop"
        ) %>%
        dplyr::arrange(total_rain)

      plotly::ggplotly(rain_station_plot(df), tooltip = "text")
    })

    # ---- Table ----
    output$rain_table <- DT::renderDataTable({

      filtered_data() %>%
        dplyr::mutate(
          Month = format(Month, "%b %Y"),
          rainfall_in_mm = round(rainfall_in_mm, 2)
        ) %>%
        dplyr::select(Month, rain_station, rainfall_in_mm) %>%
        dplyr::rename(
          "Station" = rain_station,
          "Rainfall (mm)" = rainfall_in_mm
        ) %>%
        dplyr::arrange(desc(Month))

    }, options = list(pageLength = 20, autoWidth = TRUE))


    # =====================================
    # MODALS
    # =====================================

    # ---- Time Plot ----
    observeEvent(input$how_time, {
      showModal(modalDialog(
        title = "How to Use the Rainfall Over Time Plot",
        tags$ul(
          tags$li("Select a station."),
          tags$li("Adjust the date range."),
          tags$li("Hover over the plot to see monthly rainfall values.")
        ),
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
    })

    observeEvent(input$desc_time, {
      showModal(modalDialog(
        title = "Rainfall Over Time Description",
        tags$p("This plot shows average monthly rainfall (mm) for the selected station over time."),
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
    })


    # ---- Station Plot ----
    observeEvent(input$how_station, {
      showModal(modalDialog(
        title = "How to Use the Station Comparison Plot",
        tags$ul(
          tags$li("Adjust the date range."),
          tags$li("Compare rainfall across stations."),
          tags$li("Hover to see exact totals.")
        ),
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
    })

    observeEvent(input$desc_station, {
      showModal(modalDialog(
        title = "Total Rainfall by Station Description",
        tags$p("This chart compares total rainfall across stations within the selected period."),
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
    })


    # ---- Table ----
    observeEvent(input$how_table, {
      showModal(modalDialog(
        title = "How to Use the Table",
        tags$ul(
          tags$li("Use filters to update the table."),
          tags$li("Scroll and search to explore data.")
        ),
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
    })

    observeEvent(input$desc_table, {
      showModal(modalDialog(
        title = "Table Description",
        tags$p("This table shows monthly rainfall values for the selected station."),
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
    })

  })
}
