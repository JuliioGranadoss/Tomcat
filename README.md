# Instalación de Tomcat en EC2

Este proyecto proporciona scripts y plantillas para facilitar la instalación de Apache Tomcat en instancias EC2 de AWS.

## Instrucciones de Uso

Siga estos pasos para instalar Tomcat en una instancia EC2:

1. Clona este repositorio: `git clone https://github.com/tu-usuario/tu-repositorio.git`
2. Accede al directorio: `cd tu-repositorio`
3. Ejecuta el script de instalación: `./install_tomcat.sh`
4. Utiliza la plantilla de EC2 para lanzar instancias con Tomcat.

## Requisitos del Sistema

- AWS CLI instalado y configurado
- Acceso a la consola de AWS para crear instancias EC2

## Configuración Adicional

Antes de ejecutar el script, asegúrate de configurar las siguientes variables de entorno:

- `AWS_ACCESS_KEY_ID`: Tu ID de clave de acceso de AWS
- `AWS_SECRET_ACCESS_KEY`: Tu clave de acceso secreta de AWS

## Interacción con CloudFormation

Puedes utilizar los siguientes scripts para interactuar con CloudFormation y gestionar tus recursos de AWS de forma automatizada:

### Script de Despliegue (`stack.sh`)

Este script crea una nueva pila de CloudFormation en tu cuenta de AWS. Utiliza el AWS CLI para enviar una solicitud de creación de pila a CloudFormation. La solicitud incluye el nombre de la pila y la ubicación del archivo de plantilla YAML que describe los recursos que deseas crear. Además, puedes especificar parámetros como el nombre de la clave SSH y el tipo de instancia EC2 que deseas lanzar. Una vez ejecutado, CloudFormation intentará crear los recursos especificados en la plantilla.

### Script de Eliminación (`borrarPila.sh`)

Este script elimina una pila de CloudFormation existente en tu cuenta de AWS. Utiliza el AWS CLI para enviar una solicitud de eliminación de pila a CloudFormation, especificando el nombre de la pila que deseas eliminar. CloudFormation se encargará de eliminar todos los recursos asociados con la pila de manera controlada.

Estos scripts te permiten automatizar la gestión de tus recursos en AWS, proporcionando una forma rápida y conveniente de crear y eliminar pilas de CloudFormation, lo que facilita el despliegue y la limpieza de tus entornos de desarrollo y producción.
