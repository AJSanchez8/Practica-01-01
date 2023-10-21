#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando
set -x

# incluimos las variables de configuracion
source .env

# Actualizamos la lista de repositorios
 apt update

# Actualizamos los paquetes del sistema
# apt upgrade -y
#-----------------------------------------------------------------------------------------------------
#Configuramos las respuesta de instalacion de phpmyadmin
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections

# Instalar phpmyadmin
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y


# Ejecutamos las sentencias SQL
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%'"


#creamos directorio para adminer
mkdir -p /var/www/html/adminer

# Instalacion de Adminera
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer

mv /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

# Cambiar permisos de propietario y el grupo de www-data
chown -R www-data:www-data /var/www/html

# sido tail -f [nombre del archivo] muestra por ej los logs mientras pasan(si lo hacemos de /var/log/apache2/access.log)

#-----------------------------------------------------------------------------------------------------
# Instalacion GoAccess
sudo apt install goaccess -y

# Creamos directorio
sudo mkdir -p /var/www/html/stats

#  Para ver el HTML en vivo
goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize

# Configuramos la autenticacion basica
 htpasswd -bc /etc/apache2/.htpasswd $STATS_USERNAME $STATS_PASSWORD

 # Copiamos archivos de configuracion de apache
 # cp ../conf/000-default-STATS.conf /etc/apache2/sites-available/000-default.conf
cp ../conf/000-default-htaccss.conf /etc/apache2/sites-available/000-default.conf
 
# Copiamos el archivo .htaccess en /var/www/html/stats/
cp ../htaccess/.htaccess /var/www/html/stats/

 # reiniciamos
systemctl restart apache2