# Usa a imagem oficial do PostgreSQL versão 15 como base
# Esta imagem já vem com o servidor PostgreSQL pronto a usar
FROM postgres:15

# Atualiza a lista de pacotes do sistema (apt)
# e instala a extensão pg_cron específica para PostgreSQL 15
RUN apt update && \
    apt install -y postgresql-15-cron

# - apt update → atualiza os repositórios (lista de software disponível)
# - apt install → instala pacotes no sistema
# - postgresql-15-cron → pacote que adiciona suporte a jobs (cron) dentro do PostgreSQL
# - -y → aceita automaticamente a instalação (sem pedir confirmação)