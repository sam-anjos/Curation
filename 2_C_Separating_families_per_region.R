# Instalar e carregar pacotes necessários
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("purrr", quietly = TRUE)) install.packages("purrr")

library(dplyr)
library(readr)
library(purrr)

# Criar a pasta 'species_per_region' se ela não existir
output_dir <- "species_per_region"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}


# Lista de arquivos CSV
files <- c("selected_families/Deinotheriidae.csv", 
           "selected_families/Elephantidae.csv",
           "selected_families/Gomphotheriidae.csv",
           "selected_families/Mammutidae.csv",
           "selected_families/Stegodontidae.csv")

# Função para processar cada arquivo
process_file <- function(file_path) {
  data <- read.csv(file_path)
  base_name <- tools::file_path_sans_ext(basename(file_path))
  data %>%
    group_split(region) %>%
    walk(~ write.csv(.x, file = paste0(output_dir, "/", base_name, "_", unique(.x$region), ".csv"), row.names = FALSE))
}

# Aplicar a função a cada arquivo
walk(files, process_file)