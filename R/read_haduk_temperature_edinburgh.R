# To do: move this script to data prep codebase in the code_etc repo
# since runapp won't run while there's some issue with the arrange() function.

# read_haduk_temperature_edinburgh.R
# Read HadUK-Grid NetCDF temperature files and plot temperatures for City of Edinburgh
#
# Drop this script in the project root and run.
#
# Requires packages: ncdf4, here, tidyverse, lubridate
# Install with: install.packages(c("ncdf4","here","tidyverse","lubridate"))

library(ncdf4)
library(here)
library(tidyverse)
library(lubridate)

# === CONFIG ===
data_dir <- here("open_data", "temperature_HadUK_Grid")

# Choose a City of Edinburgh coordinate (change if you prefer a different point)
# This script uses a city-centre coordinate for Edinburgh:
city_name <- "Edinburgh (city centre)"
city_lat <- 55.9533    # degrees north
city_lon <- -3.1883    # degrees east (negative for west)

# If you prefer the 14 Forth St point used elsewhere in repo, set:
# city_lat <- 55.91174; city_lon <- -3.27710

# === Helper: parse time units to POSIXct/Date ===
parse_nc_time <- function(nc, time_vals) {
  tu <- ncatt_get(nc, "time", "units")$value
  if (is.null(tu)) stop("time variable has no units attribute")
  # Example units: "hours since 1800-01-01 00:00:00"
  # Extract origin and unit type
  m <- regexec("^\\s*([^ ]+) since (.+)$", tu)
  parts <- regmatches(tu, m)[[1]]
  if (length(parts) < 3) stop("Unexpected time units format: ", tu)
  unit <- parts[2]
  origin_str <- parts[3]
  # Some origins lack timezone; treat as UTC
  origin <- as.POSIXct(origin_str, tz = "UTC")
  if (is.na(origin)) {
    # try without time
    origin <- as.POSIXct(paste0(origin_str, " 00:00:00"), tz = "UTC")
  }
  if (unit %in% c("seconds", "second", "secs", "sec")) {
    times <- origin + time_vals
  } else if (unit %in% c("minutes", "minute", "mins", "min")) {
    times <- origin + time_vals * 60
  } else if (unit %in% c("hours", "hour", "hrs", "hr")) {
    times <- origin + time_vals * 3600
  } else if (unit %in% c("days", "day")) {
    times <- origin + time_vals * 86400
  } else {
    # fallback: attempt days
    times <- origin + time_vals * 86400
    warning("Unknown time unit '", unit, "'. Interpreting as days since origin.")
  }
  # Return POSIXct vector; many HadUK time points are daily so convert to Date when required.
  return(times)
}

# === Helper: extract timeseries at nearest grid cell ===
# ncfile: path, varname: e.g. "tas", "tasmax", "tasmin"
extract_point_timeseries <- function(ncfile, varname, lat0, lon0) {
  nc <- nc_open(ncfile)
  on.exit(nc_close(nc), add = TRUE)

  # Get lat/lon variables: HadUK files include 2D latitude and longitude variables
  if ("latitude" %in% names(nc$var)) {
    lat <- ncvar_get(nc, "latitude")
    lon <- ncvar_get(nc, "longitude")
  } else if ("lat" %in% names(nc$var)) {
    lat <- ncvar_get(nc, "lat")
    lon <- ncvar_get(nc, "lon")
  } else {
    # sometimes lat/lon are dimension/coord vars named differently
    lat <- tryCatch(ncvar_get(nc, "y"), error = function(e) NULL)
    lon <- tryCatch(ncvar_get(nc, "x"), error = function(e) NULL)
    if (is.null(lat) || is.null(lon)) stop("Cannot find latitude/longitude variables in ", ncfile)
  }

  # lat/lon may be 2D (x by y). We compute the nearest cell in lat/lon space.
  if (!all(dim(lat) == dim(lon))) stop("latitude/longitude dims mismatch")
  dims <- dim(lat)
  # Compute squared distance (fast) and get index of minimum
  dist2 <- (lat - lat0)^2 + (lon - lon0)^2
  idx_flat <- which.min(dist2)
  idx_xy <- arrayInd(idx_flat, .dim = dims)
  # variable dimension order for HadUK daily files: (projection_x_coordinate, projection_y_coordinate, time)
  # We'll read a single grid cell across time using start/count
  varinfo <- nc$var[[varname]]
  if (is.null(varinfo)) stop("Variable ", varname, " not present in ", ncfile)
  # Determine ordering: use varinfo$dim[[1]]$name etc, but we'll assume the spatial dims are first two and time last.
  start <- c(idx_xy[1], idx_xy[2], 1)
  count <- c(1, 1, -1)  # -1 to read to end for last dimension (time)
  # If variable has just time (unlikely here), adapt
  ndims_var <- length(varinfo$dim)
  if (ndims_var == 3) {
    vals <- ncvar_get(nc, varname, start = start, count = count)
  } else if (ndims_var == 2) {
    # e.g. monthly file might be (x,y) for a single time — but monthly mean files often still have time dim length 12
    vals <- ncvar_get(nc, varname)
    # If it's a 2D array, extract single cell
    vals <- vals[idx_xy[1], idx_xy[2]]
    vals <- as.vector(vals)
  } else {
    stop("Unexpected number of dimensions (", ndims_var, ") in variable ", varname)
  }

  # Handle _FillValue or missing_value
  fv <- ncatt_get(nc, varname, "_FillValue")$value
  if (is.null(fv)) fv <- ncatt_get(nc, varname, "missing_value")$value
  if (!is.null(fv)) vals[vals == fv] <- NA

  # Time
  time_vals <- ncvar_get(nc, "time")
  times_posix <- parse_nc_time(nc, time_vals)
  # Convert to Date if times are daily (most HadUK day files): round to Date
  dates <- as.Date(times_posix)

  tibble(
    date = dates,
    value = as.numeric(vals),
    var = varname,
    file = basename(ncfile),
    lat = lat0,
    lon = lon0
  )
}

