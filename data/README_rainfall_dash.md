# README 

Rainfall data downloaded from SEPA. Scottish Environment Protection Agency 
https://www2.sepa.org.uk/rainfall/ 

See the other github repo for the pre-processing steps / code: 
https://github.com/data4climateactionedinburgh/Data4ClimateActionEdinburgh_Code_etc 

# Do not use - Monthly rainfall - bad columns
library(readr) 

aggreg_edinburgh_rainfall2 = readr::read_csv("data/MONTHLY_aggreg_edinburgh_rainfall.csv")



# OLD - DO NOT USE - Read in the daily rainfall CSV file
library(readr) 

aggreg_edinburgh_rainfall <- readr::read_csv("data/aggreg_edinburgh_rainfall.csv", 
          col_types = cols(
            Timestamp = col_datetime(format = "%d/%m/%Y %H:%M:%S"), 
            rainfall_in_mm = col_double(),
            rain_station = col_character()
          ) 
)

# Import to data/ so that dashboard can access it as a tibble
usethis::use_data(aggreg_edinburgh_rainfall, overwrite = TRUE)

# Bugfix
# The dashboard is not running. Error says it is looking for 
# aggreg_edinburgh_rainfall2
# So I have created a copy of aggreg_edinburgh_rainfall 
# and renamed it aggreg_edinburgh_rainfall2. Did not work. 
