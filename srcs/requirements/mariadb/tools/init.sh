#!/bin/bash

set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo "✅ Première initialisation de la base ${SQL_DATABASE}..."

    # Démarre MariaDB temporairement sans réseau (init)
    mysqld_safe --skip-networking --socket=/run/mysqld/mysqld.sock &
    sleep 5

    mysql -u root -p"${SQL_ROOT_PASSWORD}" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
        FLUSH PRIVILEGES;
EOSQL

    # Création du fichier .initialized pour ne pas refaire l'init
    touch /var/lib/mysql/.initialized

    # Arrêt de MariaDB temporaire
    mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
fi

echo "✅ Luckily start MariaDB..."
exec mysqld_safe

