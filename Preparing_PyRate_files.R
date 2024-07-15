install.packages("here")
library(here)

# Defina o caminho relativo para a pasta contendo os arquivos CSV
caminho_pasta <- here("selected_families")

# Liste todos os arquivos CSV na pasta
arquivos_csv <- list.files(path = here("selected_families"), pattern = "*.csv", full.names = TRUE)

# Loop sobre cada arquivo e leia-o em um objeto diferente
for (arquivo in arquivos_csv) {
  # Extraia o nome do arquivo sem a extensão para usar como nome do objeto
  nome_objeto <- tools::file_path_sans_ext(basename(arquivo))
  # Leia o arquivo CSV
  dados <- read.csv(arquivo)
  # Atribua o data.frame a um objeto com o nome do arquivo
  assign(nome_objeto, dados)
}

rm(dados)

files <- list(Deinotheriidae, Elephantidae, Gomphotheriidae, Mammutidae, Stegodontidae)

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
renomear_colunas <- function(df, novos_nomes) {
  colnames(df) <- novos_nomes
  return(df)
}


# Aplicando a função a todos os data frames na lista
files <- lapply(files, renomear_colunas, new_names)
''
# Criando pasta para novos arquivos
dir.create("PyRate_files")

# Definindo os nomes dos arquivos CSV
nomes_arquivos <- paste0("PyRate_files/", c("Deinotheriidae","Elephantidae","Gomphotheriidae","Mammutidae","Stegodontidae"), "_PyRate", ".csv")

# Função para salvar cada data frame em um arquivo CSV
salvar_em_csv <- function(df, nome_arquivo) {
  write.csv(df, file = nome_arquivo, row.names = FALSE)
}

# Usando lapply para salvar todos os data frames em arquivos CSV
mapply(salvar_em_csv, files, nomes_arquivos)
