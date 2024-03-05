# Etapa 1: Construir a aplicação

# Use a imagem oficial do Node.js como imagem base. Escolha a versão alpine por ser mais leve.
FROM node:18.19.0 as build-stage

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar os arquivos 'package.json' e 'yarn.lock' (ou 'package-lock.json' para npm) para o diretório de trabalho
COPY ./app/package*.json ./

# Instalar as dependências do projeto
RUN npm install

# Copiar o restante dos arquivos do projeto para o diretório de trabalho
COPY ./app ./

# Construir a aplicação para produção
RUN npm run build

# Etapa 2: Servir a aplicação
EXPOSE 3000
CMD ["node", ".output/server/index.mjs"]