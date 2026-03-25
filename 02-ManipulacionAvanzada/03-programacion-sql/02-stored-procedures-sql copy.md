
# Stored procedures (procedimiento  almacenados)  en Transact-SQL (SQL SERVER)
1.  Fundamentos 
- ¿Que es un stored procedure?

Un **stored procedure (SP)** es un bloque de codigo SQL guardado en la base de datos que puedes ejecutarse 
cuando se necesite, es un objeto de la base de datos

Es algo similar a una funcion o metodo en programacion.

Ventajas

1. Reutiliza el codigo
2.Mejor rendimiento
3.Mayor seeguridad
4.Centralizacion d logica de negocio
5.Menos trafico entre aplicacion y servidor

- Sintaxis

![SintaxisSQL](../../sp_sintaxis.png)

- Nomenclatura_<Entidad>_<Accion>
```
```
| Parte   | Significado                     | Ejemplo |
|--------|---------------------------------|--------|
| spu    | Stored Procedure User           | spu_   |
| Entidad| Tabla o concepto del negocio    | Cliente|
| Acción | Lo que hace                     | Insert |

-Acciones estandar 

Estas son las acciones mas usadas en sistema empresariales

| Acción     | Significado          | Ejemplo                |
| ---------- | -------------------- | ---------------------- |
| Insert     | Insertar registro    | spu_Cliente_Insert     |
| Update     | Actualizar           | spu_Cliente_Update     |
| Delete     | Eliminar             | spu_Cliente_Delete     |
| Get        | Obtener uno          | spu_Cliente_Get        |
| List       | Obtener varios       | spu_Cliente_List       |
| Search     | Búsqueda con filtros | spu_Cliente_Search     |
| Exists     | Validar si existe    | spu_Cliente_Exists     |
| Activate   | Activar registro     | spu_Cliente_Activate   |
| Deactivate | Desactivar           | spu_Cliente_Deactivate |

- Ejemplo

Suponer que tenemos tabla cliente

Insertar Cliente
```
spu_Cliente_Insert
```

Insertar Cliente
```
spu_Cliente_Insert
```
Actualizar Cliente
```
spu_Cliente_Update
```
Obtener Cliente po id
```
spu_Cliente_Get
```
Listar todos los Cliente
```
spu_Cliente_List
```
Insertar Cliente
```
spu_Cliente_Insert
```

```sql
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

EXEC usp_nombre_mayusculas 'albin';
```

3.Parametros de Salida

Los parametoors OUTPUT devuelven valores al usuario 

```sql
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
```


5.  Try ... Catch  
Manejo de ERRORES y excepciones en tiempo de ejecucion y manejar lo que sucede cuando ocurren
SINTAXIS 
```sql
BEGIN TRY
--Codigo que puede generar un error
END TRY
BEGIN CATCH
-- Codigo que se ejecuta si ocurre un error 
END CATCH
```
- ¿Como funciona?
1. SQL ejecuta todo lo que esta ddentro del TRY
2. Si ocurre un error 
    - Se detiene la ejecucion del try 
    - Y salta automaticamente al Catch
3. En el CATCH se puede: 
    -Mostrar mensajes
    -Registrar errores
    -Revertir Transacciones

*Obtener Informcaion del error*

Dentro del catch, sql server tiene funciones especiales:

|   Funcion |Descripcion |
| :--- | :--- |
| ERROR_MESSAGE() | Mensaje de error |
| ERROR_NUMBER() | Numero de error |
| ERROR_LINE() | Linea donde ocurrio |
| ERROR_PROCEDURE() | Procedimiento |
| ERRO_SEVERITY() | Nivel de gravedad|
| ERROR_STATE() | Estado del error |

```sql
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
```