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
 
  )
}
    
#' cycling Server Functions
#'
#' @noRd 
mod_cycling_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_cycling_ui("cycling_1")
    
## To be copied in the server
# mod_cycling_server("cycling_1")
