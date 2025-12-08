#!/bin/bash
set -e

# Cambiar el hostname del servidor DB
sudo hostnamectl set-hostname DBAlexandro

# Actualizar el sistema e instalar MariaDB
sudo apt update -y
sudo apt install mariadb-server -y

# Crear base de datos y usuarios con privilegios para servidores web
sudo mysql <<EOF
CREATE DATABASE alexwordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

# Crear el usuario para el servidor Web 1 (IP: 10.0.2.33)
CREATE USER 'alexandro'@'10.0.2.134' IDENTIFIED BY 'alexpass';
GRANT ALL PRIVILEGES ON alexwordpress.* TO 'alexandro'@'10.0.2.33';

# Crear el usuario para el servidor Web 2 (IP: 10.0.2.51)
CREATE USER 'alexandro'@'10.0.2.137' IDENTIFIED BY 'alexpass';
GRANT ALL PRIVILEGES ON alexwordpress.* TO 'alexandro'@'10.0.2.51';

# Aplicar los cambios
FLUSH PRIVILEGES;
EOF

# Configurar MariaDB para escuchar en la IP privada del servidor DB (10.0.3.249)
sudo sed -i 's/^bind-address.*/bind-address = 10.0.3.249/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Reiniciar MariaDB para que los cambios tomen efecto
sudo systemctl restart mariadb

# Verificar el estado de MariaDB
sudo systemctl status mariadb

# Habilitar y arrancar el servicio de MariaDB
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Confirmar que la base de datos y los usuarios fueron creados correctamente
echo "Servidor MariaDB configurado correctamente. Ahora puede ser accedido por los servidores web."
