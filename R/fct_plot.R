#' plot
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
rain_time_plot <- function(data) {

  ggplot(data, aes(x = Month, y = total_rain)) +
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
          plot.title = element_text(face = "bold"),
          axis.title.y = element_text(angle = 45, vjust = 0.5)

        )
    )
}



rain_station_plot <- function(data) {

  ggplot(data, aes(
    x = reorder(rain_station, total_rain),
    y = total_rain,
    fill = total_rain,
    text = paste0(
      "<b>Station:</b> ", rain_station, "<br>",
      "<b>Total Rainfall:</b> ", round(total_rain, 1), " mm"
    )
  )) +
    geom_col(show.legend = FALSE) +
    coord_flip() +
    scale_fill_gradient(low = "#56B4E9", high = "#0072B2") +
    labs(
      title = "Total Rainfall by Station",
      x = "",
      y = "Total Rainfall (mm)"
    ) +
    theme_minimal(base_size = 13) +
    theme(
      plot.background = element_rect(fill = "white", colour = NA),
      panel.background = element_rect(fill = "white", colour = NA),
      panel.grid = element_line(color = "#d4faff"),
      plot.title = element_text(face = "bold")
    )
}




time_plot <- function(data) {

  ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = date,
      y = total_count,
      color = class
    )
  ) +
    ggplot2::geom_line(linewidth = 1, alpha = 0.9) +
    ggplot2::scale_x_date(
      date_labels = "%Y",
      expand = ggplot2::expansion(mult = c(0.01, 0.01)),
      guide = ggplot2::guide_axis(check.overlap = TRUE)
    ) +
    ggplot2::scale_color_brewer(palette = "Set2") +
    ggplot2::labs(
      title = "Daily Counts Over Time",
      x = "",
      y = "Count",
      color = "Class"
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      plot.title       = ggplot2::element_text(face = "bold", size = 16),
      axis.text.x      = ggplot2::element_text(angle = 45, hjust = 1),
      legend.position  = "top",
      # legend.title     = ggplot2::element_text(face = "bold"),
      plot.background  = ggplot2::element_rect(fill = "white", colour = NA),
      panel.grid.minor = ggplot2::element_blank(),
      axis.title.y     = ggplot2::element_text(angle = 0, vjust = 0.5)   # <--- HERE
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


bar_plot <- function(data) {

  ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = reorder(location, mean_count),
      y = mean_count,
      text = paste0(
        "<b>Location:</b> ", location, "<br>",
        "<b>Average Count:</b> ", round(mean_count, 1)
      )
    )
  ) +
    ggplot2::geom_col(
      fill = "#4C97FF",
      width = 0.65
    ) +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = "Top 15 Locations by Average Count",
      x = "",
      y = "Average Count"
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = 16),
      axis.text.y = ggplot2::element_text(size = 12),
      axis.text.x = ggplot2::element_text(size = 12),
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "white", colour = NA)
    )
}
