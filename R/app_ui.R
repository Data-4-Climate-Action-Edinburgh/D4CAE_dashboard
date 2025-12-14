#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    # Your application UI logic
    fluidPage(

      ### ================================
      ### HEADER WITH LOGO + TITLE (TOP BAR)
      ### ================================
      titlePanel(
        div(
          class = "topbar",
          style = "display: flex; align-items: center; gap: 15px; padding: 12px 20px;",

          # Logo (properly sized and aligned)
          tags$a(
            href = "https://data-4-climate-action-edinburgh.github.io/home/",
            tags$img(
              src = "www/D4CAE_org_logo_transparent.png",
              alt = "D4CAE logo",
              height = "80px",
              style = "max-height: 70px; width: auto;"
            )
          ),

          # Title text
          tags$a(
            "D4CAE Dashboard",
            href = "https://data-4-climate-action-edinburgh.github.io/home/",
            style = "
              font-size: 27px;
              font-weight: 700;
              color: black;
              text-decoration: none;
            "
          )
        )
      ),

      ### ================================
      ### MAIN APP TABS
      ### ================================
      tabsetPanel(
        tabPanel("Active Travel",
                 mod_cycling_ui("cycle"),
                 "Data source: Cycling Scotland / City of Edinburgh Council"
        ),
        tabPanel("Rainfall",
                 mod_rainfall_ui("rain1"),
                 "Data source: SEPA"
        ),
        tabPanel("Overview",
                 includeHTML(system.file("app/www/intro.html", package = "climatedata"))
        ),
        tabPanel("Data sources",
                 includeHTML(system.file("app/www/data_sources.html", package = "climatedata"))

        )
      ),

      ### ================================
      ### FOOTER
      ### ================================
      div(
        style = "margin-top: 25px; font-size: 14px;",
        "Licence: ",
        tags$a("CC-BY", href = "https://creativecommons.org/licenses/by/4.0/"),
        " | ",
        tags$a("Data 4 Climate Action Edinburgh",
               href = "https://data-4-climate-action-edinburgh.github.io/home/"),
        " | Built by Ebrahim Makhoul and Pauline Ward using RShiny. See ",
        tags$a("open-source code",
               href = "https://github.com/Data-4-Climate-Action-Edinburgh/D4CAE_dashboard")
      )
    )
  )
}



#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "climatedata"
    ),
    includeCSS(app_sys("app/www/d4cae_dashboard.css"))   # <-- Loads your topbar styling
  )
}
