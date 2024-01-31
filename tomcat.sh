#!/bin/bash

# Añadir un usuario para Tomcat
useradd -m -d /opt/tomcat -U -s /bin/false tomcat

#Actualizar el sistema
apt update

#Instalar Java
apt install openjdk-17-jdk -y

#Comprobar la versión de Java
java -version

#Navegar al directorio /tmp
cd /tmp

#Descargar el archivo usando wget
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz

#Extraer el archivo que hemos descargado
tar xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1

#Cambiar el propietario del directorio y de todos sus archivos
chown -R tomcat:tomcat /opt/tomcat/

#Cambiar los permisos del directorio
chmod -R u+x /opt/tomcat/bin

#Añadir usuarios para acceder a la interfaz de administración de Tomcat
cat << 'EOF' | tee /opt/tomcat/conf/tomcat-users.xml > /dev/null
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
  <role rolename="manager-gui" />
  <user username="manager" password="manager_password" roles="manager-gui" />

  <role rolename="admin-gui" />
  <user username="admin" password="admin_password" roles="manager-gui,admin-gui" />
</tomcat-users>
EOF

#Editar el archivo de configuración del Manager
cat << 'EOF' | tee /opt/tomcat/webapps/manager/META-INF/context.xml > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache$1"/>
</Context>
EOF

#Guarda y cierra el achivo, luego repite el preceso para el Host Manager
cat << 'EOF' | tee /opt/tomcat/webapps/host-manager/META-INF/context.xml > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
</Context>
EOF

# Crear un servicio systemd para Tomcat
JAVA_HOME_PATH=$(update-java-alternatives -l | awk '{print $3}')
CATALINA_HOME="/opt/tomcat"

cat <<EOF | tee /etc/systemd/system/tomcat.service > /dev/null
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=$JAVA_HOME_PATH"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=$CATALINA_HOME"
Environment="CATALINA_HOME=$CATALINA_HOME"
Environment="CATALINA_PID=$CATALINA_HOME/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=$CATALINA_HOME/bin/startup.sh
ExecStop=$CATALINA_HOME/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Recargar el daemon de systemd
systemctl daemon-reload

# Iniciar el servicio Tomcat
systemctl start tomcat

# Comprobar el estado de Tomcat
systemctl status tomcat

# Habilitar Tomcat para iniciar con el sistema
systemctl enable tomcat
