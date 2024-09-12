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

# Crear el directorio si no existe
if [ ! -d "$REPO_DIR" ]; then
    echo "$PASSWORD" | sudo -S mkdir -p "$REPO_DIR"
fi

# Clonar o actualizar el repositorio desde GitHub
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "$PASSWORD" | sudo -S git clone "$REPO_URL" "$REPO_DIR"
    echo "Repository cloned"
else
    echo "$PASSWORD" | sudo -S git -C "$REPO_DIR" pull origin main
    echo "Repository updated"
fi

# Configurar Apache para servir el repositorio en localhost
echo "$PASSWORD" | sudo -S tee /etc/apache2/sites-available/000-default.conf > /dev/null <<EOT
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

# Configurar el nombre del servidor en Apache si no está configurado
if ! grep -q "ServerName localhost" /etc/apache2/apache2.conf; then
    echo "$PASSWORD" | sudo -S sh -c 'echo "ServerName localhost" >> /etc/apache2/apache2.conf'
fi

# Verificar la configuración de Apache
echo "$PASSWORD" | sudo -S apache2ctl configtest

# Reiniciar Apache
if [ $? -eq 0 ]; then
    echo "$PASSWORD" | sudo -S systemctl restart apache2
    echo "The repository has been deployed to $REPO_DIR and Apache is configured to serve it on localhost"
else
    echo "Apache configuration test failed. Please check the configuration."
fi
