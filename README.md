# Configuración de Despliegue con SSH y Apache

## Descripción General

Este proyecto permite desplegar un sitio web utilizando SSH y Apache. La configuración involucra un servidor Debian configurado para manejar conexiones SSH y un cliente Linux Mint para gestionar los procesos de despliegue. El despliegue clona o actualiza un repositorio de Git y lo sirve utilizando Apache en `localhost`.

## Repositorios

- **Repositorio del Script de Despliegue**: [send-deploy](https://github.com/gabo8191/send-deploy)
- **Repositorio del Sitio Web**: [test-ssh](https://github.com/gabo8191/test-ssh)

## Configuración de SSH

1. **Puerto SSH**: El servidor SSH está configurado para usar el puerto 443. Asegúrese de que este puerto esté abierto y accesible en su servidor.
2. **Claves Autorizadas**: La autenticación basada en claves SSH está configurada en el servidor. La clave pública generada con `ssh-keygen` se ha añadido al archivo `authorized_keys` en la carpeta `.ssh` del servidor para permitir el acceso sin contraseña.

   Para generar una clave SSH en el cliente:

   ```bash
   ssh-keygen
   ```

Luego, se copia la clave pública al servidor:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub usuario@ip-del-servidor
```

## Instrucciones de Configuración

### En el Cliente Linux Mint

1. **Clonar los Repositorios**:

   - Clonar el repositorio que contiene los scripts de despliegue y el código.

     ```bash
     git clone https://github.com/gabo8191/send-deploy.git
     ```

2. **Instalar Dependencias**:

   - Navegar al directorio del proyecto e instalar las dependencias.

     ```bash
     cd send-deploy
     npm install
     ```

3. **Ejecutar el Servidor de Desarrollo**:

   - Inicia el servidor de desarrollo.

     ```bash
     npm run dev
     ```

4. **Desplegar el Sitio Web**:
   - Presionar el botón "Deploy" en la interfaz web para activar el proceso de despliegue. Esto ejecutará un script que se conectará al servidor SSH y desplegará el sitio web.

### En el Servidor Debian

1. **Configurar SSH**:

   - Asegúrese de que SSH esté configurado para usar el puerto 443 y que las claves autorizadas estén configuradas para permitir el acceso sin contraseña.

2. **Configurar Apache**:
   - Dentro del script se instala Apache y se configura para servir el sitio web desde `localhost`.

## Notas

- Asegúrese de reemplazar `"osboxes.org"` en la configuración con la contraseña de `sudo` adecuada para tu entorno.
- Verifique que Apache esté corriendo correctamente y que el repositorio se despliegue en `localhost`.
