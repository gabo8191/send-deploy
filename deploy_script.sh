#!/bin/bash

# Contraseña sudo
PASSWORD="osboxes.org"

echo "Script started"

# Actualizar paquetes del sistema
echo "$PASSWORD" | sudo -S apt-get update -y

# Instalar Git si no está instalado
if ! command -v git &> /dev/null
then
    echo "$PASSWORD" | sudo -S apt-get install -y git
    echo "Git installed"
fi

# Instalar Apache si no está instalado
if ! command -v apache2 &> /dev/null
then
    echo "$PASSWORD" | sudo -S apt-get install -y apache2
    echo "Apache2 installed"
fi

# Directorio donde se alojará el repositorio
REPO_DIR="/var/www/html/app"
REPO_URL="https://github.com/gabo8191/test-ssh.git"
APACHE_CONF="/etc/apache2/sites-available/000-default.conf"

# Crear el directorio para el repositorio
sudo mkdir -p "$REPO_DIR"

# Clonar o actualizar el repositorio desde GitHub
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "$PASSWORD" | sudo -S git clone "$REPO_URL" "$REPO_DIR"
    echo "Repository cloned"
else
    echo "$PASSWORD" | sudo -S git -C "$REPO_DIR" pull origin main
    echo "Repository updated"
fi

# Agregar el directorio a la lista de directorios seguros de Git
echo "$PASSWORD" | sudo -S git config --global --add safe.directory /var/www/html/app

# Configurar Apache para servir el repositorio en localhost
echo "$PASSWORD" | sudo -S tee $APACHE_CONF > /dev/null <<EOT
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $REPO_DIR
    <Directory $REPO_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

# Establecer el ServerName para evitar advertencias
echo "$PASSWORD" | sudo -S tee -a /etc/apache2/apache2.conf > /dev/null <<EOT
ServerName localhost
EOT

# Verificar la configuración de Apache y reiniciar el servicio
echo "$PASSWORD" | sudo -S apache2ctl configtest
if [ $? -eq 0 ]; then
    echo "$PASSWORD" | sudo -S systemctl restart apache2
    echo "The repository has been deployed to $REPO_DIR and Apache is configured to serve it on localhost"
else
    echo "Apache configuration test failed. Please check the configuration."
fi
