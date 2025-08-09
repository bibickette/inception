#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mkdir -p /run/mysqld
    chown mysql:mysql /run/mysqld
    echo "🛠 Initialisation de MariaDB (base système)..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

# Démarre MariaDB temporairement sans réseau (init)
    mysqld_safe --skip-networking --socket=/run/mysqld/mysqld.sock &
    sleep 5

# Initialisation de la DB si elle n'existe pas
    echo "✅ Création de la base ${SQL_DATABASE}..."

    mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

# Arrêt de MariaDB (il redémarrera ensuite avec CMD)
    mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
fi

echo "✅ Lancement de la base ${SQL_DATABASE}..."
# Relance finale de MariaDB en process principal
exec mysqld_safe
