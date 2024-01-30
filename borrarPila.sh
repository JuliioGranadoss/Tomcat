#!/bin/bash

# Nombre del stack
STACK_NAME="web-app-stack"

# Borrar el stack
aws cloudformation delete-stack --stack-name "$STACK_NAME"
