# Despliegue de Infraestructura en AWS en 3 Capas

Este documento describe el proceso paso a paso para desplegar una infraestructura en AWS, configurando una VPC con subredes públicas y privadas, así como las instancias necesarias para un sistema de balanceo de carga, web, NFS y base de datos.

## Índice

1. [Crear VPC](#-crear-vpc)
2. [Crear Subredes](#-crear-subredes)
3. [Crear Internet Gateway](#-crear-internet-gateway)
4. [Crear Tablas de Enrutamiento](#-crear-tablas-de-enrutamiento)
5. [Crear Grupos de Seguridad](#-crear-grupos-de-seguridad)
6. [Lanzar Instancias](#-lanzar-instancias)
7. [Instrucciones de uso](#7-instrucciones-de-uso)
8. [Comprobación](#-comprobación)

## 📋 Crear VPC

1. **Buscador AWS** → **VPC** → **Crear VPC**
   - **Nombre**: `Alexandro-VPC`
   - **CIDR IPv4**: `10.0.0.0/16`
     
![Crear VPC](Imagenes/Crear_VPC.png)

![Crear VPC](Imagenes/Crear_VPC_2.png)

![Crear VPC](Imagenes/Crear_VPC_3.png)

## 🖧 Crear Subredes

1. **VPC** → **Subredes** → **Crear subred**
   - **Nombre**: `Publica`
   - **Subred CIDR IPv4**: `10.0.1.0/24`
  
![Crear Subredes](Imagenes/Crear_Subredes.png)

2. **VPC** → **Subredes** → **Crear subred**
   - **Nombre**: `Privada Web y NFS`
   - **Subred CIDR IPv4**: `10.0.2.0/24`

![Crear Subredes](Imagenes/Crear_Subredes_2.png)

3. **VPC** → **Subredes** → **Crear subred**
   - **Nombre**: `Privada BD`
   - **Subred CIDR IPv4**: `10.0.3.0/24`
  
![Crear Subredes](Imagenes/Crear_Subredes_3.png)

## 🌐 Crear Internet Gateway

1. **VPC** → **Puerta de enlace de internet** → **Crear Gateway de internet**

![Crear Internet Gateway](Imagenes/Crear_Gateway.png)
   
2. **VPC** → **Internet Gateways** → **Crear Gateway NAT**

![Crear Internet Gateway](Imagenes/Crear_Gateway_2.png)

## 🔄 Crear Tablas de Enrutamiento

1. **VPC** → **Crear Tablas de enrutamiento**
   - **Nombre**: `Tabla_enru_publica`
   - **VPC**: Selecciona la VPC creada en el paso anterior

![Crear Tablas de Enrutamiento](Imagenes/Crear_Tabla_Enrutamiento_2.png)

2. **VPC** → **Crear Tablas de enrutamiento**
   - **Nombre**: `Tabla_enru_privada`
   - **VPC**: Selecciona la VPC creada en el paso anterior
  
![Crear Tablas de Enrutamiento](Imagenes/Crear_Tabla_Enrutamiento.png)

## 🔐 Crear Grupos de Seguridad

1. **VPC** → **Grupos de seguridad** → **Crear grupo de seguridad**
   - **Balanceador**

![Crear Grupos de Seguridad](Imagenes/GS-Balanceador.png)

2. **Web**

![Crear Grupos de Seguridad](Imagenes/GS-Web.png)

3. **NFS**

![Crear Grupos de Seguridad](Imagenes/GS-NFS.png)

4. **Base de Datos**

![Crear Grupos de Seguridad](Imagenes/GS-BD.png)

## 🚀 Lanzar Instancias

1. **Balanceador**: Lanzar la instancia del balanceador de carga.

![Lanzar Instancias](Imagenes/Instancia-Balanceador.png)

![Lanzar Instancias](Imagenes/Instancia-Balanceador_2.png)

2. **NFS**: Lanzar la instancia de NFS.

![Lanzar Instancias](Imagenes/Instancia-NFS.png)

![Lanzar Instancias](Imagenes/Instancia-NFS_2.png)

3. **Web1 y Web2**: Lanzar las instancias de servidores web.

![Lanzar Instancias](Imagenes/Instancia-Web_1_y_2.png)

![Lanzar Instancias](Imagenes/Instancia-Web_1_y_2-2.png)

4. **BD**: Lanzar la instancia de base de datos.

![Lanzar Instancias](Imagenes/Instancia-BD.png)

![Lanzar Instancias](Imagenes/Instancia-BD-2.png)

## 7. Instrucciones de uso

A continuación se detallan los pasos necesarios para poner en marcha la infraestructura y acceder correctamente al CMS WordPress.

---

### 7.1 Encender las instancias en AWS
1. Accede a la consola de AWS y entra en el servicio **EC2**.
2. Comprueba que las instancias **Balanceador**, **Web1**, **Web2**, **NFS** y **MariaDB** están en estado **running**.
3. Si alguna instancia está detenida, selecciónala y pulsa **Start Instance**.

---

### 7.2 Verificación de la conectividad interna
1. Conéctate al **Balanceador** mediante SSH.
2. Comprueba la conectividad interna haciendo `ping` a las IP privadas de:
   - Web1  
   - Web2  
   - Servidor NFS
3. Desde los servidores web, verifica que puedes conectarte al servidor **MariaDB** (por ejemplo, usando `mysql -h <IP-Privada> -u usuario -p`).

---

### 7.3 Acceder al CMS WordPress
1. Una vez todas las instancias estén funcionando, abre un navegador web.
2. Introduce:
   - El **dominio** configurado, o  
   - La **IP pública del balanceador**.
3. Si configuraste certificados SSL, accede mediante:  
   **https://tudominio.com**

---

### 7.4 Instalación inicial de WordPress
1. Al acceder por primera vez, WordPress mostrará el **asistente de instalación**.
2. Introduce los datos solicitados:
   - Nombre de la base de datos  
   - Usuario y contraseña  
   - Host de la base de datos (IP privada de MariaDB)
3. Configura el nombre del sitio, usuario administrador y contraseña.

---

### 7.5 Acceso al panel de administración
Una vez completada la instalación, accede al panel de administración desde:

http://tu-dominio-o-ip/wp-admin


Desde ahí podrás:
- Gestionar usuarios  
- Instalar plugins  
- Añadir temas  
- Administrar el contenido del sitio



## ✅ Comprobación

![Comprobación](Imagenes/Comprobacion.png)

- [Sitio Web](https://labs-iberotech.ddns.net/)
