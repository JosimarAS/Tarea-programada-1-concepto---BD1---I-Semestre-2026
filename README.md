# Tarea-programada-1-concepto---BD1---I-Semestre-2026
Prueba de concepto para conectar una base de datos a un programa con funcionalidades simples y que corra en web



# Manual de ejecución:


Descargar los documentos del git

Descargar y conectar a SQLServer

Conectar en SQLServer Management Studio a localhost

Abrir v1_database.sql como nuevo query (con las credenciales si se quiere conectar a la API) y ejecutar la consulta



----------------------------------------------------------------------------------------------------------------------------------

# Para las credenciales (que se pegarían al final del query sql) hay un archivo adicional (credenciales.txt) que sirve para acceder a la BD.



# Malabares en el SQL Server Configuration Manager y Servicios de Windows:

Como Windows es bastante prohibitivo, hay que tocar algunas cosillas del sistema.
Lo primero es ir a Servicios (el programa de sistema de servicios de Windows), buscar SQL Server Browser --> click derecho --> propiedades, y en "Tipo de inicio" hay que ponerle "Manual" --> "Aplicar" y "Aceptar", y luego nuevamente click derecho --> iniciar

Luego, hay que abrir el SQL Server Configuration Manager, y en SQL Server Network Configuration --> Protocols for MSSQLSERVER --> Click derecho y enable a "Named Pipes" y a "TCP/IP"

Por último, en ese mismo sitio (SQL Server Configuration Manager) entrar a SQL Server Services y darle click derecho y restart a "SQL Server (MSSQLSERVER)

Listo, con eso en teoría debería de estar correcto


-------------------------------------------------------------------------------------------------------------------------------------


# Ejecutar esto en la consola del proyecto:

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
npm init -y
npm install express cors mssql
node Server.js

Entras a https://localhost:3000, y con eso debería de haber conectado correctamente a la BD


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------


# Sobre conectar a más personas a la BD

Hay que seguir ese mismo procedimiento (para quien vaya a hostear la BD y el servidor) y luego, se debe instalar una VPN virtual para conectar ambas personas a la misma "red"

 En nuestro caso, usamos ZeroTier, uno de nosotros se creó una cuenta y accedió al servicio, y con el ID de la red de la persona, se conecto al otro a esa misma red (a través de aprobar y autorizar las conexiones).

 Por último, la otra persona bajó del Git el html, y le cambió el URL del enlace al enlace con la IP de la red del VPN virtual. Con eso, al correr el html, la persona tenía a la BD.

 Si por algún motivo da algún error, bastaría con tocar el Servicios de Windows y/o el SQL Server Configuration Manager en ese otro dispositivo también.
