# Guía para un Script Bash de Configuración de Servidor

Este documento es una guía para comprender y ejecutar un script Bash que configura un servidor web Apache con MySQL y PHP. El script incluye comentarios explicativos y comandos útiles para facilitar la configuración del servidor.

## Contenido del Script par instalar pila LAMP

```bash
#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -x

# Actualizamos la lista de repositorios
apt update

# Actualizamos los paquetes del sistema
# apt upgrade -y -----------> DESCOMENTAR ESTO PARA EJECUTAR POR PRIMERA VEZ, LA "-Y" ES PARA RESPONDER YES A TODAS LAS PREGUNTAS

# Instalamos el servidor APACHE
sudo apt install apache2 -y

## Instalamos MYSQL SERVER
apt install mysql-server -y

# Instalar PHP 
sudo apt install php libapache2-mod-php php-mysql -y

# Copiamos archivo de configuración de Apache
cp ../conf/000-default.conf /etc/apache2/sites-available

# Reiniciamos el servicio Apache
systemctl restart apache2

# Copiamos el archivo de prueba de PHP
cp ../php/index.php /var/www/html

# Cambiamos usuario y propietario de var/www/html
chown -R www-data:www-data /var/www/html
```
## Pasos para Ejecutar el Script


1. Abre una terminal en tu servidor, conectandote con la clave con formato .pem

2. Crea un nuevo archivo, por ejemplo, `install_tools.sh`, y pega el contenido del script en el archivo.

3. Guarda el archivo.

4. Concede permisos de ejecución al archivo:

   ```bash
   chmod +x configuracion-servidor.sh
   ```
##### El paso final sería ejecutar el comando con sudo
```bash
sudo ./install_lamp_.sh
```

# Instalar herramientas útiles __(install_tools.sh)__

El segundo paso en este proceso de creación de una pila LAMP sería ejecutar este script para la instalación de una serie de herramientas para poder sacarle más partido al servidor.

1. Añadimos el archivo .env donde tenemos las variables de configuración
2. Actualizamos la lista de repositorios con ```apt update``` y ```apt upgrade -y```
3. Para instalar __phpmyadmin__ de forma automática (Sin tener que responder las preguntas) configuramos las respuestas de la instalación
4. Instalamos __phpmyadmin__ ```sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y```
5. Ejecutabamos las sentencias SQL para crear usuario y darle los permisos, recordamos que las variables estan en .env
6. Ahora vamos a añadir adminer, en primer lugar creariamos el directorio en /var/www/html
7. Lo instalamos desde el repositorio de github.
8. Cambiamos el propietario y grupo de la carpeta /var/www/html
9. Instalamos GoAccess -> Herramienta muy útil y que permite una opción gráfica para ver que está pasando en tu servidor
10. Para verlo en vivo (se actualiza entorno cada 5 segundos) hay que introducir el comando ```goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize```
11. Configuramos las autenticaciones y sobreescribimos el archivo 000-default.conf

# Explicación de .htaccess

##### AuthType Basic

Esta directiva especifíca el tipo de autenticación que se utilizará, en este caso es "Basic" en la cual solo pide usuario y contraseña

##### AuthName "Acceso no PERMITIDO"

Aqui se define el mensaje que aparece al iniciar sesion erroneamente

##### AuthBasicProvider file

En esta directiva se dice que para guardar las credenciales se utilizará un archivo.

##### AuthUserFile "/etc/apache2/.htpasswd"

Este será el archivo que se utilza para el paso anterior

##### Require valid-user

La directiva establece que cualquier usuario que este en el archivo __.htpasswd__ pueda acceder a la pagina o directorio