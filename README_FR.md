🇬🇧 English version available [here](README.md)
* * *
# Présentation du projet `inception`
## Description
Ce projet consiste à mettre en place une **infrastructure web containerisée** utilisant **Docker** et **Docker Compose**.

Il est prévu pour fonctionner sur **Debian Bullseye**, et à la fois le système hôte et les **images Docker** sont basés sur cette distribution afin d’assurer cohérence et stabilité.
Le développement a été réalisé à l’intérieur d’une **machine virtuelle**, offrant un environnement contrôlé et isolé.

L’infrastructure inclut un reverse proxy (**NGINX**), une application **WordPress**, et une base de données **MariaDB**, chacun fonctionnant dans des conteneurs séparés.

* * *
## Langages & Technologies

**Langages**
- Bash
- Dockerfile
- YAML

**Technologies**
- Docker & Docker Compose
- NGINX
- WordPress
- MariaDB
- Linux (Debian Bullseye)

* * *
## Concepts clés
- Images et conteneurs Docker
- Orchestration avec Docker Compose
- Isolation des services
- Volumes et persistance des données
- Variables d’environnement
- Réseau entre conteneurs
- Configuration HTTPS
- Infrastructure as code

* * *
## Environnement Système

- **OS hôte** : Debian Bullseye
- **Images Docker de base** : Debian Bullseye
- **Runtime des conteneurs** : Docker
- **Orchestration** : Docker Compose

* * *
## Architecture des Services

L’infrastructure est composée des services suivants :

**1. NGINX**
- Agit comme reverse proxy
- Gère les connexions HTTPS
- Utilise des certificats TLS

**2. WordPress**
- Application PHP-FPM
- Sert du contenu dynamique
- Connecté à la base de données MariaDB

**3. MariaDB**
- Base de données relationnelle
- Stocke les données WordPress
- Fonctionne dans son propre conteneur

Chaque service s’exécute dans un conteneur dédié et communique via un réseau Docker.
* * *
## Volumes & Persistance

Les données persistantes sont stockées à l’aide de **volumes Docker** :
- Fichiers WordPress
- Données de la base MariaDB

Cela garantit que les données sont conservées même si les conteneurs sont arrêtés ou reconstruits.
* * *
## Sécurité

- Aucun service ne s’exécute inutilement en root
- Les secrets sont gérés via des variables d’environnement
- HTTPS appliqué via NGINX
- Les conteneurs n’exposent que les ports nécessaires
* * *
## Structure du Projet
```
inception/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── mariadb/
│		│	├── conf/
│		│	├── tools/
│       │   └── Dockerfile
│       ├── nginx/
│		│	├── conf/
│       │   └── Dockerfile
│       └── wordpress/
│			├── conf/
│		 	├── tools/
│           └── Dockerfile
│  
└── Makefile
```
* * *
## Variables d’Environnement

Le projet utilise un fichier `.env` situé dans `srcs/` pour configurer les identifiants de la base de données et les paramètres WordPress.

⚠️ Le vrai fichier `.env` **ne doit pas** être commité.

Exemple générique pour démonstration :
```
# ==========================
# Configuration MariaDB
# ==========================

SQL_DATABASE=wordpress_db
SQL_USER=wordpress_user
SQL_ROOT_PASSWORD=mot_de_passe_root
SQL_PASSWORD=mot_de_passe_utilisateur
SQL_HOST=mariadb

# ==========================
# Configuration WordPress
# ==========================

WP_URL=mondomaine.local
WP_TITLE=Mon site WordPress

WP_ADMIN_USER=admin_user
WP_ADMIN_PASSWORD=mot_de_passe_admin
WP_ADMIN_EMAIL=admin@exemple.com

WP_AUTHOR_USER=author_user
WP_AUTHOR_PASS=mot_de_passe_auteur
WP_AUTHOR_EMAIL=author@exemple.com

```
* * *
## Accès à la Base de Données

Liste des commandes pour accéder manuellement au **conteneur MariaDB** et **inspecter la base** :
1. Entrer dans le conteneur **MariaDB** : `docker exec -it <nom_du_conteneur_mariadb> bash`
2. Se connecter à **MariaDB** : `mysql -u root -p`
3. Entrer le `SQL_ROOT_PASSWORD` défini dans votre `.env`.
4. Afficher les **bases de données disponibles **: `SHOW DATABASES;`, vous devriez voir :  
```
wordpress
information_schema
mysql
performance_schema
```
5. Utiliser la **base WordPress** : `USE wordpress;`
6. Lister les tables : `SHOW TABLES;`
7. **Afficher** les utilisateurs **WordPress** : `SELECT * FROM wp_users;`, vous devriez voir l’admin et l’auteur définis dans votre `.env`.
8. **Quitter MariaDB** : `exit;`
9. **Quitter le conteneur** : `exit`

* * *
## Note

⚠️ Certains chemins, noms d’utilisateur et noms de domaine dans ce projet (par exemple `/home/phwang/data` ou `phwang.42.fr`) sont spécifiques à l’environnement de développement original. Vous devez les adapter à votre configuration locale.

* * *
# Utilisation de `inception`

## **Règles du Makefile**
1. **first** comme *règle par défaut* : crée les dossiers nécessaires pour les volumes Docker (`/home/$USER/data/wordpress` et `/home/$USER/data/mariadb`) s’ils n’existent pas déjà.  
Affiche la liste des conteneurs, images, volumes et réseaux Docker.
2. **run** : construit et lance l’infrastructure Docker avec : `docker-compose -f srcs/docker-compose.yml up --build`
3. **clean** : arrête tous les conteneurs Docker en cours d’exécution.
4. **fclean** : exécute les règles *clean containers_clean images_clean volumes_clean networks_clean list*, puis `docker system prune -a`.  
Supprime également les dossiers locaux des volumes (`/home/$USER/data`)
5. **re** : *fclean* puis *first*
6. **containers_clean** : supprime tous les conteneurs Docker
7. **images_clean** : supprime toutes les images Docker
8. **volumes_clean** : supprime tous les volumes Docker
9. **networks_clean** : supprime le réseau Docker du projet (`srcs_inception`)
10. **list** : affiche les conteneurs en cours, images, volumes et réseaux Docker


* * *

## **Comment utiliser `inception`**

1. Clonez `inception` dans un dossier : `git clone https://github.com/bibickette/inception.git`
2. Accédez au dossier `inception` et créez un fichier d’environnement (`.env`)(*voir [variables d’environnement](#variables-denvironnement) pour plus de détails*)
3. Construisez et démarrez l’infrastructure avec `make run`. Cela va : **créer** les dossiers locaux nécessaires pour les **volumes** (`/home/$USER/data`), **construire les images Docker** puis **démarrer tous les conteneurs**.
4. Accédez aux services :
- **WordPress** : via `https://localhost`
- **MariaDB** : accessible en interne via le **réseau Docker** (nom du service mariadb) (*voir [accès à la base de données](#accès-à-la-base-de-données) pour plus de détails*)

* * *

*Date de validation du projet : 26 août 2025*
