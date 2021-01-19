CREATE DATABASE ft_server;

GRANT ALL PRIVILEGES ON ft_server.* TO 'root'@'localhost';

FLUSH PRIVILEGES;

UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user='root';