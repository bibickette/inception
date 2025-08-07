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
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
  echo "✅ Création de la base ${MYSQL_DATABASE}..."

  mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL
fi

# Arrêt de MariaDB (il redémarrera ensuite avec CMD)
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Relance finale de MariaDB en process principal
exec mysqld_safe
