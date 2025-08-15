#!/bin/bash
set -e

mkdir -p /run/php
chown www-data:www-data /run/php

# Si WordPress n'est pas installé (pas de wp-config-sample.php), on le télécharge
if [ ! -f /var/www/wordpress/wp-config-sample.php ]; then
    # Assure-toi que le dossier wordpress existe
  mkdir -p /var/www/wordpress
  chown -R www-data:www-data /var/www/wordpress
  chmod -R 755 /var/www/wordpress

  cd /var/www
  echo "📦 Téléchargement de WordPress..."
  wget https://fr.wordpress.org/wordpress-6.8.2-fr_FR.tar.gz -O wordpress.tar.gz
  tar -xzf wordpress.tar.gz
  rm wordpress.tar.gz
  chown -R www-data:www-data wordpress

  # Création et modification de wp-config.php uniquement ici
  echo "✅ Configuration du fichier wp-config.php..."
  cp wordpress/wp-config-sample.php wordpress/wp-config.php

  sed -i "s/define( *'DB_NAME' *, *'.*' *);/define( 'DB_NAME', '${SQL_DATABASE}' );/" wordpress/wp-config.php
  sed -i "s/define( *'DB_USER' *, *'.*' *);/define( 'DB_USER', '${SQL_USER}' );/" wordpress/wp-config.php
  sed -i "s/define( *'DB_PASSWORD' *, *'.*' *);/define( 'DB_PASSWORD', '${SQL_PASSWORD}' );/" wordpress/wp-config.php
  sed -i "s/define( *'DB_HOST' *, *'.*' *);/define( 'DB_HOST', '${SQL_HOST}' );/" wordpress/wp-config.php

  sleep 5
  
  echo "⚙️ Installation initiale de WordPress..."
  wp core install \
    --path=wordpress \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
  
fi

echo "✅ Luckily start php-fpm"
# Lance php-fpm en mode foreground
exec php-fpm7.4 -F


