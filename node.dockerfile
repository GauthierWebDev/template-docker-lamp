# On récupère notre image Node
FROM node:14.21.0-alpine3.16

# On créé un utilisateur `docker` pour le container
RUN adduser docker -s /bin/sh -D docker