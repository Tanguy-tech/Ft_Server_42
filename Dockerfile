# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tbillon <tbillon@student.42lyon.fr>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/20 08:33:05 by tbillon           #+#    #+#              #
#    Updated: 2021/01/20 10:32:49 by tbillon          ###   ########lyon.fr    #
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

ADD ./srcs/config.myconfig.php ./
ADD ./srcs/init_docker.sh ./
ADD ./srcs/nginx.conf ./
ADD ./srcs/run.sh ./
ADD ./srcs/wp-config.php ./

CMD bash run.sh