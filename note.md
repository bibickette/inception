# Inception
si probleme douverture a cause du kvm:
    sudo rmmod kvm_amd       
    sudo rmmod kvm

# dockerignore
Le fichier .dockerignore fonctionne un peu comme un .gitignore, mais pour Docker. Il sert à indiquer quels fichiers ou dossiers ne doivent pas être copiés dans l'image Docker quand tu construis ton image avec docker build.
🧠 Pourquoi l'utiliser ?

Quand tu fais un build Docker, tout ce qui est dans ton dossier (le build context) est envoyé au daemon Docker.
Si tu as des fichiers inutiles ou volumineux (logs, .git, node_modules...), tu ralentis ton build, alourdis ton image, et exposes potentiellement des secrets.


Voici un fichier .dockerignore typique :

.git/
.gitignore
node_modules/
*.log
*.env
__pycache__/
Dockerfile~

Cela évite de copier :

    le dossier .git (inutile dans l'image)

    des fichiers de config inutiles

    des caches Python

    des fichiers temporaires
    

✅ Avantages de .dockerignore :

    Construction plus rapide

    Image plus légère

    Moins de risques de fuite de données sensibles

    Meilleures pratiques de sécurité et performance


4️⃣ Les variables SQL_DATABASE, SQL_USER, SQL_PASSWORD, SQL_HOST

Ces variables viennent de ton .env (ou de ton docker-compose.yml).
Elles doivent correspondre à ce que tu as défini dans ton conteneur MariaDB.

Exemple dans ton .env :

SQL_DATABASE=wordpress
SQL_USER=wp_user
SQL_PASSWORD=wp_pass
SQL_HOST=mariadb

Et dans ton docker-compose.yml :

services:
  mariadb:
    environment:
      - MYSQL_DATABASE=${SQL_DATABASE}
      - MYSQL_USER=${SQL_USER}
      - MYSQL_PASSWORD=${SQL_PASSWORD}

5️⃣ À quoi sert la modification de wp-config.php ?

Elle sert à lier ton WordPress à la base de données MariaDB.
Sans ça, WordPress ne saura pas où se connecter.
En gros :

    DB_NAME = nom de la base créée dans MariaDB

    DB_USER / DB_PASSWORD = identifiants SQL (créés dans le conteneur MariaDB)

    DB_HOST = nom du service MariaDB dans docker-compose (ex: mariadb), pas localhost

💡 C’est cette connexion qui permet à WordPress de stocker ses articles, utilisateurs, réglages, etc.


1️⃣ “HTTPS enforced via NGINX” → ça veut dire quoi exactement ?

Enforced = imposé / forcé / obligatoire

Donc :

HTTPS enforced via NGINX
veut dire
Toutes les connexions sont obligatoirement redirigées ou servies en HTTPS.

Concrètement dans ton projet Inception, ça signifie que :

Le serveur NGINX écoute en 443 (TLS)

Les connexions HTTP (port 80) sont redirigées vers HTTPS

Les certificats SSL sont configurés

Les communications entre client et serveur sont chiffrées

Version plus claire pour ton README

Au lieu de :

HTTPS enforced via NGINX

Tu peux écrire :

HTTPS is enforced through NGINX configuration, ensuring that all client connections are secured using TLS.

Ou version plus simple :

All external connections are served over HTTPS using NGINX and TLS certificates.



# 🎯 Le but principal de ce script est :
# 👉 Créer une base de données SQL et un utilisateur associé, automatiquement, au démarrage du container MariaDB.

# ✅ Ce que le script fait concrètement :
# Démarre MariaDB
# Crée une base de données
# Crée un utilisateur avec un mot de passe
# Donne à cet utilisateur les droits sur la base
# Modifie le mot de passe du compte root
# Recharge les droits
# Redémarre MariaDB proprement

# 🧠 Pourquoi on le fait ?
# Parce que MariaDB démarre vide par défaut : pas de base, pas d’utilisateur (sauf root)
# WordPress (ou tout autre app) a besoin d’une base + un utilisateur pour se connecter
# Ça rend ton container automatisé et réutilisable sur n'importe quelle machine

# ✅ Résumé simple pour tes notes :
# # Script d'init MariaDB

# 🎯 Objectif :
# - Créer une base SQL automatiquement
# - Créer un utilisateur avec mot de passe
# - Donner les droits à cet utilisateur
# - Éviter de faire ça à la main à chaque fois

# 📦 Important pour :
# - WordPress
# - phpMyAdmin
# - Toute app qui utilise une base

# 📁 Le script est lancé au démarrage du container

#!/bin/bash
# La commande service permet de démarrer MySQL avec la commande associée.
service mysql start;

# demande de créer une table si elle n’existe pas déjà, du nom de la variable d’environnement SQL_DATABASE, indiqué dans mon fichier .env qui sera envoyé par le docker-compose.yml.
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# crée l’utilisateur SQL_USER s’il n’existe pas, avec le mot de passe SQL_PASSWORD , toujours à indiquer dans le .env
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

# donne les droits à l’utilisateur SQL_USER avec le mot de passe SQL_PASSWORD pour la table SQL_DATABASE
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# change les droits root par localhost, avec le mot de passe root SQL_ROOT_PASSWORD
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Plus qu’à rafraichir tout cela pour que MySQL le prenne en compte.
mysql -e "FLUSH PRIVILEGES;"

# Il ne nous reste plus qu’à redémarrer MySQL pour que tout cela soit effectif !
# Arrête proprement MySQL
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

# Redémarre MySQL proprement
exec mysqld_safe
