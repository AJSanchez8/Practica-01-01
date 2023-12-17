#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -x

# Incluimos las variables de configuracion
source .env

# Actualizamos la lista de repositorios
apt update

# Actualizamos los paquetes del sistema
# apt upgrade -y

# Configuramos las respuestas de la instalación de phpMyAdmin
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections

#------------------------------------------------------------------------------------------------------------------

# Instalamos phpMyAdmin
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

# Ejecutamos las sentencias SQL
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%'"

# Instalacion de adminer
# Creamos un directorio par Adminer
mkdir -p /var/www/html/adminer

# Descargamos Adminer
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer

# Renombramos Adminer
mv /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

# Cambiar el propietario y el grupo a www-data
chown -R www-data:www-data /var/www/html

#-----------------------------------------------------------------------------------------------------------

# Instalación de GoAccess
apt install goaccess -y

#Creamos un directorio para la estadistica de Goaccess.
mkdir -p /var/www/html/stats

#Ejecutamos goaccess en segundo plano.
goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize

# Configuramos la autenticacion básica
htpasswd -bc /etc/apache2/.htpasswd $STATUS_USERNAME $STATS_PASSWORD

# Copiamos el archivo de configuracion de apache
#cp ../conf/000-default-stats.conf /etc/apache2/sites-available/000-default.conf

# Copiamos el archivo de configuracion de apache
cp ../conf/000-default-htaccess.conf /etc/apache2/sites-available/000-default.conf

#Copiamos el archivo .htaccess en /var/www/html/stats
cp ../htaccess/.htaccess /var/www/html/stats

#Reiniciamos el servicio de apache
systemctl restart apache2