/*===================================== Stored Procedures =================================*/
CREATE DATABASE bdStored;
GO

USE bdStored;
GO

CREATE PROCEDURE usp_Mensaje_Saludar
AS
BEGIN
    PRINT 'Hola Mndo Transact sql'
END;
GO

-- Ejecutar
EXECUTE usp_Mensaje_Saludar;
GO


CREATE PROCEDURE usp_Mensaje_Saludar2
AS
BEGIN
    PRINT 'Hola Mndo ING en TI';
END;
GO

EXEC usp_Mensaje_Saludar2;

CREATE OR ALTER PROC usp_Mensaje_Saludar3

AS
BEGIN
    PRINT 'Hola Mndo ENTORNOS VIRTUALES Y Negocios DIGITALES';
END;
GO

-- ELIMAR UN SP

DROP PROCEDURE usp_Mensaje_Saludar3;
GO

EXEC usp_Mensaje_Saludar3;
GO

-- Crear SP que muestre la fecha actual del sistema 
CREATE or ALTER PROC usp_Servidor_FechaActual

AS 
BEGIN
    SELECT GETDATE () AS [FECHA DEL SISTEMA]
END 
GO

EXEC usp_Servidor_FechaActual;


-- CREAR UN SP QUE MUESTRE EL NOMBRE DE LA BASE DE DATOS (BD_NAME)

CREATE OR ALTER PROC spu_Dbname_Get
AS
BEGIN
    SELECT
        HOST_NAME() AS [MACHINE],
        SUSER_NAME() AS [SQLUSER],
        SYSTEM_USER AS [SYSTEMUSER],
        DB_NAME() AS [DATABASE NAME],
        APP_NAME() AS [APPLICATION];
END;
GO

EXEC spu_Dbname_Get
GO

/* ========================================== Stored Procedures con Parámetros ==========================================*/

CREATE OR ALTER PROC usp_Persona_Saludar
    @nombre VARCHAR(50)  -- PARÁMETRO DE ENTRADA
AS
BEGIN
    PRINT 'Hola ' + @nombre;
END;
GO

EXEC usp_Persona_Saludar 'Israel';
EXEC usp_Persona_Saludar 'Artemio';
EXEC usp_Persona_Saludar 'Iraís';
EXEC usp_Persona_Saludar @nombre = 'Bryan';

DECLARE @name VARCHAR(50);
SET @name = 'Yael';

EXEC usp_Persona_Saludar @name

/*TO DO: EJEMPLOS CON CONSULTAS, VAMOS A CREAR UNA TABLA DE CLIENTES BASADA EN LA TABLA DE CUSTOMERS
DE NORTHWIND*/
SELECT CustomerID, CompanyName
INTO Customers
FROM NORTHWND.dbo.Customers;
GO

--Crear un SP que busque un cliente en especifico 
CREATE OR ALTER PROC spu_Customer_buscar
@id NCHAR(10)
AS
BEGIN

    SET @id = TRIM(@id)

    IF NOT LEN(@id)<=O OR LEN(@id)>5
    BEGIN
        PRINT('ÑEl id debe estar en el rango de 1 a 5 de tamaño');
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
    BEGIN
        SELECT CustomerID AS [NUMERO], CompanyName AS [Cliente] 
        FROM Customers
        WHERE CustomerID = @id;
    END
    ELSE
        PRINT 'El cliente no existe en la bd'
END;
GO

SELECT *
FROM Customers 
WHERE CustomerID = 'ANTON';

EXEC spu_Customer_buscar 'yuttt';

SELECT 1
FROM NORTHWND.dbo.Categories
WHERE NOT EXISTS(
SELECT 1
FROM Customers
WHERE CustomerID = 'ANTONi');

-- Ejercisios : Cear un sp que reciba un numero y que verifique que no sea negativo,
-- Si es negativo imprimir valor no valido y si no multiplicarlo ór 5 y mostrarlo
--Para mostrarlo usar un select
CREATE OR ALTER PROCEDURE usp_numero_multiplicar
@number INT
AS
BEGIN
    IF @number<=0
    BEGIN
    PRINT 'El numero no puede ser negativo ni cero'
    RETURN;
    END

    SELECT (@number * 5) AS [OPERACION]
END;

EXEC usp_numero_multiplicar -34;
EXEC usp_numero_multiplicar 0;
EXEC usp_numero_multiplicar 5;
GO
--EJERCISIO 2: Crear un sp que reciba un nombre y lo imprima en mayusculas 

CREATE OR ALTER PROCEDURE usp_nombre_mayusculas
@name VARCHAR(15)
AS
BEGIN
    SELECT UPPER(@name) AS [NAME]
END;
GO

EXEC usp_nombre_mayusculas 'albin';
GO
--=========================================Parametros de salida=================================================

