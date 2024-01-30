#!/bin/bash
# Nombre del stack
STACK_NAME=web-app-stack
# Ruta del archivo de la plantilla
TEMPLATE_FILE=main.yml

# Desplegar el stack
aws cloudformation deploy --stack-name $STACK_NAME --template-file $TEMPLATE_FILE --capabilities CAPABILITY_IAM