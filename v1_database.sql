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

-- =================================================== 

-- Tabla errores 

IF NOT EXISTS ( 
    SELECT * 
    FROM sys.objects 
    WHERE (object_id = OBJECT_ID(N'dbo.DBErrors')) 
    AND (type = 'U') 
) 
BEGIN 
    CREATE TABLE dbo.DBErrors 
    ( 
        id INT IDENTITY(1, 1) PRIMARY KEY 
        , ErrorNumber INT 
        , ErrorSeverity INT 
        , ErrorState INT 
        , ErrorProcedure VARCHAR(128) 
        , ErrorLine INT 
        , ErrorMessage NVARCHAR(4000) 
        , ErrorDate DATETIME DEFAULT GETDATE() 
    ) 
END 
GO 

-- =================================================== 

-- Carga inicial de datos de prueba 

IF NOT EXISTS ( 
    SELECT TOP 1 id 
    FROM dbo.Empleado 
) 
BEGIN 
    INSERT INTO dbo.Empleado (Nombre, Salario) 
    VALUES 
        ('Alejandro Vargas', 850000.00) 
        , ('Ana Rojas', 620000.00) 
        , ('Beatriz Mora', 710000.00) 
        , ('Carlos Jimenez', 540000.00) 
        , ('Carmen Sanchez', 480000.00) 
END 
GO