CREATE OR ALTER PROCEDURE spu_numeros_sumar
@a INT,
@b INT,
@resultado INT  OUTPUT
AS
BEGIN
    SET @resultado = @a + @b
END;
GO

DECLARE @res INT;
EXEC spu_numeros_sumar 5,7,@res OUTPUT;
SELECT @res AS [Resultado];
GO

CREATE OR ALTER PROCEDURE spu_numeros_sumar2
@a INT,
@b INT,
@resultado INT  OUTPUT
AS
BEGIN
    SELECT @resultado = @a + @b
END;
GO

DECLARE @res INT;
EXEC spu_numeros_sumar2 5,7,@res OUTPUT;
SELECT @res AS [Resultado];
GO

--Crear un SP que devuelva el area de un circulo 
CREATE OR ALTER PROCEDURE spu_area_circulo
@radio DECIMAL (10,2),
@area DECIMAL (10,2) OUTPUT
AS
BEGIN
    --SET @area = PI() * @radio * @radio
    SET @area = PI() * POWER(@radio,2);
END;
GO

DECLARE @r DECIMAL (10,2);
EXEC spu_area_circulo 2.4, @r OUTPUT;
SELECT @r AS [area del circulo];
GO

--Crear un SP que reciva un id del cliente y devuelva el nombre

CREATE OR ALTER PROCEDURE spu_cliente_obtener
@id nchar(10),
@name nvarchar(40) OUTPUT
AS
BEGIN
    IF LEN(@id) = 5 
    BEGIN
        IF EXISTS (SELECT 1 FROM CUSTOMERS WHERE CustomerID = @id)
        BEGIN
            SELECT @name = CompanyName
            FROM Customers
            WHERE CustomerID = @id

            RETURN;
        END

        PRINT 'EL CUSTOMER NO EXISTE';
        RETURN;
    END
        PRINT 'EL ID DEBE SER DEE TAMAÑO 5';
END;
GO

DECLARE @name nvarchar(40) 
EXEC spu_cliente_obtener 'AROUX', @name OUTPUT
SELECT @name  AS [Nombre del Cliente];
GO

--============================================= CASE ==================================================

CREATE OR ALTER PROC spu_evaluar_calificacion
@calif INT
AS 
BEGIN
    SELECT
        CASE 
            WHEN @calif >= 90 THEN 'EXCELENTE'
            WHEN @calif >= 70 THEN 'APROBADO'
            WHEN @calif >= 60 THEN 'REGULAR'
            ELSE 'NO ACREDITADO'
        END AS [RESULTADO];
END;
GO

EXEC spu_evaluar_calificacion 100;
EXEC spu_evaluar_calificacion 75;
EXEC spu_evaluar_calificacion 55;
EXEC spu_evaluar_calificacion 65;
GO

--CASE dentro de un select caso real 
USE NORTHWND;

CREATE TABLE bdStored.dbo.Productos
(
    nombre VARCHAR(50),
    precio MONEY
);

--Inserta los datos basados en la consulta (Select)
INSERT INTO bdstored.dbo.Productos
SELECT 
ProductName, UnitPrice 
FROM NORTHWND.dbo.Products;
GO

SELECT * FROM bdStored.dbo.Productos;
GO

SELECT 
    nombre, precio,
    CASE
        WHEN precio > 200 THEN 'CARO'
        WHEN precio >= 100 THEN 'MEDIO'
        ELSE 'BARATO' 
    END AS [Categoria]
FROM bdStored.dbo.Productos;
GO

--selecciona los clientes con su nombre, pais, ciudad y region pero la region (los valores nulos, visualizalos con la leyenda sin regiom),ADEMA QUE TODO EL RESULTAADO ESTE EN MAYUSCULAS

use NORTHWND;
GO

CREATE OR ALTER VIEW vw_buena
SELECT 
    UPPER(CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) as [City],
    UPPER (ISNULL(c.Region, 'Sin Region')) AS [Region Limpia],
    LTRIM (UPPER(CONCAT(e.FirstName, ' ', e.LastName)))  AS [FullName],
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
    CASE 
        WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND SUM(od.Quantity * od.UnitPrice)<= 60000 THEN 'GOLD'
        WHEN SUM(od.Quantity * od.UnitPrice) > 30000 AND SUM(od.Quantity * od.UnitPrice)<= 25000 THEN 'SILVER'
        ELSE 'BRONZE'
    END AS [Medallon]
FROM NORTHWND.dbo.Customers as c
INNER JOIN 
NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
GROUP BY CompanyName, c.Country, c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName);
GO

CREATE OR ALTER PROC spu_informe_clientes_empleados 
@nombre VARCHAR(50),
@region VARCHAR(50)
AS
BEGIN
    SELECT * 
    FROM vw_buena
    WHERE FullName = @nombre
    AND [Region Limpia] = @region;
