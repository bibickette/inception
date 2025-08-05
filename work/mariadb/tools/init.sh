#!/bin/bash

set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🛠 Initialisation de MariaDB (base système)..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Démarre MariaDB temporairement sans réseau (init)
mysqld_safe --skip-networking --socket=/run/mysqld/mysqld.sock &
sleep 5

# Initialisation de la DB si elle n'existe pas
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
  echo "✅ Création de la base ${SQL_DATABASE}..."

  mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL
fi

# Arrêt de MariaDB (il redémarrera ensuite avec CMD)
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Relance finale de MariaDB en process principal
exec mysqld_safe
