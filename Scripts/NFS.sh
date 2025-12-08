#!/bin/bash
set -e

# Cambiar el hostname
sudo hostnamectl set-hostname NFSAlexandro

sudo apt update -y
sudo apt install nfs-kernel-server wget tar libapache2-mod-php -y

# Carpeta NFS que contendrá WordPress
sudo mkdir -p /var/nfs/general

# Descargar y preparar WordPress
cd /var/nfs
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo mv wordpress/* general/
sudo rm -rf wordpress latest.tar.gz

# Permisos NFS correctos
sudo chown -R nobody:nogroup /var/nfs/general

# Exportar carpeta para los servidores web
echo "/var/nfs/general 10.0.2.134(rw,sync,no_subtree_check) 10.0.2.137(rw,sync,no_subtree_check)" | sudo tee /etc/exports

sudo exportfs -a
sudo systemctl restart nfs-kernel-server

echo "Servidor NFS configurado."
