# simple plot of rainfall 

library(tidyverse)

# Placeholder code - needs work
  rainfall_to_plot <- tibble()
  rainfall_to_plot <- read_csv("../data/rainfall/Gogarbank_dailyrain_CSV_Exported_At_202503230838.csv")
  
rainfall_to_plot <-   rainfall_to_plot |>
    mutate(MeasurementDate = as.POSIXct(Timestamp, format = "%d/%m/%Y"))
  
rainfall_to_plot |> ggplot(aes(x = MeasurementDate, y = Value))
    