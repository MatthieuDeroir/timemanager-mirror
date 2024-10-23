FROM node:lts-alpine

RUN npm install -g http-server
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Utiliser la variable d'environnement PORT, avec une valeur par défaut de 8080 si non définie
ENV PORT=8080

EXPOSE $PORT

# Utiliser la forme shell pour que la variable d'environnement soit interprétée
CMD http-server dist -p $PORT
