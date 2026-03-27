# Documentacion 
## Parametro de Entrada
| Parámetro        | Tipo de dato | Descripción                  |
|-----------------|-------------|------------------------------|
| @id_Cliente     | NCHAR(5)    | Identificador del cliente    |
| @id_Producto    | INT         | Identificador del producto   |
| @Cantidad_Vendida | INT       | Cantidad vendida             |

## Variables Internas
| Variable            | Tipo de dato | Descripción                                      |
|---------------------|-------------|--------------------------------------------------|
| @FechaActual        | DATE        | Fecha actual en la que se registra la venta      |
| @ExistenciaFinal    | INT         | Stock disponible después de realizar la venta    |
| @Precio             | MONEY       | Precio unitario del producto                     |
| @id_Venta           | INT         | Identificador de la venta generada               |
| @Precio_Venta       | MONEY       | Importe total de la venta (Precio * Cantidad)    |
## Objetivo

Permitir el registro de una venta de manera segura, asegurando que:

- El cliente exista
- El producto exista
- Exista suficiente inventario
- Se actualice correctamente el stock
- Se registre la venta y su detalle

## Proceso paso a paso
1. Inicio de transacción

    -  Se inicia una transacción para asegurar que todas las operaciones se ejecuten de forma atómica.

2. Validación del cliente

    - Se verifica que el cliente exista en la tabla   CatCliente.

        Si no existe → se lanza un error y se detiene el proceso
3. Obtención de datos del producto

    - Se obtiene:

        Existencia actual
        Precio del producto

    Desde la tabla CatProducto.

4. Validación del producto

    - Si el producto no existe → se genera error
      Si no hay suficiente stock → se genera error

5. Actualización de inventario

    - Se descuenta la cantidad vendida del stock disponible.

6. Registro de la venta

    - Se inserta un nuevo registro en la tabla TblVenta con:

        Fecha actual (GETDATE())
        Cliente

7. Obtención del ID de la venta

    - Se obtiene el ID generado mediante SCOPE_IDENTITY().

8. Cálculo del importe

    - Se calcula el total de la venta:
            Precio * Cantidad

9. Registro del detalle de venta

    - Se inserta en TblDetalleVenta:

            ID de la venta
            Producto
            Precio de venta
            Cantidad
10. Confirmación de la transacción

    - Si todo es correcto, se ejecuta COMMIT.

11. Manejo de errores

    - En caso de error:

        Se ejecuta ROLLBACK
        Se muestra el mensaje de error


