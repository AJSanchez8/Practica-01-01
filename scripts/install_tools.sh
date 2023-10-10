#!/bin/bash
 
# Para mostrar los comandos que se van ejecutando
set -x

# incluimos las variables de configuracion
source .env

# Actualizamos la lista de repositorios
 apt update

# Actualizamos los paquetes del sistema
# apt upgrade -y

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


#creamos directorio apra adminer
mkdir -p /var/www/html/adminer

# Instalacion de Adminera
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer

mv /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php
