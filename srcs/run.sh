# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    run.sh                                             :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tbillon <tbillon@student.42lyon.fr>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/20 10:31:13 by tbillon           #+#    #+#              #
#    Updated: 2021/01/22 09:40:48 by tbillon          ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #


#Open right access
chown -R www-data /var/www/* #permet un changement de proprietaire -> autorise www-data a ecrire
chmod -R 755 /var/www/* #ouvre les droits complet au proprietaire, sans ecriture aux groupes et autres

#Generate website folder
mkdir /var/www/mywebsite && touch /var/www/mywebsite/index.php #génère la creation d'un nouveau dossier contenant les dossiers du site web 
echo "<?php phpinfo(); ?>" >> /var/www/mywebsite/index.php

#Configurate Self-Signed SSL Certificate
cd /etc/nginx
mkdir ssl
cd ssl/
openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/mywebsite.pem -keyout /etc/nginx/ssl/mywebsite.key -subj '//C=FR/ST=Auvergne-Rhone-Alpes/L=Lyon/O=42shcool/OU=tbillon/CN=mywebsite/emailAdress=tbillon@student.42lyon.fr'

#Configurate NGINX
cd ../../../
mv ./tmp/nginx.conf /etc/nginx/sites-available/mywebsite
ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled/mywebsite #Crée un lien symbolic via -sect	
rm -rf /etc/nginx/sites-enabled/default

#Configurate MYSQL
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password #Crée uen base de donne mysql avec MariaDB nommé wordpress (-u custom user --ski-password saute l'etape mdp)
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password #Donne tous le acces (WITJ GRANT OPTION, a user can edit the permission for other users)
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password #Pour etre capable de se connecter avec un mot de passe
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password #Facultatif car Mysql remarque les changements quand il y en a et recharge les GRANTS (autorisations)

#Download and setup Wordpress
wget https://wordpress.org/latest.tar.gz #wget télécharge la derniere version de wordpress
tar -xvzf latest.tar.gz #Décompresse le fichier precedement téléchargé (flags x-extract v-verbose z-gzip-gunzip f-file use archive file)
mv wordpress/ /var/www/mywebsite #Crée un dossier wordpress_files dans le dossier mywebsite
mv ./tmp/wp-config.php /var/www/mywebsite/wordpress_files #Déplace le fichier de config php pour wordpress dans le dossier crée precedement

#Download and setup PhpMyadmin
mkdir /var/www/mywebsite/phpmyadmin #Crée un dossier phpmyadmin dans le dossier mywebsite
wget -c https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz #Télécharge la derniere version de PhpMyAdmin(flag -c -> continue de telecharger un fichier commence precedement)
tar -xvf phpMyAdmin-5.0.4-all-languages.tar.gz --strip-components 1 -C /var/www/mywebsite/phpmyadmin #Extrait fichier téléchargé (--strip-components 1 extrai le fichier puis l'envoie dans le parametre 1 du path suivant, ici /phpmyadmin)
cd tmp
mv phpmyadmin.inc.php /var/www/mywebsite/phpmyadmin/config.inc.php #Déplace config.myconfig.php en créant un fichier config.inc.php dans le dossier phpmyadmin

service php7.3-fpm start
service nginx restart
#bash