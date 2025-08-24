#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  # mod_first_mod_server("firstmod")
  # mod_cycling_server("cycle")
  mod_second_rainfall_server("secondmod")
}
