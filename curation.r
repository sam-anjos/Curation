# Carregando os dados
raw_data <- read.csv("C:/Users/sam_a/OneDrive/Documentos/Mestrado/Projeto/curadoria/Original.csv")

# Invertendo a ordem das colunas 4 e 5
raw_data <- raw_data[, c(1,2, 5, 4, 6, 3)]

# Organizando os dados por espécie em ordem alfabética e mantendo a ordem da família
ordered_data <- raw_data[order(raw_data$family, raw_data$species, raw_data$region), ]

# Renomeando as regiões
ordered_data$region <- gsub("(Eastern|Northern|Southern|Middle|Western) Africa", "Africa", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("(Eastern|Northern|Southern|Western) Europe", "Eurasia", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("(Eastern|Northern|Southern|Western|Central|South-Eastern) Asia", "Eurasia", ordered_data$region, ignore.case = TRUE)

ordered_data$region <- gsub("Northern America", "North America", ordered_data$region, ignore.case = TRUE)

# Substituindo vírgulas por pontos em duas colunas específicas
ordered_data$maximum.age <- gsub(",", ".", ordered_data$maximum.age)
ordered_data$minimum.age <- gsub(",", ".", ordered_data$minimum.age)

# Transformando a coluna "site" em um fator
ordered_data$Site <- as.integer(factor(ordered_data$Site, levels = unique(ordered_data$Site)))

# Criando um novo dataframe excluindo as regiões "América do Sul" e "América Central"
final_data <- subset(ordered_data, region != "Southern America" & region != "Central America")

# Salvar os dados ordenados e limpos em um novo arquivo (substitua 'novo_arquivo.csv' pelo nome desejado)
write.csv(final_data, file = "cleaned_data.csv", row.names = FALSE)
