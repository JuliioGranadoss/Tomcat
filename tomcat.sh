#!/bin/bash

#Añadimos usuario
useradd -m -d /opt/tomcat -U -s /bin/false tomcat

#Actualizar el sistema
sudo apt update

#Instalar Java
sudo apt install openjdk-17-jdk

#Comprobar la versión de Java
java -version

#El resultado debe ser similar a esto:
Output
openjdk version "17.0.9" 2023-10-17
OpenJDK Runtime Environment (build 17.0.9+9-Ubuntu-120.04)
OpenJDK 64-Bit Server VM (build 17.0.9+9-Ubuntu-120.04, mixed mode, sharing)

#Navegar al directorio /tmp
cd /tmp

#Descargar el archivo usando wget
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.20/bin/apache-tomcat-10.0.20.tar.gz

#Extraer el archivo que hemos descargado
sudo tar xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1

#Cambiar el propietario del directorio y de todos sus archivos
sudo chown -R tomcat:tomcat /opt/tomcat/

#Cambiar los permisos del directorio
sudo chmod -R u+x /opt/tomcat/bin

#Abrir archivo para modificar los usuarios de Tomcat
sudo nano /opt/tomcat/conf/tomcat-users.xml

#Añadir las siguientes líneas al archivo
<role rolename="manager-gui" />
<user username="manager" password="manager_password" roles="manager-gui" />

<role rolename="admin-gui" />
<user username="admin" password="admin_password" roles="manager-gui,admin-gui" />

#Abrir el archivo de configuración del Manager para editarlo
sudo nano /opt/tomcat/webapps/manager/META-INF/context.xml

#Comenta la definición valve
...
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catali></Context>

#Guarda y cierra el achivo, luego repite el preceso para el Host Manager
sudo nano /opt/tomcat/webapps/host-manager/META-INF/context.xml

#Obtener información sobre la ubicación de Java
sudo update-java-alternatives -l

#El resultado debe ser similar a este
Output
java-1.17.0-openjdk-amd64      1711       /usr/lib/jvm/java-1.17.0-openjdk-amd64

#Añadir las siguientes líneas
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

#Recarga el systemd para que tome conocimiento del nuevo servicio
sudo systemctl daemon-reload

#Iniciar el servicio de Tomcat
sudo systemctl start tomcat

#Verificar el estado para confirmar que todo se inició correctamente
sudo systemctl status tomcat

#El resultado sería este:
Output
● tomcat.service - Tomcat
     Loaded: loaded (/etc/systemd/system/tomcat.service; disabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-03-11 14:37:10 UTC; 2s ago
    Process: 4845 ExecStart=/opt/tomcat/bin/startup.sh (code=exited, status=0/SUCCESS)
   Main PID: 4860 (java)
      Tasks: 15 (limit: 1132)
     Memory: 90.1M
     CGroup: /system.slice/tomcat.service
             └─4860 /usr/lib/jvm/java-1.11.0-openjdk-amd64/bin/java -Djava.util.logging.config.file=/opt/tomcat/conf/lo>

#Habilitar que Tomcat se inicie con el sistema
sudo systemctl enable tomcat

#Permitir el tráfico al siguiente puerto:
sudo ufw allow 8080

#En el navegador, podemos acceder a Tomcat navegando a la dirección IP de tu servidor
http://your_server_ip:8080