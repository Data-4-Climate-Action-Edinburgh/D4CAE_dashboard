# README 

Rainfall data downloaded from SEPA. Scottish Environment Protection Agency 
https://www2.sepa.org.uk/rainfall/ 

See the other github repo for the pre-processing steps / code: 
https://github.com/data4climateactionedinburgh/Data4ClimateActionEdinburgh_Code_etc 

# Read in the CSV file
readr::read_csv("data/aggreg_edinburgh_rainfall.csv") 

# Import to data/ so that dashboard can access it as a tibble
usethis::use_data(aggreg_edinburgh_rainfall)
