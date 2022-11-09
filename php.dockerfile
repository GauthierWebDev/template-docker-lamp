# On récupère notre image PHP
FROM php:8.2-rc-fpm-alpine

# On créé un utilisateur `docker` pour le container
RUN adduser docker -s /bin/sh -D docker

# Copie des dossiers/fichiers sur le conteneur
RUN mkdir -p /var/www/html

# Installation extensions PDO pour MySQL et zip
RUN docker-php-ext-install pdo pdo_mysql

# On copie le fichier de configuration de PHP
COPY ./.docker/php/php.ini /usr/local/etc/php/

# On rend le container php accessible au port 9000
EXPOSE 9000

# On prépare le container pour exécuter les commandes PHP
ENTRYPOINT [ "php" ]
CMD [ "command" ]