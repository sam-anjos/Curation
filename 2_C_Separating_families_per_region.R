# Install and load required packages
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("purrr", quietly = TRUE)) install.packages("purrr")

library(dplyr)
library(readr)
library(purrr)

# Create 'selected' and 'not_selected' directories if they do not exist
selected_dir <- "species_per_region/selected"
not_selected_dir <- "species_per_region/not_selected"

if (!dir.exists(selected_dir)) {
  dir.create(selected_dir, recursive = TRUE)
}

if (!dir.exists(not_selected_dir)) {
  dir.create(not_selected_dir, recursive = TRUE)
}

# List of CSV files
files <- c("selected_families/Deinotheriidae.csv", 
           "selected_families/Elephantidae.csv",
           "selected_families/Gomphotheriidae.csv",
           "selected_families/Mammutidae.csv",
           "selected_families/Stegodontidae.csv")

# Function to process each file
process_file <- function(file_path) {
  data <- read.csv(file_path)
  base_name <- tools::file_path_sans_ext(basename(file_path))
  
  # Split by region and apply selection rules
  data %>%
    group_split(region) %>%
    walk(function(region_data) {
      region_name <- unique(region_data$region)
      species_count <- length(unique(region_data$species))
      row_count <- nrow(region_data)
      
      
      if (species_count > 4 || (species_count == 4 && row_count > 100)) {
        write.csv(region_data, file = paste0(selected_dir, "/", base_name, "_", region_name, ".csv"), row.names = FALSE)
      } else {
        write.csv(region_data, file = paste0(not_selected_dir, "/", base_name, "_", region_name, ".csv"), row.names = FALSE)
      }
    })
}

# Apply the function to each file
walk(files, process_file)