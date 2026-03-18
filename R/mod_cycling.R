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

    #       div(
    #         style = "
    #   background-color: #FFD966;
    #   padding: 15px;
    #   border-radius: 8px;
    # ",


          h4("Filters"),

          shinyWidgets::pickerInput(
            inputId = ns("class_select"),
            label = "Select Class",
            choices = c("Pedestrians" = "pedestrian",
                        "Cycles" = "cycle"),
            selected = "pedestrian",
            multiple = TRUE,
            options = list(`actions-box` = TRUE)
          ),

          dateRangeInput(
            inputId = ns("date_range"),
            label = "Select Date Range",
            start = "2016-01-01",
            end = Sys.Date()
          )
          # )
        ),

        column(
          width = 9,

          tabsetPanel(

            # =====================================
            # TIME TRENDS TAB
            # =====================================
            tabPanel(
              "Time Trends",

              div(
                style = "display:flex; justify-content:flex-end; gap:10px; margin-top:10px;",

                actionButton(
                  ns("how_time"),
                  "How to use",
                  class = "btn-primary"
                ),

                actionButton(
                  ns("desc_time"),
                  "Plot description",
                  class = "btn-warning"
                )
              ),

              shinycssloaders::withSpinner(
                plotly::plotlyOutput(ns("time_plot"),
                                     height = "500px")
              )
            ),

            # =====================================
            # MAP TAB
            # =====================================
            tabPanel(
              "Map",

              div(
                style = "display:flex; justify-content:flex-end; gap:10px; margin-top:10px;",

                actionButton(
                  ns("how_map"),
                  "How to use",
                  class = "btn-primary"
                ),

                actionButton(
                  ns("desc_map"),
                  "Plot description",
                  class = "btn-warning"
                )
              ),

              shinycssloaders::withSpinner(
                leaflet::leafletOutput(ns("map_plot"),
                                       height = "500px")
              )
            ),

            # =====================================
            # BAR CHART TAB
            # =====================================
            tabPanel(
              "Average Counts by Location",

              div(
                style = "display:flex; justify-content:flex-end; gap:10px; margin-top:10px;",

                actionButton(
                  ns("how_bar"),
                  "How to use",
                  class = "btn-primary"
                ),

                actionButton(
                  ns("desc_bar"),
                  "Plot description",
                  class = "btn-warning"
                )),

              shinycssloaders::withSpinner(
                plotly::plotlyOutput(ns("bar_plot"),
                                     height = "500px")
              )
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

    # =====================================
    # FILTERED DATA
    # =====================================
    filtered_data <- reactive({
      df <- cyc_ped_data %>%
        dplyr::filter(
          class %in% input$class_select,
          startTime >= input$date_range[1],
          endTime <= input$date_range[2]
        )
      df
    })


    # =====================================
    # TIME SERIES PLOT
    # =====================================
    output$time_plot <- plotly::renderPlotly({
      req(filtered_data())

      df <- filtered_data() %>%
        dplyr::mutate(
          class = dplyr::recode(class,
                                "pedestrian" = "Pedestrians",
                                "cycle" = "Cycles")
        ) %>%
        dplyr::group_by(class,
                        date = lubridate::as_date(startTime)) %>%
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
              x = -0.125,
              y = 0.5,
              text = "Count",
              xref = "paper",
              yref = "paper",
              showarrow = FALSE,
              font = list(size = 16)
            )
          )
        )
    })


    # =====================================
    # MAP PLOT
    # =====================================
    output$map_plot <- leaflet::renderLeaflet({
      req(filtered_data())

      df <- filtered_data() %>%
        dplyr::group_by(location,
                        latitude,
                        longitude) %>%
        dplyr::summarise(
          avg_count = mean(count, na.rm = TRUE),
          .groups = "drop"
        )

      map_plot(df)
    })


    # =====================================
    # BAR PLOT
    # =====================================
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


    # =====================================
    # ACCESSIBILITY MODALS
    # =====================================

    # ---- Time Trends ----
    observeEvent(input$how_time, {
      showModal(
        modalDialog(
          title = "How to Use the Time Trends View",
          tags$ul(
            tags$li("Select pedestrian or cyclist in filters."),
            tags$li("Adjust the date range."),
            tags$li("Hover over the line to see daily counts.")
          ),
          easyClose = TRUE,
          footer = modalButton("Close")
        )
      )
    })

    observeEvent(input$desc_time, {
      showModal(
        modalDialog(
          title = "Time Trends Plot Description",
          tags$p("This time series plot shows total daily counts for the selected travel class. The horizontal axis represents date and the vertical axis represents total counts."),
          easyClose = TRUE,
          footer = modalButton("Close")
        )
      )
    })


    # ---- Map ----
    observeEvent(input$how_map, {
      showModal(
        modalDialog(
          title = "How to Use the Map View",
          tags$ul(
            tags$li("Use filters to change displayed data."),
            tags$li("Zoom and pan to explore areas."),
            tags$li("Click markers to see average counts.")
          ),
          easyClose = TRUE,
          footer = modalButton("Close")
        )
      )
    })

    observeEvent(input$desc_map, {
      showModal(
        modalDialog(
          title = "Map Description",
          tags$p("This map displays average travel counts by monitoring location. Each marker represents a site. Higher values indicate greater travel activity."),
          easyClose = TRUE,
          footer = modalButton("Close")
        )
      )
    })


    # ---- Bar Chart ----
    observeEvent(input$how_bar, {
      showModal(
        modalDialog(
          title = "How to Use the Bar Chart",
          tags$ul(
            tags$li("Bars represent average counts by location."),
            tags$li("Locations are ranked from highest to lowest."),
            tags$li("Hover over bars to view values.")
          ),
          easyClose = TRUE,
          footer = modalButton("Close")
        )
      )
    })

    observeEvent(input$desc_bar, {
      showModal(
        modalDialog(
          title = "Bar Chart Description",
          tags$p("This bar chart ranks the top 15 monitoring locations by their average travel counts within the selected date range."),
          easyClose = TRUE,
          footer = modalButton("Close")
        )
      )
    })

  })
}