```sql
CREATE DATABASE bdPracticas;
GO

USE bdPracticas;
GO

USE NORTHWND;
GO

--======================================== Creacion de tablas ===========================================
CREATE TABLE bdPracticas.dbo.CatProducto
(
    id_Producto INT IDENTITY PRIMARY KEY,
    nombre_Producto nvarchar(40),
    Existencia INT,
    Precio MONEY
);

SET IDENTITY_INSERT bdPracticas.dbo.CatProducto ON;
INSERT INTO bdPracticas.dbo.CatProducto (id_Producto, nombre_Producto, Existencia, Precio)
SELECT
    ProductID,
    ProductName,
    UnitsInStock,
    UnitPrice
FROM NORTHWND.dbo.Products; 
SET IDENTITY_INSERT bdPracticas.dbo.CatProducto OFF;
GO

SELECT * FROM CatProducto;
GO
 
CREATE TABLE bdPracticas.dbo.CatCliente
(
    id_Cliente NCHAR(5) PRIMARY KEY,
    nombre_Cliente NVARCHAR(40),
    Pais NVARCHAR(15),
    Ciudad NVARCHAR(15)
);
GO

SELECT * FROM CatCliente;
GO

/*INSERT INTO bdPracticas.dbo.CatCliente (id_Cliente, nombre_Cliente, Pais, Ciudad)
SELECT
    CustomerID, 
    ContactName, 
    Country, 
    City
FROM NORTHWND.dbo.Customers;
GO
*/

CREATE TABLE bdPracticas.dbo.TblVenta
(
    id_Venta INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE,
    id_Cliente NCHAR(5)

    CONSTRAINT FK_Venta_Cliente
    FOREIGN KEY (id_Cliente)
    REFERENCES CatCliente(id_Cliente)
);

SELECT * FROM TblVenta;
GO

SELECT CustomerID
FROM NORTHWND.dbo.Orders
WHERE CustomerID NOT IN (
    SELECT id_Cliente FROM bdPracticas.dbo.CatCliente
);

SET IDENTITY_INSERT bdPracticas.dbo.TblVenta ON;
INSERT INTO bdPracticas.dbo.TblVenta (id_Venta, Fecha, id_Cliente)
SELECT
    OrderID,
    OrderDate,
    CustomerID
FROM NORTHWND.dbo.Orders;
SET IDENTITY_INSERT bdPracticas.dbo.TblVenta OFF;

-- DROP TABLE bdPracticas.dbo.TblVenta;

CREATE TABLE bdPracticas.dbo.TblDetalleVenta
(
    id_Venta INT,
    id_Producto INT,
    precio_Venta MONEY,
    Cantidad_Vendida INT,

    CONSTRAINT PK_DetalleVenta
    PRIMARY KEY (id_Venta, id_Producto),

    CONSTRAINT FK_DetalleVenta_Venta
    FOREIGN KEY (id_Venta)
    REFERENCES bdPracticas.dbo.TblVenta(id_Venta),

    CONSTRAINT FK_DetalleVenta_Producto
    FOREIGN KEY (id_Producto)
    REFERENCES bdPracticas.dbo.CatProducto(id_Producto)
);

SELECT * FROM TblDetalleVenta;

INSERT INTO bdPracticas.dbo.TblDetalleVenta (id_Venta, id_Producto, precio_Venta, Cantidad_Vendida)
SELECT
    OrderID,
    ProductID,
    UnitPrice,
    Quantity
FROM NORTHWND.dbo.[Order Details];

SELECT OrderID
FROM NORTHWND.dbo.[Order Details]
WHERE OrderID NOT IN (
    SELECT id_Venta FROM bdPracticas.dbo.TblVenta
);

SELECT ProductID
FROM NORTHWND.dbo.[Order Details]
WHERE ProductID NOT IN (
    SELECT id_Producto FROM bdPracticas.dbo.CatProducto
);

--====================================== Crear un Stored Proceure =====================================
--Borra procedimiento
DROP PROCEDURE usp_agregar_venta;
GO
--Crear procediimiento almacenimiento
CREATE OR ALTER PROC usp_agregar_venta
@id_Cliente NCHAR(5),
@id_Producto INT,
@Cantidad_Vendida INT
AS
BEGIN
    DECLARE @FechaActual DATE;
    DECLARE @ExistenciaFinal INT;
    DECLARE @Precio MONEY;
    DECLARE @id_Venta INT;
    DECLARE @Precio_Venta MONEY;
    Begin TRY
        SELECT id_Cliente  FROM bdPracticas.dbo.CatCliente WHERE id_Cliente = @id_Cliente;
    End TRY
    BEGIN CATCH
        PRINT 'No se encontro el usuario';
        THROW;
    END CATCH
    BEGIN TRY
        SELECT @ExistenciaFinal = Existencia, 
        @Precio = Precio FROM bdPracticas.dbo.CatProducto WHERE id_Producto =@id_Producto;
        IF(@ExistenciaFinal >= @Cantidad_Vendida)
            BEGIN
                SET @ExistenciaFinal = @ExistenciaFinal - @Cantidad_Vendida;
            END
        ELSE
            BEGIN
                PRINT 'No hay mas existencias';
                RETURN;
            END
    END TRY
    BEGIN CATCH
        PRINT 'El producto no existe ';
        THROW;
    END CATCH
    BEGIN TRY
        BEGIN TRANSACTION;
            SET @FechaActual = CAST(GETDATE() AS date)
            UPDATE bdPracticas.dbo.CatProducto
            SET Existencia = @ExistenciaFinal
            WHERE id_Producto = @id_Producto;

            INSERT INTO bdPracticas.dbo.TblVenta (Fecha, id_Cliente)
            VALUES(@FechaActual, @id_Cliente);
            SELECT @id_Venta = id_Venta FROM bdPracticas.dbo.TblVenta WHERE Fecha = @FechaActual AND id_Cliente = @id_Cliente;
            SELECT @Precio_Venta = @Precio * @Cantidad_Vendida;
            INSERT INTO bdPracticas.dbo.TblDetalleVenta (id_Venta, id_Producto, precio_Venta, Cantidad_Vendida)
            VALUES(@id_Venta, @id_Producto, @Precio_Venta, @Cantidad_Vendida);
        COMMIT TRANSACTION;
        PRINT 'Venta Realizada'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
        PRINT  'ERROR al hacer la venta ';
    END CATCH
END;
GO

-- Ejecucion
EXEC usp_agregar_venta 
    @id_Cliente = 'ALFKI',
    @id_Producto = 1,
    @Cantidad_Vendida = 2;

--Consultas
SELECT * FROM CatProducto
WHERE id_Producto = 1;

SELECT * FROM TblVenta
WHERE id_Cliente = 'ALFKI';

SELECT * FROM TblDetalleVenta
WHERE id_Venta = 11250;

--Delete Detalle venta y TblVenta
delete FROM TblDetalleVenta WHERE id_Venta = 11251;
delete FROM TblVenta WHERE id_Venta = 11251;

SELECT id_Cliente FROM CatCliente;
SELECT * FROM CatProducto;
```
    