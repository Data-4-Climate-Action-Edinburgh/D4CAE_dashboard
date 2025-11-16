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
      tags$img(src = "www/logo_organization_trees_bees_PCs_peeps.png",
               href="https://data-4-climate-action-edinburgh.github.io/home/"),
      h1("Data 4 Climate Action Edinburgh"), # h1 formatting is important for accessibility
      tabsetPanel(
        tabPanel("Rainfall",
                 mod_second_rainfall_ui("secondmod")
                 ),
        tabPanel("Cycling",
                 mod_cycling_ui("cycle")
      )
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
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
