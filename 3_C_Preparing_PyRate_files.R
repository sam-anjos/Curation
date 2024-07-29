if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
library(here)

# Defina o caminho relativo para a pasta contendo os files CSV
folder_path <- here("species_per_region/selected")

# Liste todos os files CSV na pasta
csv_files <- list.files(path = here("species_per_region/selected"), pattern = "*.csv", full.names = TRUE)

# Loop sobre cada file e leia-o em um objeto diferente
for (file in csv_files) {
  # Extraia o nome do file sem a extensão para usar como nome do objeto
  object_names <- tools::file_path_sans_ext(basename(file))
  # Leia o file CSV
  data <- read.csv(file)
  # Atribua o data.frame a um objeto com o nome do file
  assign(object_names, data)
}

rm(data)

files <- list(Deinotheriidae_Africa, Deinotheriidae_Eurasia, Elephantidae_Africa, Elephantidae_Eurasia, Gomphotheriidae_Africa, Gomphotheriidae_Eurasia, Gomphotheriidae_NorthAmerica, Mammutidae_Eurasia, Stegodontidae_Eurasia)

files <- lapply(files, function(df) df[,c(-2,-5)])

add_status_column <- function(df) {
  df <- cbind(df[, 1, drop = FALSE], status = "extinct", df[, -1])
  return(df)
}

# Aplicando a função para todos os data frames na lista
files <- lapply(files, add_status_column)

# Definindo os novos nomes das colunas
new_names <- c("taxon_names", "status", "min.age", "max.age", "site")

# Função para renomear as colunas de um data frame
rename_columns <- function(df, novos_nomes) {
  colnames(df) <- novos_nomes
  return(df)
}


# Aplicando a função a todos os data frames na lista
files <- lapply(files, rename_columns, new_names)

# Criando pasta para novos files
dir.create("PyRate_files")

# Definindo os nomes dos files CSV
file_names <- paste0("PyRate_files/", c("Deinotheriidae_Africa", "Deinotheriidae_Eurasia", "Elephantidae_Africa", "Elephantidae_Eurasia", "Gomphotheriidae_Africa", "Gomphotheriidae_Eurasia", "Gomphotheriidae_NorthAmerica","Mammutidae_Eurasia","Stegodontidae_Eurasia"), "_PyRate", ".csv")

# Função para salvar cada data frame em um file CSV
save_in_csv <- function(df, nome_file) {
  write.csv(df, file = nome_file, row.names = FALSE)
}

# Usando lapply para salvar todos os data frames em files CSV
mapply(save_in_csv, files, file_names)
