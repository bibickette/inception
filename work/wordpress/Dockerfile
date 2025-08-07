FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y php php-fpm php-mysql curl wget mariadb-client net-tools

# RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /tmp && \
#     tar -xzf /tmp/wordpress-6.0-fr_FR.tar.gz -C /var/www && \
#     rm /tmp/wordpress-6.0-fr_FR.tar.gz && \
#     chown -R www-data:www-data /var/www/wordpress

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/init_wp.sh /init_wp.sh

RUN chmod +x /init_wp.sh

# Exposition du port PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/init_wp.sh"]