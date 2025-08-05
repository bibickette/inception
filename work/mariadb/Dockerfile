FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install mariadb-server -y && \
    mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && chmod 777 /run/mysqld

COPY ./conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT [ "/usr/local/bin/init.sh" ]
