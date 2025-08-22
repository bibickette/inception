FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install mariadb-server -y 

COPY ./conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT [ "/init.sh" ]

CMD [ "mysqld_safe" ]