#!/bin/bash

PASSWORD="osboxes.org"

echo "Script started"

echo "$PASSWORD" | sudo -S apt-get update -y

if ! command -v apache2 &> /dev/null
then
    echo "$PASSWORD" | sudo -S apt-get install -y apache2
    echo "Apache2 installed"
fi

REPO_DIR="/var/www/html/app"
REPO_URL="https://github.com/gabo8191/test-ssh.git"
APACHE_CONF="/etc/apache2/sites-available/000-default.conf"

if [ ! -d "$REPO_DIR" ]; then
  echo "$PASSWORD" | sudo -S git clone $REPO_URL $REPO_DIR
  echo "Repository cloned"
else
  cd $REPO_DIR
  echo "$PASSWORD" | sudo -S git pull origin main
  echo "Repository updated"
fi

echo "$PASSWORD" | sudo -S chown -R www-data:www-data $REPO_DIR
echo "$PASSWORD" | sudo -S chmod -R 755 $REPO_DIR

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

echo "$PASSWORD" | sudo -S apache2ctl configtest
echo "$PASSWORD" | sudo -S systemctl restart apache2

echo "The app has been deployed and Apache2 is configured to serve on localhost"
