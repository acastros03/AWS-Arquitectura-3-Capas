#!/bin/bash
set -e

# Cambiar hostname
sudo hostnamectl set-hostname WebAlexandro

sudo apt update -y
sudo apt install apache2 php libapache2-mod-php php-mysql nfs-common mariadb-client -y

# Montar NFS
sudo mkdir -p /nfs/general
sudo mount 10.0.2.127:/var/nfs/general /nfs/general
echo "10.0.2.127:/var/nfs/general /nfs/general nfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

# VirtualHost WordPress
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<EOF
<VirtualHost *:80>
    DocumentRoot /nfs/general/
    <Directory /nfs/general>
        Options +FollowSymlinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo a2dissite 000-default.conf 
sudo a2ensite wordpress.conf
sudo systemctl reload apache2

echo "WebServer 1 configurado."
