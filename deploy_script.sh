#!/bin/bash

echo "Script started"

sudo apt-get update

sudo apt-get install -y nginx

echo "Nginx installed"

REPO_DIR="/var/www/html/app"
REPO_URL="https://github.com/gabo8191/Frontend-citas.git"
NGINX_CONF="/etc/nginx/sites-available/default"

if [ ! -d "$REPO_DIR" ]; then
  sudo git clone $REPO_URL $REPO_DIR
  echo "Repository cloned"
else
  cd $REPO_DIR
  sudo git pull origin main
  echo "Repository updated"
fi

sudo mkdir -p $REPO_DIR

sudo chown -R www-data:www-data $REPO_DIR
sudo chmod -R 755 $REPO_DIR

sudo tee $NGINX_CONF > /dev/null <<EOT
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

sudo nginx -t
sudo systemctl restart nginx

echo "The app has been deployed and Nginx is configured to serve on localhost"
