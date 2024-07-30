if (!requireNamespace("here", quietly = TRUE)) install.packages("here")

library(here)

# Creating the 'curated_data' folder if it does not exist
if (!dir.exists("curated_data")) {
  dir.create("curated_data")
}

# Loading the data
raw_data <- read.csv(here("Original.csv"))

# Reversing the order of columns 4 and 5
raw_data <- raw_data[, c(1,2, 5, 4, 6, 3)]

# Organizing the data by species in alphabetical order while maintaining family order
ordered_data <- raw_data[order(raw_data$family, raw_data$species, raw_data$region), ]

# Replacing spaces with underscores in the first column
ordered_data$species <- gsub(" ", "_", ordered_data$species)

# Renaming regions
ordered_data$region <- gsub("(Eastern|Northern|Southern|Middle|Western) Africa", "Africa", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("(Eastern|Northern|Southern|Western) Europe", "Eurasia", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("(Eastern|Northern|Southern|Western|Central|South-Eastern) Asia", "Eurasia", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("Northern America", "North America", ordered_data$region, ignore.case = TRUE)

# Removing the South and Central America regions

ordered_data <- subset(ordered_data, region != "South America")

ordered_data <- subset(ordered_data, region != "Central America")

# Replacing commas with periods in two specific columns
ordered_data$maximum.age <- gsub(",", ".", ordered_data$maximum.age)

ordered_data$minimum.age <- gsub(",", ".", ordered_data$minimum.age)

# Converting the "site" column to a factor
ordered_data$Site <- as.integer(factor(ordered_data$Site, levels = unique(ordered_data$Site)))

# Saving the ordered and cleaned data to a new file
write.csv(ordered_data, file = here("curated_data/cleaned_data.csv"), row.names = FALSE)

# Calculating the number of unique rows per family in the species column
sp_per_family <- tapply(ordered_data$species, ordered_data$family, function(x) length(unique(x)))

# Identifying families with fewer than 9 unique rows
families_to_keep <- names(sp_per_family[sp_per_family >= 9])

# Creating a new table with only families that have 9 or more unique rows
selected_data <- ordered_data[ordered_data$family %in% families_to_keep, ]

# Writing the new table to a new CSV file
write.csv(selected_data, file = here("curated_data/selected_data.csv"), row.names = FALSE)

# Replacing spaces with underscores in the first column
selected_data$species <- gsub(" ", "_", selected_data$species)

selected_data$region <- gsub(" ", "", selected_data$region)

# Splitting the dataframe based on the family column and sorting by region
frames_list <- split(selected_data, selected_data$family)

# Sorting each subset by region
frames_list <- lapply(frames_list, function(subset) subset[order(subset$region), ])

# Saving each subset of data to separate files
for (i in names(frames_list)) {
  file_name <- here(paste("selected_families/", i, ".csv", sep = ""))
  write.csv(frames_list[[i]], file = file_name, row.names = FALSE)
}
