-- Base de Datos 1 Primera Tarea Programada
-- Script: Creacion de la BD, tablas, datos y stored procedures



-- Crear BD

IF NOT EXISTS (
    SELECT name
    FROM sys.databases
    WHERE (name = 'EmpleadosDB')
)
BEGIN
    CREATE DATABASE EmpleadosDB
END
GO

USE EmpleadosDB
GO

-- ===================================================

-- Tabla errores

-- (meter aquí la tabla errores

-- ===================================================

-- Tabla empleado

IF NOT EXISTS (
    SELECT *
    FROM sys.objects
    WHERE (object_id = OBJECT_ID(N'dbo.Empleado'))
      AND (type = 'U')
)

BEGIN
    CREATE TABLE dbo.Empleado
    (
        id      INT          IDENTITY(1, 1) PRIMARY KEY
        , Nombre  VARCHAR(128) NOT NULL
        , Salario MONEY        NOT NULL
    )
END
GO

