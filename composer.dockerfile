# On récupère notre image Composer
FROM composer:2.4

# On créé un utilisateur `docker` pour le container
RUN adduser docker -s /bin/sh -D docker