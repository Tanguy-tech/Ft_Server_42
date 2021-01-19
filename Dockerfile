FROM debian:buster

LABEL maintainer="tbillon@student.42lyon.fr>"

#UPDATE AND UPGRADE
RUN apt-get update
RUN apt-get -y upgrade

#INSTALL MY-SQL
RUN apt-get -y install mariadb-server

#INSTALL PHP
RUN apt-get -y install php-mysql php7.3 php-fpm php-cli php-mbstring

#INSTALL NGINX
RUN apt-get -y install nginx

ADD srcs/run.sh ./
CMD bash run.sh