END;


SELECT 
    UPPER(CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) as [City],
    UPPER (ISNULL(c.Region, 'Sin Region')) AS [Region Limpia],
    LTRIM (UPPER(CONCAT(e.FirstName, ' ', e.LastName)))  AS [FullName],
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
    CASE 
        WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND SUM(od.Quantity * od.UnitPrice)<= 60000 THEN 'GOLD'
        WHEN SUM(od.Quantity * od.UnitPrice) > 30000 AND SUM(od.Quantity * od.UnitPrice)<= 25000 THEN 'SILVER'
        ELSE 'BRONZE'
    END AS [M]
FROM NORTHWND.dbo.Customers as c
INNER JOIN 
NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE CONCAT(e.FirstName, ' ', e.LastName) = UPPER('ANDREW FULLER')
AND UPPER (ISNULL(c.Region, 'Sin Region')) = UPPER('Sin Region')
GROUP BY CompanyName, c.Country, c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName)
ORDER BY FULLNAME ASC, [TOTAL] DESC;

/*====================================== manejo de Errores Con TRY CATCH ==========================================*/

SELECT 10/0;

-- Con TRY .. CATCH
BEGIN TRY 
    SELECT 10/0;
END TRY 
BEGIN CATCH
    PRINT 'OCURRIO UN ERROR';
END CATCH;
GO

--Ejemplo de uso de funciones para obtener informacion del error
BEGIN TRY
select 10/0;
END TRY
BEGIN CATCH
    PRINT 'Mensaje: ' + ERROR_MESSAGE();
    PRINT 'Numero de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Linea de error: ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT 'Estado del error: ' + CAST(ERROR_PROCEDURE() AS VARCHAR);
END CATCH;

CREATE TABLE clientes(
    id INT PRIMARY KEY,
    nombre VARCHAR(30)
);
GO

INSERT INTO clientes
VALUES (1,'PANFILO');
GO

BEGIN TRY 
    INSERT INTO clientes
    VALUES (1,'EUSTTACIO');
END TRY
BEGIN CATCH
    PRINT 'Error al insertar: ' + error_message();
    PRINT 'Error en la linea: ' + CAST(error_line() AS VARCHAR);
END CATCH
GO

BEGIN TRANSACTION;
    INSERT INTO clientes
    VALUES (2,'America Angel');

    SELECT * FROM clientes;

COMMIT;
ROLLBACK;
GO

use bdstored

-- Ejemplo de uso de transacciones jinto con el try catch

BEGIN TRY
    BEGIN TRANSACTION

    INSERT INTO clientes Values (3, 'VALDERABANO');
    INSERT INTO clientes Values (4, 'ROLES ALINA');
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 1
        BEGIN
        ROLLBACK;
        END
    PRINT 'Se hixo roleback por error';
    PRINT 'ERROR: ' + ERROR_MESSAGE();
END CATCH
GO

-- Crear un stored procedure que inserte un cliente, cocn las validaciones necesarias

CREATE OR ALTER PROC usp_insertar_cliente
@id INT,
@nombre VARCHAR(30) 
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO clientes VALUES (@id, @nombre);
            COMMIT;
            PRINT 'Cliente insertado';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT >1
        BEGIN
            ROLLBACK;
        END
        PRINT 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

SELECT * FROM clientes;

UPDATE clientes 
SET nombre = 'AMERICO AZUL'
WHERE id = 2;

IF @@ROWCOUNT < 1
BEGIN 
    PRINT 'NO EXISTE EL CLIENTE';
END
ELSE
PRINT 'ClIENTE ACTUALIZADO';

CREATE TABLE teams 
(
    id int not null IDENTITY PRIMARY KEY,
    nombre NVARCHAR(15)
);

INSERT INTO teams (nombre)
VALUES ('CHAFA AZUL');

--FORMA DE OBTENER UN IDENTITY INSERTADO FORMA 1
DECLARE @id_insertado INT 
SET @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO: ' + CAST(@id_insertado AS VARCHAR);
SELECT @id_insertado = @@IDENTITY 
PRINT 'ID INSERTADO FORMA 2 ' + CAST(@id_insertado AS VARCHAR);


INSERT INTO teams (nombre)
VALUES ('AAGUILA');
--FORMA DE OBTENER UN IDENTITY INSERTADO FORMA 1
DECLARE @id_insertado2 INT 
SET @id_insertado2 = SCOPE_IDENTITY();
PRINT 'ID INSERTADO: ' + CAST(@id_insertado2 AS VARCHAR);
SELECT @id_insertado2 = SCOPE_IDENTITY();
PRINT 'ID INSERTADO FORMA 2 ' + CAST(@id_insertado2 AS VARCHAR);

