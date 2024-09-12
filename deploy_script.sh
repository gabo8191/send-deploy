#!/bin/bash

PASSWORD="osboxes.org"

echo "Script started"

echo "$PASSWORD" | sudo -S apt-get update -y

if ! command -v nginx &> /dev/null
then
    echo "$PASSWORD" | sudo -S apt-get install -y nginx
    echo "Nginx installed"
fi

REPO_DIR="/var/www/html/app"
REPO_URL="https://github.com/gabo8191/test-ssh.git"
NGINX_CONF="/etc/nginx/sites-available/default"

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

echo "$PASSWORD" | sudo -S tee $NGINX_CONF > /dev/null <<EOT
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root $REPO_DIR;
    index index.html;

    server_name localhost;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOT

echo "$PASSWORD" | sudo -S nginx -t
echo "$PASSWORD" | sudo -S systemctl restart nginx

echo "The app has been deployed and Nginx is configured to serve on localhost"
