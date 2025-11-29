# README - D4CAE dashboard

This is built using RShiny golem. 

## To run the app locally: ## 

 library(devtools) 

 load_all() 

 run_app()

## To import the rainfall data ## 
## Monthly rainfall only at present ##

library(readr) 

library(here)

aggreg_edinburgh_rainfall <- readr::read_csv(here("data", "aggreg_edinburgh_rainfall.csv"))
# old # aggreg_edinburgh_rainfall2 <- readr::read_csv(here("data", "MONTHLY_aggreg_edinburgh_rainfall.csv"))

# Import to data/ as .rda so that dashboard can access it as a tibble
usethis::use_data(aggreg_edinburgh_rainfall, overwrite = TRUE)

## To import the active travel data ie one file for cycling and walking ## 

library(readr) 
library(here)

cyc_ped_data <- read_csv(here("data", "cyc_ped_data.csv"))

# Import to data/ as a .rda file so that dashboard can access it as a tibble
usethis::use_data(cyc_ped_data, overwrite = TRUE)

