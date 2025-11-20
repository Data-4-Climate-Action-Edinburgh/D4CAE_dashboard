#' plot
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
rain_time_plot <- function(data) {

  ggplot(data, aes(x = Timestamp, y = total_rain)) +
    geom_line(color = "#0072B2", linewidth = 1.2) +
    labs(
      title = "Rainfall Over Time",
      subtitle = "Total rainfall across selected stations",
      x = "",
      y = "Rainfall (mm)"
    ) +
    theme_set(
      theme_minimal(base_size = 13) +
        theme(
          plot.background = element_rect(fill = "white", colour = NA),
          panel.background = element_rect(fill = "white", colour = NA),
          panel.grid = element_line(color = "#d4faff"),
          plot.title = element_text(face = "bold")
        )
    )
}



rain_station_plot <- function(data){

  ggplot(data, aes(x = reorder(rain_station, total_rain), y = total_rain, fill = total_rain)) +
    geom_col(show.legend = FALSE) +
    coord_flip() +
    scale_fill_gradient(low = "#56B4E9", high = "#0072B2") +
    labs(
      title = "Total Rainfall by Station",
      x = "",
      y = "Total Rainfall (mm)"
    ) +
    theme_set(
      theme_minimal(base_size = 13) +
        theme(
          plot.background = element_rect(fill = "white", colour = NA),
          panel.background = element_rect(fill = "white", colour = NA),
          panel.grid = element_line(color = "#d4faff"),
          plot.title = element_text(face = "bold")
        )
    )

}




time_plot <- function(data){

  ggplot2::ggplot(data, ggplot2::aes(date, total_count, color = class)) +
    ggplot2::geom_line(linewidth = 0.6) +
    ggplot2::scale_x_date(
      date_labels = "%b %d",
      guide = ggplot2::guide_axis(check.overlap = TRUE)
    ) +
    ggplot2::labs(
      title = "Daily Counts Over Time",
      x = "Date",
      y = " ",
      color = "Class"
    ) +
    theme_set(
      theme_minimal(base_size = 13) +
        theme(
          plot.background = element_rect(fill = "white", colour = NA),
          panel.background = element_rect(fill = "white", colour = NA),
          panel.grid = element_line(color = "#d4faff"),
          plot.title = element_text(face = "bold")
        )
    ) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      legend.position = "top"
    )

}




map_plot <- function(data){

  leaflet::leaflet(data) %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(
      lng = ~longitude,
      lat = ~latitude,
      popup = ~paste0("<b>", location, "</b><br>Average Count: ", round(avg_count, 1)),
      radius = ~scales::rescale(avg_count, to = c(4, 12)),
      color = "#0072B2",
      fillOpacity = 0.7
    )

}



bar_plot <- function(data){

  ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = reorder(location, mean_count),
      y = mean_count
    )
  ) +
    ggplot2::geom_col(
      fill = "#4C97FF",
      width = 0.7
    ) +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = "Top 15 Locations by Average Count",
      x = " ",
      y = "Average Count"
    ) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = 15),
      axis.text.y = ggplot2::element_text(size = 12),
      axis.text.x = ggplot2::element_text(size = 11),
      panel.grid.major.y = ggplot2::element_blank(),  # cleaner bars
      legend.position = "none"
    )+
    theme_set(
      theme_minimal(base_size = 13) +
        theme(
          plot.background = element_rect(fill = "white", colour = NA),
          panel.background = element_rect(fill = "white", colour = NA),
          panel.grid = element_line(color = "#d4faff"),
          plot.title = element_text(face = "bold")
        )
    )

}
