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
    REFERENCES bdPracticas.dbo.CatCliente(id_Cliente)
);

SELECT * FROM bdPracticas.dbo.TblVenta;
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
    DECLARE @Existencia INT;
    DECLARE @Precio MONEY;
    DECLARE @id_Venta INT;
    DECLARE @Precio_Venta MONEY;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Validar cliente
        IF NOT EXISTS (
            SELECT 1 
            FROM bdPracticas.dbo.CatCliente 
            WHERE id_Cliente = @id_Cliente
        )
        BEGIN
            PRINT 'El cliente no existe';
            ROLLBACK
            RETURN;
        END

        -- Obtener producto
        SELECT @Existencia = Existencia, 
               @Precio = Precio
        FROM bdPracticas.dbo.CatProducto 
        WHERE id_Producto = @id_Producto;

        -- Validar producto
        IF @Existencia IS NULL
        BEGIN
            PRINT 'El producto no existe';
            ROLLBACK
            RETURN;
        END

        -- Validar stock
        IF @Existencia < @Cantidad_Vendida
        BEGIN
            PRINT 'No hay suficiente stock';
            ROLLBACK
            RETURN;
        END

        -- Actualizar stock
        UPDATE bdPracticas.dbo.CatProducto
        SET Existencia = Existencia - @Cantidad_Vendida
        WHERE id_Producto = @id_Producto;

        -- Insertar venta
        SET @FechaActual = GETDATE();

        INSERT INTO bdPracticas.dbo.TblVenta (Fecha, id_Cliente)
        VALUES (@FechaActual, @id_Cliente);

        -- Obtener ID correcto
        SET @id_Venta = SCOPE_IDENTITY();

        -- Calcular precio
        SET @Precio_Venta = @Precio * @Cantidad_Vendida;

        -- Insertar detalle
        INSERT INTO bdPracticas.dbo.TblDetalleVenta 
        (id_Venta, id_Producto, precio_Venta, Cantidad_Vendida)
        VALUES (@id_Venta, @id_Producto, @Precio_Venta, @Cantidad_Vendida);

        COMMIT
        PRINT 'Venta realizada correctamente'

    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK

        PRINT 'Error en la venta'
    END CATCH
END;
GO

-- Ejecucion
EXEC usp_agregar_venta 
    @id_Cliente = 'VINET',
    @id_Producto = 8,
    @Cantidad_Vendida = 1;

--Consultas
SELECT * FROM bdPracticas.dbo.CatProducto
WHERE id_Producto = 1;

SELECT * FROM bdPracticas.dbo.TblVenta
WHERE id_Cliente = 'ALFKI';

SELECT * FROM bdPracticas.dbo.TblDetalleVenta
WHERE id_Venta = 11250;

--Delete Detalle venta y TblVenta
delete FROM bdPracticas.dbo.TblDetalleVenta WHERE id_Venta = 11251;
delete FROM bdPracticas.dbo.TblVenta WHERE id_Venta = 11251;

SELECT id_Cliente FROM bdPracticas.dbo.CatCliente;
SELECT * FROM bdPracticas.dbo.CatProducto;
GO



--- Tabla tipo Type 

CREATE TYPE Agregar_n_producto AS TABLE
(
    id_Producto INT,
    Cantidad_Vendida INT
);
GO


-- Store con la tabla type

CREATE OR ALTER PROC usp_agregar_venta_multiple
@id_Cliente NCHAR(5),
@Detalle Agregar_n_producto READONLY
AS
BEGIN
    DECLARE @id_Venta INT;
    DECLARE @FechaActual DATE = CAST(GETDATE() AS DATE);

    BEGIN TRY

        --  1. Validar cliente
        IF NOT EXISTS (
            SELECT 1 
            FROM bdPracticas.dbo.CatCliente 
            WHERE id_Cliente = @id_Cliente
        )
        BEGIN
            PRINT 'Cliente no existe';
            RETURN;
        END

        -- 2. Validar productos inexistentes
        IF EXISTS (
            SELECT d.id_Producto
            FROM @Detalle AS d
            LEFT JOIN bdPracticas.dbo.CatProducto p
                ON d.id_Producto = p.id_Producto
            WHERE p.id_Producto IS NULL
        )
        BEGIN
            PRINT 'Hay productos que no existen';
            RETURN;
        END

        -- 3. Validar stock insuficiente
        IF EXISTS (
            SELECT 1
            FROM @Detalle d
            JOIN bdPracticas.dbo.CatProducto p
                ON d.id_Producto = p.id_Producto
            WHERE d.Cantidad_Vendida > p.Existencia
        )
        BEGIN
            PRINT 'Stock insuficiente';
            RETURN;
        END

        BEGIN TRANSACTION;

        -- 4. Insertar venta
        INSERT INTO bdPracticas.dbo.TblVenta (Fecha, id_Cliente)
        VALUES (@FechaActual, @id_Cliente);

        SET @id_Venta = SCOPE_IDENTITY();

        -- 5. Insertar detalle
        INSERT INTO bdPracticas.dbo.TblDetalleVenta
        (id_Venta, id_Producto, precio_Venta, Cantidad_Vendida)
        SELECT 
            @id_Venta,
            d.id_Producto,
            p.Precio * d.Cantidad_Vendida,
            d.Cantidad_Vendida
        FROM @Detalle d
        JOIN bdPracticas.dbo.CatProducto p
            ON d.id_Producto = p.id_Producto;

        -- 6. Actualizar stock
        UPDATE p
        SET p.Existencia = p.Existencia - d.Cantidad_Vendida
        FROM bdPracticas.dbo.CatProducto p
        JOIN @Detalle d
            ON p.id_Producto = d.id_Producto;

        COMMIT TRANSACTION;

        PRINT 'Venta registrada correctamente';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Error en la venta';
    END CATCH
END;
GO

-- EJECUCION: insertamos distintos productos con sus cantidades correspondientes por la tabla type
DECLARE @Detalle Agregar_n_producto;

INSERT INTO @Detalle VALUES (1, 2);
INSERT INTO @Detalle VALUES (2, 3);
INSERT INTO @Detalle VALUES (3, 1);

EXEC usp_agregar_venta_multiple 'ANTON', @Detalle;


-- Aqui podemos rectificar si el numero de existencias del producto es el mismo o no 
SELECT * FROM bdPracticas.dbo.CatProducto
WHERE id_Producto = 1;

-- Aqui verificamos la venta si se actuaaliaz el id la fecha en que se hizo la venta y por quien 
SELECT * FROM bdPracticas.dbo.TblVenta
WHERE id_Cliente = 'ANTON';

-- aqui verificamos el detalle de esa venta buscando por el id 
SELECT * FROM bdPracticas.dbo.TblDetalleVenta
WHERE id_Venta = 12258;

-- Buscar id's
SELECT id_Cliente FROM bdPracticas.dbo.CatCliente;
SELECT * FROM bdPracticas.dbo.CatProducto;
GO