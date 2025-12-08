#!/bin/bash
set -e

# Establecer nombre de host
sudo hostnamectl set-hostname BalanceadorAlexandro

# Actualizar paquetes e instalar dependencias
sudo apt update -y
sudo apt install apache2 certbot python3-certbot-apache -y

# Habilitar los módulos necesarios para el balanceador de carga
sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests proxy_connect ssl headers rewrite slotmem_shm certbot python3-certbot-apache

# Reiniciar Apache para aplicar cambios
sudo systemctl restart apache2

# Crear certificado auto-firmado si no existe
if [[ ! -f /etc/ssl/certs/labs-iberotech.crt || ! -f /etc/ssl/private/labs-iberotech.key ]]; then
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/labs-iberotech.key \
        -out /etc/ssl/certs/labs-iberotech.crt \
        -subj "/CN=labs-iberotech.ddns.net"
fi

# Establecer permisos seguros para las claves SSL
sudo chmod 600 /etc/ssl/private/labs-iberotech.key

# Configuración HTTP → HTTPS (Redirección desde HTTP a HTTPS)
sudo tee /etc/apache2/sites-available/load-balancer.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName labs-iberotech.ddns.net
    Redirect permanent / https://labs-iberotech.ddns.net/
</VirtualHost>
EOF

# Configuración HTTPS con balanceo de carga
sudo tee /etc/apache2/sites-available/load-balancer-ssl.conf > /dev/null <<EOF
<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerName labs-iberotech.ddns.net

    SSLEngine On
    SSLCertificateFile /etc/ssl/certs/labs-iberotech.crt
    SSLCertificateKeyFile /etc/ssl/private/labs-iberotech.key

    # Configuración del balanceador de carga
    <Proxy "balancer://mycluster">
        BalancerMember http://10.0.2.33:80
        BalancerMember http://10.0.2.51:80
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass "/" "balancer://mycluster/"
    ProxyPassReverse "/" "balancer://mycluster/"
</VirtualHost>
</IfModule>
EOF

# Deshabilitar el sitio por defecto y habilitar los sitios de balanceo
sudo a2dissite 000-default.conf
sudo a2ensite load-balancer.conf
sudo a2ensite load-balancer-ssl.conf

# Verificar la sintaxis de Apache
sudo apache2ctl configtest

# Recargar Apache para aplicar cambios
sudo systemctl reload apache2

# Habilitar y reiniciar Apache para que se inicie automáticamente y se apliquen los cambios
sudo systemctl enable apache2
sudo systemctl restart apache2

echo "Balanceador configurado con SSL (auto-firmado si Let's Encrypt no funcionó)."
