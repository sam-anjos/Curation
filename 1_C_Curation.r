install.packages("here")
library(here)

# Carregando os dados
raw_data <- read.csv(here("Original.csv"))

# Invertendo a ordem das colunas 4 e 5
raw_data <- raw_data[, c(1,2, 5, 4, 6, 3)]

# Organizando os dados por espécie em ordem alfabética e mantendo a ordem da família
ordered_data <- raw_data[order(raw_data$family, raw_data$species, raw_data$region), ]

# Substituindo os espaços por underscores na primeira coluna
ordered_data$species <- gsub(" ", "_", ordered_data$species)

# Renomeando as regiões
ordered_data$region <- gsub("(Eastern|Northern|Southern|Middle|Western) Africa", "Africa", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("(Eastern|Northern|Southern|Western) Europe", "Eurasia", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("(Eastern|Northern|Southern|Western|Central|South-Eastern) Asia", "Eurasia", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("Northern America", "North America", ordered_data$region, ignore.case = TRUE)

ordered_data <- subset(ordered_data, region != "South America")

ordered_data <- subset(ordered_data, region != "Central America")

# Substituindo vírgulas por pontos em duas colunas específicas
ordered_data$maximum.age <- gsub(",", ".", ordered_data$maximum.age)
ordered_data$minimum.age <- gsub(",", ".", ordered_data$minimum.age)

# Transformando a coluna "site" em um fator
ordered_data$Site <- as.integer(factor(ordered_data$Site, levels = unique(ordered_data$Site)))

# Criando um novo dataframe excluindo as regiões "América do Sul" e "América Central"
final_data <- subset(ordered_data, region != "Southern America" & region != "Central America")

# Salvar os dados ordenados e limpos em um novo arquivo (substitua 'novo_arquivo.csv' pelo nome desejado)
write.csv(final_data, file = "cleaned_data.csv", row.names = FALSE)

# Carregando os data_pre_selection (substitua 'seu_arquivo.csv' pelo nome do seu arquivo CSV)
data_pre_selection <- read.csv("cleaned_data.csv")

# Calculando o nÃºmero de linhas Ãºnicas por famÃ­lia na coluna de espÃ©cies
sp_per_family <- tapply(data_pre_selection$species, data_pre_selection$family, function(x) length(unique(x)))

# Identificando as famÃ­lias com menos de 9 linhas Ãºnicas
families_to_keep <- names(sp_per_family[sp_per_family >= 9])

# Criando uma nova tabela apenas com as famÃ­lias que possuem 9 ou mais linhas Ãºnicas
selected_data <- data_pre_selection[data_pre_selection$family %in% families_to_keep, ]

# Escrevendo a nova tabela em um novo arquivo CSV (substitua 'novo_arquivo.csv' pelo nome desejado)
write.csv(selected_data, file = "selected_families_data.csv", row.names = FALSE)

# Carregando os dados (substitua 'seu_arquivo.csv' pelo nome do seu arquivo CSV)
selected_families_data <- read.csv("selected_families_data.csv")

# Substituindo os espaços por underscores na primeira coluna
selected_families_data$species <- gsub(" ", "_", selected_families_data$species)

selected_families_data$region <- gsub(" ", "", selected_families_data$region)

# Dividindo o dataframe com base na coluna de famílias e ordenando por região
frames_list <- split(selected_families_data, selected_families_data$family)

# Ordenando cada subconjunto por região
frames_list <- lapply(frames_list, function(subset) subset[order(subset$region), ])

# Criando pasta para novos arquivos
dir.create("selected_families")

# Verifica se a pasta foi criada
if (file.exists("selected_families")) {
  cat("Pasta criada com sucesso!")
} else {
  cat("Falha ao criar a pasta.")
}

# Salvando cada subconjunto de dados em arquivos separados
for (i in names(frames_list)) {
  nome_arquivo <- paste("selected_families/", i, ".csv", sep = "")
  write.csv(frames_list[[i]], file = nome_arquivo, row.names = FALSE)
}
