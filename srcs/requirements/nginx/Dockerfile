FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y nginx &&\
    apt install -y openssl &&\
    # la commande suivante sert a creer le certificat SSL/TLS
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=FR/ST=Ile-de-France/L=Paris/O=phwang/CN=phwang.42.fr"

# copier le fichier nginx dans le container
COPY conf/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT [ "nginx" ]

CMD [ "-g", "daemon off;" ]