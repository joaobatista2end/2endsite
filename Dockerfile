# Etapa 1: Construir a aplicação

# Use a imagem oficial do Node.js como imagem base. Escolha a versão alpine por ser mais leve.
FROM node:lts-alpine as build-stage

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar os arquivos 'package.json' e 'yarn.lock' (ou 'package-lock.json' para npm) para o diretório de trabalho
COPY package*.json ./
COPY yarn.lock ./

# Instalar as dependências do projeto
RUN yarn install

# Copiar o restante dos arquivos do projeto para o diretório de trabalho
COPY . .

# Construir a aplicação para produção
RUN yarn build

# Etapa 2: Servir a aplicação

# Usar a imagem Nginx alpine para servir a aplicação
FROM nginx:stable-alpine as production-stage

# Copiar os arquivos de build da etapa anterior para o diretório de servir do Nginx
COPY --from=build-stage /app/.output/public /usr/share/nginx/html

# Expõe a porta 80 para que o contêiner possa comunicar-se com o mundo exterior
EXPOSE 80

# Iniciar o Nginx e manter o processo em execução
CMD ["nginx", "-g", "daemon off;"]
