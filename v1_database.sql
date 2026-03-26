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

-- ===================================================

-- SP: Obtener lista de empleados

IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE (object_id = OBJECT_ID(N'dbo.sp_ObtenerEmpleados'))
      AND (type = 'P')
)
BEGIN
    DROP PROCEDURE dbo.sp_ObtenerEmpleados
END
GO

CREATE PROCEDURE dbo.sp_ObtenerEmpleados
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY

        SELECT
            emp.id
            , emp.Nombre
            , emp.Salario
        FROM
            dbo.Empleado AS emp
        ORDER BY
            emp.Nombre ASC

        SET @outResultCode = 0

    END TRY
    BEGIN CATCH

        INSERT INTO dbo.DBErrors
        (
            ErrorNumber
            , ErrorSeverity
            , ErrorState
            , ErrorProcedure
            , ErrorLine
            , ErrorMessage
        )
        VALUES
        (
            ERROR_NUMBER()
            , ERROR_SEVERITY()
            , ERROR_STATE()
            , ERROR_PROCEDURE()
            , ERROR_LINE()
            , ERROR_MESSAGE()
        )

        SET @outResultCode = 50001

    END CATCH

END
GO
    
--==============================================
    
-- SP: Insertar un empleado

    IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE (object_id = OBJECT_ID(N'dbo.sp_InsertarEmpleado'))
      AND (type = 'P')
)
BEGIN
    DROP PROCEDURE dbo.sp_InsertarEmpleado
END
GO

CREATE PROCEDURE dbo.sp_InsertarEmpleado
    @inNombre      VARCHAR(128)
    , @inSalario   MONEY
    , @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    -- Pre-proceso: verificar si el nombre ya existe
    DECLARE @nombreExiste INT

    BEGIN TRY

        SELECT
            @nombreExiste = COUNT(emp.id)
        FROM
            dbo.Empleado AS emp
        WHERE
            (emp.Nombre = @inNombre)

        IF (@nombreExiste > 0)
        BEGIN
            SET @outResultCode = 50002
            RETURN
        END

        -- Transaccion al final del SP
        BEGIN TRANSACTION

            INSERT INTO dbo.Empleado
            (
                Nombre
                , Salario
            )
            VALUES
            (
                @inNombre
                , @inSalario
            )

        COMMIT TRANSACTION

        SET @outResultCode = 0

    END TRY
    BEGIN CATCH

        IF (@@TRANCOUNT > 0)
        BEGIN
            ROLLBACK TRANSACTION
        END

        INSERT INTO dbo.DBErrors
        (
            ErrorNumber
            , ErrorSeverity
            , ErrorState
            , ErrorProcedure
            , ErrorLine
            , ErrorMessage
        )
        VALUES
        (
            ERROR_NUMBER()
            , ERROR_SEVERITY()
            , ERROR_STATE()
            , ERROR_PROCEDURE()
            , ERROR_LINE()
            , ERROR_MESSAGE()
        )

        SET @outResultCode = 50001

    END CATCH

END
GO

