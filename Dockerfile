# Usa a imagem oficial do PostgreSQL versão 15 como base
# Esta imagem já vem com o servidor PostgreSQL pronto a usar
FROM postgres:15

# Atualiza a lista de pacotes do sistema (apt)
# e instala a extensão pg_cron específica para PostgreSQL 15
RUN apt update && \
    apt install -y postgresql-15-cron && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# - apt update → atualiza os repositórios disponíveis
# - apt install → instala pacotes no sistema
# - postgresql-15-cron → adiciona suporte a jobs agendados no PostgreSQL
# - apt clean → remove cache de pacotes
# - rm -rf /var/lib/apt/lists/* → reduz tamanho final da imagem