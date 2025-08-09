FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y php php-fpm php-mysql curl wget mariadb-client

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/init_wp.sh /init_wp.sh
RUN chmod +x /init_wp.sh

# Exposition du port PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/init_wp.sh"]