# simple plot of rainfall 
# Trying out data prep steps quickly 
# to then copy and paste to shiny server

library(tidyverse)

rainfall_to_plot <- tibble()

#---- Pre-aggregated file containing all rain stations, but not averaged
rainfall_to_plot_agg <- read_csv("../data/rainfall/aggreg_edinburgh_rainfall.csv") 


# Version where I plot without filtering to just one station
# So as to preserve all the rows, so user can filter on them
rainfall_to_plot <-   rainfall_to_plot_agg |>
  mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y")) 

rainfall_to_plot |> ggplot(aes(x = MeasurementDate, y = rainfall_in_mm))+
  geom_line()


# For testing, only use Harelaw
rainfall_to_plot <-   rainfall_to_plot_agg |>
  mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y")) |>
  filter(str_detect(rain_station, "Harelaw"))


#---- Single rain station input version
rainfall_to_plot <- read_csv("../data/rainfall/Gogarbank_dailyrain_CSV_Exported_At_202503230838.csv")

rainfall_to_plot <-   rainfall_to_plot |>
  mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y"))

rainfall_to_plot |> ggplot(aes(x = MeasurementDate, y = Value))+
  geom_line()


  
  
    