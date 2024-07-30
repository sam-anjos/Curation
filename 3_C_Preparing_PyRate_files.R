# Load necessary packages
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tibble", quietly = TRUE)) install.packages("tibble")

library(dplyr)
library(tibble)

# List of CSV file names
files <- c("species_per_region/selected/Deinotheriidae_Eurasia.csv", 
           "species_per_region/selected/Elephantidae_Africa.csv", 
           "species_per_region/selected/Elephantidae_Eurasia.csv", 
           "species_per_region/selected/Gomphotheriidae_Africa.csv", 
           "species_per_region/selected/Gomphotheriidae_Eurasia.csv", 
           "species_per_region/selected/Gomphotheriidae_NorthAmerica.csv", 
           "species_per_region/selected/Mammutidae_Africa.csv", 
           "species_per_region/selected/Mammutidae_Eurasia.csv", 
           "species_per_region/selected/Stegodontidae_Eurasia.csv")

# Function to process a CSV file
process_file <- function(file) {
  # Read the CSV file
  df <- try(read.csv(file), silent = TRUE)
  
  # Check if df is an error
  if (inherits(df, "try-error")) {
    message(paste("Error reading file:", file))
    return()
  }
  
  # Ensure columns 2 and 5 exist before removing them
  cols_to_remove <- c(2, 5)
  if (all(cols_to_remove %in% seq_along(colnames(df)))) {
    df <- df %>%
      select(-c(2, 5))
  } else {
    message(paste("File", file, "does not have columns 2 and 5 to remove"))
  }
  
  # Rename the remaining columns
  colnames(df) <- c("taxon_names", 
                    "min.age", 
                    "max.age", 
                    "site")
  
  # Add a new column named "status" at position 2
  df <- df %>%
    add_column(status = "extinct", .before = 2)
  
  # Create a unique output file name
  output_file <- paste0("PyRate_files/", tools::file_path_sans_ext(basename(file)), "_PyRate.csv")
  
  # Save the resulting table to a new CSV file
  write.csv(df, output_file, row.names = FALSE)
}

# Apply the function to all files in the list
invisible(lapply(files, process_file))
