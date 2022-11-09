#!/bin/sh

createInformation() {
  echo "\e[1;33m$1\e[0m"
}

createInput() {
  printf '\e[32m↳ '
}

createDockerizedLaravelApp() {
  sudo rm -rf ./src ./db
  mkdir ./src ./db

  createInformation "\nInitialisation du projet en cours..."

  createInformation "\nRécupération des images..."
  docker compose pull -q
  createInformation "Récupération des images terminée"

  createInformation "\nModification du fichier docker-compose.yml pour la connexion à la base de données..."
  sed -i \
    -e "s/\(DB_HOST\):/\1=db/" \
    -e "s/\(MARIADB_USER\):.*/\1: $MARIADB_USER/" \
    -e "s/\(MARIADB_PASSWORD\):.*/\1: $MARIADB_PASSWORD/" \
    -e "s/\(MARIADB_ROOT_SECRET\):.*/\1: $MARIADB_ROOT_SECRET/" \
    -e "s/\(MARIADB_ROOT_PASSWORD\):.*/\1: $MARIADB_ROOT_PASSWORD/" \
    -e "s/\(MARIADB_DATABASE\):.*/\1: $MARIADB_DATABASE/" \
    ./docker-compose.yml
  createInformation "Modification du fichier docker-compose.yml pour la connexion à la base de données terminée"

  createInformation "\nCréation et lancement des containers..."
  docker compose up -d --build --quiet-pull
  createInformation "Création et lancement des containers terminé"

  createInformation "\nMise en place de l'application Laravel..."
  docker compose run composer create-project laravel/laravel . -q
  createInformation "Mise en place de l'application Laravel terminée"

  createInformation "\nInstallation des dépendances PHP..."
  docker compose run composer install -q
  createInformation "Installation des dépendances PHP terminée"

  createInformation "\nInstallation des dépendances Node..."
  docker compose run node npm install --silent
  createInformation "Installation des dépendances Node terminée"

  createInformation "\nModification du fichier .env pour la connexion à la base de données..."
  sed -i \
    -e "s/\(DB_HOST\)=.*/\1=db/" \
    -e "s/\(DB_USERNAME\)=.*/\1=$MARIADB_USER/" \
    -e "s/\(DB_PASSWORD\)=.*/\1=$MARIADB_PASSWORD/" \
    -e "s/\(DB_DATABASE\)=.*/\1=$MARIADB_DATABASE/" \
    ./src/.env
  createInformation "Modification du fichier .env pour la connexion à la base de données terminée"

  createInformation "\nAjout de la permission d'écriture sur le répertoire src..."
  sudo chmod -R o+w ./src
  createInformation "Ajout de la permission d'écriture sur le répertoire src terminé"

  createInformation "\nInitialisation terminée !"
}

setDatabaseVariables() {
  createInformation "\nMARIADB_USER"
  createInput
  read MARIADB_USER

  createInformation "\nMARIADB_PASSWORD"
  createInput
  read MARIADB_PASSWORD

  createInformation "\nMARIADB_ROOT_SECRET"
  createInput
  read MARIADB_ROOT_SECRET

  createInformation "\nMARIADB_ROOT_PASSWORD"
  createInput
  read MARIADB_ROOT_PASSWORD

  createInformation "\nMARIADB_DATABASE"
  createInput
  read MARIADB_DATABASE

  createInformation "\nRécapitulatif :"
  createInformation "\e[0m\e[32m↳ MARIADB_USER=$MARIADB_USER"
  createInformation "\e[0m\e[32m↳ MARIADB_PASSWORD=$MARIADB_PASSWORD"
  createInformation "\e[0m\e[32m↳ MARIADB_ROOT_SECRET=$MARIADB_ROOT_SECRET"
  createInformation "\e[0m\e[32m↳ MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD"
  createInformation "\e[0m\e[32m↳ MARIADB_DATABASE=$MARIADB_DATABASE"
  createInformation "\nValider ces valeurs ? \e[3m(y/N)"
  createInput
  read CONFIRM

  if [ "$CONFIRM" = "y" ]; then
    createDockerizedLaravelApp
    break
  else
    abortDockerizedProject
  fi
}

abortDockerizedProject() {
  createInformation "\nInitialisation du projet annulée"
  exit 0
}

initDockerizedProject() {
  sudo printf ""
  createInformation "Initialiser un projet Laravel avec Docker ? \e[3m(y/N)"
  createInput
  read shouldInitDockerizedProject

  if [ $shouldInitDockerizedProject = "y" ]; then
    setDatabaseVariables
  else
    abortDockerizedProject
  fi
}

initDockerizedProject