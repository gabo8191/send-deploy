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

# Directorio donde se alojará el repositorio
REPO_DIR="$HOME/Downloads/app"
REPO_URL="https://github.com/gabo8191/test-ssh.git"

# Crear el directorio si no existe
if [ ! -d "$REPO_DIR" ]; then
    mkdir -p "$REPO_DIR"
fi

# Clonar o actualizar el repositorio desde GitHub
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone "$REPO_URL" "$REPO_DIR"
    echo "Repository cloned"
else
    cd "$REPO_DIR"
    git pull origin main
    echo "Repository updated"
fi


echo "The repository has been deployed to $REPO_DIR"
