# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tbillon <tbillon@student.42lyon.fr>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/20 08:33:05 by tbillon           #+#    #+#              #
#    Updated: 2021/01/22 10:24:39 by tbillon          ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="tbillon@student.42lyon.fr>"

#UPDATE AND UPGRADE
RUN apt-get update
RUN apt-get -y upgrade

#INSTALL MY-SQL
RUN apt-get -y install mariadb-server

#INSTALL PHP
RUN apt-get -y install php7.3-mysql php7.3 php7.3-fpm php7.3-cli php7.3-mbstring php7.3-common php7.3-gmp php7.3-curl php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-zip php7.3-soap php7.3-imap

#INSTALL NGINX
RUN apt-get -y install nginx

#INSTALL WGET
RUN apt-get -y install wget

#INSTALL SSL
RUN apt install openssl

COPY ./srcs/init_docker.sh ./
COPY ./srcs/run.sh ./
COPY ./srcs/nginx/nginx.conf ./tmp/nginx.conf
COPY ./srcs/phpmyadmin/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php
COPY ./srcs/wordpress/wp-config.php ./tmp/wp-config.php

EXPOSE 80 443

ENTRYPOINT ["bash", "run.sh"]