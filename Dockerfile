FROM ubuntu

RUN apt update && apt install -y apache2

ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]

ADD ./var/www/html/ /var/www/html/
