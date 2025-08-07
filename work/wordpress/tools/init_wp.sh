#!/bin/bash
set -e

mkdir -p /run/php
chown root:root /run/php

# Assure-toi que le dossier wordpress existe
mkdir -p /var/www/wordpress
chown -R root:root /var/www/wordpress

cd /var/www

# Si WordPress n'est pas installé (pas de wp-config-sample.php), on le télécharge
if [ ! -f wordpress/wp-config-sample.php ]; then
  echo "📦 Téléchargement de WordPress..."
  wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -O wordpress.tar.gz
  tar -xzf wordpress.tar.gz
  rm wordpress.tar.gz
  chown -R root:root wordpress
fi

cd wordpress

# Si wp-config.php n'existe pas, on le crée à partir du sample
if [ ! -f wp-config.php ]; then
  echo "✅ Création de wp-config.php..."
  cp wp-config-sample.php wp-config.php
fi

echo "🔧 Modification des paramètres dans wp-config.php..."
sed -i "s/define( *'DB_NAME' *, *'.*' *);/define( 'DB_NAME', '${SQL_DATABASE}' );/" wp-config.php
sed -i "s/define( *'DB_USER' *, *'.*' *);/define( 'DB_USER', '${SQL_USER}' );/" wp-config.php
sed -i "s/define( *'DB_PASSWORD' *, *'.*' *);/define( 'DB_PASSWORD', '${SQL_PASSWORD}' );/" wp-config.php
sed -i "s/define( *'DB_HOST' *, *'.*' *);/define( 'DB_HOST', '${SQL_HOST}' );/" wp-config.php



# Lance php-fpm en mode foreground
exec php-fpm7.4 -F


