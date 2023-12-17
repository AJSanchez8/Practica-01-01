#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -ex

# Actualizamos la lista de repositorios
apt update

# Actualizamos los paquetes del sistema
# apt upgrade -y

# Instalamos el servidor web Apache
apt install apache2 -y1

# Instalamos MySQL Server
apt install mysql-server -y

# Instalamos PHP
apt install php libapache2-mod-php php-mysql -y

# Reiniciamos el servicio de Apache
systemctl restart apache2

# Copiamos el archivo de configuracion de Apache
cp ../conf/000-default.conf /etc/apache2/sites-available

# Copiamos el archivo de prueba de PHP
cp ../php/index.php /var/www/html

# Cambiamos el usuario y el propietario del directorio /var/www/html
chown -R www-data:www-data /var/www/html