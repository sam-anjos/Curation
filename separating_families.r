# Pacotes necessários
library(here)
library(readr)

# Liste todos os arquivos CSV na pasta
arquivos_csv <- list.files(path = here("selected_families"), pattern = "*.csv", full.names = TRUE)

# Loop sobre cada arquivo e leia-o em um objeto diferente
for (arquivo in arquivos_csv) {
  # Extraia o nome do arquivo sem a extensão para usar como nome do objeto
  nome_objeto <- tools::file_path_sans_ext(basename(arquivo))
  # Leia o arquivo CSV diretamente para um objeto com o nome do arquivo
  assign(nome_objeto, read.csv(arquivo))
}

rm(arquivo, arquivos_csv, nome_objeto)

# Criando pasta para novos arquivos
dir.create("Families_region")

# Pasta de saída para os arquivos divididos por região
pasta_saida <- "caminho/para/sua/pasta/de/saida"  # Substitua com o caminho desejado

files <- c("Deinotheriidae.csv", "Elephantidae.csv", "Gomphotheriidae.csv", "Mammutidae.csv", "Stegodontidae.csv")

# Loop sobre cada arquivo
for (arquivo in files) {
  # Carrega o arquivo CSV
  dados <- read_csv(here("PyRate"(arquivo)  # ajuste se o separador de coluna for diferente
  
  # Obtém todas as regiões únicas no arquivo atual
  regioes <- unique(dados$region)
} 
  # Loop sobre cada região única
  for (regiao in regioes) {
    # Filtra os dados para a região atual
    dados_regiao <- dados[dados$region == regiao, ]
    
    # Nome do arquivo de saída
    nome_arquivo_saida <- file.path(here("Families_region)", paste0("dados_", regiao, ".csv"))
    
    # Salva os dados da região em um novo arquivo CSV
    write_csv(dados_regiao, nome_arquivo_saida)
    
    # Mensagem de confirmação
    cat("Dados da região", regiao, "salvos em", nome_arquivo_saida, "\n")
  }

