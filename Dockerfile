# Utiliser l'image de base officielle Node.js pour la construction
FROM node:16 AS build

# Créer un répertoire de travail pour le frontend
WORKDIR /app

# Copier package.json et package-lock.json pour installer les dépendances
COPY package*.json ./

# Installer les dépendances du frontend
RUN npm install

# Copier tout le code source du frontend
COPY . .

# Créer l'application React en mode production
RUN npm run build

# Utiliser une image Nginx pour servir les fichiers statiques
FROM nginx:alpine

# Copier les fichiers construits dans le répertoire nginx
COPY --from=build /app/build /usr/share/nginx/html

# Exposer le port 80 pour servir l'application frontend
EXPOSE 80

# Lancer le serveur Nginx
CMD ["nginx", "-g", "daemon off;"]