# === Example: extract daily tasmax and tasmin for 2024 then produce plot ===
# Gather file lists (adjust patterns as needed)
daily_max_files <- list.files(data_dir, pattern = "tasmax_hadukgrid_uk_1km_day.*\\.nc$", full.names = TRUE)
daily_min_files <- list.files(data_dir, pattern = "tasmin_hadukgrid_uk_1km_day.*\\.nc$", full.names = TRUE)
monthly_mean_files <- list.files(data_dir, pattern = "tas_hadukgrid_uk_1km_mon.*\\.nc$", full.names = TRUE)

# Helper to loop and bind
extract_from_files <- function(files, varname, lat0, lon0) {
  if (length(files) == 0) {
    message("No files found for pattern for var ", varname)
    return(tibble())
  }
  # sort files to get chronological order (filename contains dates)
  files <- sort(files)
  res_list <- list()
  for (f in files) {
    try({
      res_list[[f]] <- extract_point_timeseries(f, varname, lat0, lon0)
    }, silent = TRUE)
  }
  bind_rows(res_list)
}

message("Extracting daily max files: ", length(daily_max_files), " files")
ts_max <- extract_from_files(daily_max_files, "tasmax", city_lat, city_lon)
message("Extracting daily min files: ", length(daily_min_files), " files")
ts_min <- extract_from_files(daily_min_files, "tasmin", city_lat, city_lon)
message("Extracting monthly mean files: ", length(monthly_mean_files), " files")
ts_mon <- extract_from_files(monthly_mean_files, "tas", city_lat, city_lon)

# Combine daily max/min (if present) into one DF and tidy
daily_combined <- bind_rows(
  ts_max %>% mutate(type = "tasmax"),
  ts_min %>% mutate(type = "tasmin")
) %>% arrange(date)

# Save extracted CSV(s)
if (nrow(daily_combined) > 0) {
  write_csv(daily_combined, here("edinburgh_daily_temps_point.csv"))
  message("Saved edinburgh_daily_temps_point.csv with ", nrow(daily_combined), " rows")
}
if (nrow(ts_mon) > 0) {
  write_csv(ts_mon, here("edinburgh_monthly_mean_temps_point.csv"))
  message("Saved edinburgh_monthly_mean_temps_point.csv with ", nrow(ts_mon), " rows")
}

# === Plotting examples ===
library(ggplot2)
if (nrow(daily_combined) > 0) {
  p1 <- ggplot(daily_combined, aes(x = date, y = value, color = type)) +
    geom_line(alpha = 0.7) +
    labs(title = paste0("HadUK temperatures at ", city_name),
         subtitle = paste0("Point nearest HadUK grid cell to (", city_lat, ", ", city_lon, ")"),
         x = "Date", y = "Temperature (°C)", color = "") +
    theme_minimal()
  print(p1)
}

if (nrow(ts_mon) > 0) {
  # If monthly file contains multiple month entries, compute monthly timeseries and plot
  p2 <- ggplot(ts_mon, aes(x = date, y = value)) +
    geom_line(color = "steelblue") +
    geom_point(size = 1, color = "steelblue") +
    labs(title = paste0("Monthly mean temperature (HadUK) at ", city_name),
         subtitle = paste0("Point nearest HadUK grid cell to (", city_lat, ", ", city_lon, ")"),
         x = "Date", y = "Mean temperature (°C)") +
    theme_minimal()
  print(p2)
}

# Optionally compute monthly averages from daily series (if you have daily data)
if (nrow(daily_combined) > 0) {
  monthly_from_daily <- daily_combined %>%
    filter(!is.na(value)) %>%
    mutate(month = floor_date(date, "month")) %>%
    group_by(month, type) %>%
    summarise(monthly_mean = mean(value, na.rm = TRUE), .groups = "drop")
  p3 <- ggplot(monthly_from_daily, aes(x = month, y = monthly_mean, color = type)) +
    geom_line() +
    labs(title = paste0("Monthly means computed from daily values at ", city_name),
         x = "Month", y = "Temperature (°C)") +
    theme_minimal()
  print(p3)
  write_csv(monthly_from_daily, here("edinburgh_monthly_from_daily.csv"))
  message("Saved edinburgh_monthly_from_daily.csv")
}

message("Done. If plotted in non-interactive session, save plots manually with ggsave().")
