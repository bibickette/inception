FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y php php-fpm php-mysql wget curl mariadb-client && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/init_wp.sh /init_wp.sh
RUN chmod +x /init_wp.sh

# Exposition du port PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/init_wp.sh"]