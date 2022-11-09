# Template Docker LAMP

## Ce qui est inclu dans le template
- PHP _([8.2-rc-fpm-alpine](https://hub.docker.com/_/php))_
- MariaDB _([mariadb:10.5](https://hub.docker.com/_/mariadb))_
- NodeJS _([14.21.0-alpine3.16](https://hub.docker.com/_/node))_
- Apache _([2.4-alpine](https://hub.docker.com/_/httpd))_
- Adminer _([4.8.1](https://hub.docker.com/_/adminer))_
- MailHog _([v.1.0.1](https://hub.docker.com/r/mailhog/mailhog))_
- Composer _([2.4](https://hub.docker.com/_/composer))_

---

## Configuration
> Besoin d'aller vite ? Besoin d'un projet Laravel avec Docker _(sans passer par Sail)_ ?  
Tu peux exécuter le fichier `init.sh` !  
Sinon, tu as toutes les informations pour tout faire à la main !

### Base de données
#### `docker-compose.yml`
- Définir les champs présents dans la section `environment` par les valeurs souhaitées.
#### `.env` _(Exemple utilisé : Laravel)_
Portion à éditer :
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=
```
Champs à modifier :
- `DB_HOST` :
  - Ancienne valeur : `127.0.0.1`
  - Nouvelle valeur : `db`  _(<- correspond au nom du container)_
- `DB_DATABASE` :
  - Ancienne valeur : `laravel`
  - Nouvelle valeur : Valeur donnée pour la clé `MARIADB_DATABASE` dans le fichier `docker-compose.yml`
- `DB_USERNAME` :
  - Ancienne valeur : `root`
  - Nouvelle valeur : Valeur donnée pour la clé `MARIADB_USER` dans le fichier `docker-compose.yml`
- `DB_PASSWORD` :
  - Ancienne valeur : _(vide)_
  - Nouvelle valeur : Valeur donnée pour la clé `MARIADB_PASSWORD` dans le fichier `docker-compose.yml`

---

## Gestion générale
> Si tu es passé par le fichier `./init.sh` et que tes containers Docker n'ont pas été stoppés entre temps,
> tous tes containers sont déjà opérationnels.  
> Si ce n'est pas le cas, tu peux faire les opérations ci-dessous

### Build + lancement des containers
`docker compose up -d --build`

### Lancement des containers
`docker compose up -d`

### Suppression des containers
`docker compose down`

---

## Exécutions individuelles
### Composer
`docker compose run composer <command>`  
Exemple pour création d'un projet Laravel : `docker composer run composer create-project laravel/laravel .`

### PHP
`docker compose run php <command>`  
Exemple pour artisan avec php : `docker compose run php artisan make:controller MainController`

### Node
`docker compose run node <command>`  
Exemple pour l'installation des dépendances Node : `docker compose run node npm install`

### MariaDB
`docker compose exec db mysql -u <MARIADB_USER> -p<MARIADB_PASSWORD>`  
Exemple pour la connexion avec l'utilisateur configuré par défaut du repo : `docker compose exec db mysql -u gauthierwebdev -pgauthierwebdev`  
Exemple pour la connexion avec l'utilisateur root : `docker compose exec db mysql -u root -proot`