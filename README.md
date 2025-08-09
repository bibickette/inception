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