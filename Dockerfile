FROM ubuntu:latest

MAINTAINER VICSOFT

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV DEBIAN_FRONTEND=noninteractive

RUN export RUNLEVEL=1

COPY ./ficheros-docker/ejecuta.sh /

USER root

RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install apache2 -y

RUN apt-get install ufw -y
#RUN ufw allow 'Apache'

COPY ./ficheros-docker/fqdn.conf /etc/apache2/conf-available
RUN a2enconf fqdn

RUN apt-get update && apt-get upgrade -y

RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update
RUN apt-get install php7.2 -y
RUN apt-get install php7.2-common php7.2-mysql php7.2-xml php7.2-xmlrpc php7.2-curl php7.2-gd php7.2-imagick php7.2-cli php7.2-dev php7.2-imap php7.2-mbstring php7.2-opcache php7.2-soap php7.2-zip php7.2-intl -y

RUN apt-get update && apt-get install vim -y

COPY ./ficheros-docker/ssl/certificate.ca.crt /etc/ssl/private
COPY ./ficheros-docker/ssl/www.regalonatural.es.crt /etc/ssl/private
COPY ./ficheros-docker/ssl/www.regalonatural.es.key /etc/ssl/private
COPY ./ficheros-docker/000-default.conf /etc/apache2/sites-available
COPY ./ficheros-docker/default-ssl.conf /etc/apache2/sites-available

RUN a2enmod ssl
RUN a2ensite default-ssl

EXPOSE 80 
EXPOSE 443 

RUN chmod 700 /ejecuta.sh
CMD [ "/ejecuta.sh" ]

