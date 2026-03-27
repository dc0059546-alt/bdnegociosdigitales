DROP PROCEDURE usp_agregar_venta;
GO

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

    End TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
        PRINT  'ERROR al hacer la venta ';
    END CATCH
END;
GO

-- Ejecucion
EXEC usp_agregar_venta 
    @id_Cliente = 'ANATAR',
    @id_Producto = 4,
    @Cantidad_Vendida = 1;

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