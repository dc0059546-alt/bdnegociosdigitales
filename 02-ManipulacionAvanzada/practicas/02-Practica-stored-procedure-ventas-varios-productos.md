# Documentación: usp_agregar_venta_multiple
 ## Descripción General

El procedimiento almacenado usp_agregar_venta_multiple permite registrar una venta en la base de datos, asociando múltiples productos a un mismo cliente en una sola transacción.

Se valida:

- Existencia del cliente
- Existencia de los productos
- Disponibilidad de stock

Si todas las validaciones se cumplen, se:

Inserta la venta
Inserta el detalle de productos
Actualiza el inventario

Todo el proceso se ejecuta dentro de una transacción para garantizar la integridad de los datos.

## Tabla Tipo: Agregar_n_producto

Se utiliza para enviar múltiples productos al procedimiento.

```sql
CREATE TYPE Agregar_n_producto AS TABLE
(
    id_Producto INT,
    Cantidad_Vendida INT
);
```
## Procedimiento Almacenado

```sql
CREATE OR ALTER PROC usp_agregar_venta_multiple
@id_Cliente NCHAR(5),
@Detalle Agregar_n_producto READONLY
```
| Parametro | Tipo | Descripción |
| :--- | :--- | :--- |
| @id_Cliente | NCHAR(5) | Identificador del cliente |
| @Detalle | Agregar_n_producto | Lista de productos y cantidades | 

## Variables Internas

| Variable | Tipo | Descripción |
| :--- | :--- | :--- |
| @id_Venta | INT   | ID generado por la venta |
| @FechaActual | DATE | Fecha actual del sistema |
    
## Validaciones
- 1. Validar cliente existente IF NOT EXISTS (...)
Evita registrar ventas con clientes inexistentes.

- 2. Validar productos existentes
LEFT JOIN ... WHERE p.id_Producto IS NULL
Detecta productos que no existen en el catálogo.

- 3. Validar stock disponible
WHERE d.Cantidad_Vendida > p.Existencia
Evita vender productos sin suficiente inventario.

## Proceso Transaccional
BEGIN TRANSACTION

- 1. Insertar venta
INSERT INTO TblVenta (Fecha, id_Cliente)
Se registra la venta con la fecha actual.

- 2. Obtener ID de venta
SET @id_Venta = SCOPE_IDENTITY();
Se obtiene el ID generado automáticamente.

- 3. Insertar detalle de venta
INSERT INTO TblDetalleVenta
Se insertan todos los productos vendidos con su precio calculado.

- 4. Actualizar inventario
UPDATE CatProducto
SET Existencia = Existencia - Cantidad_Vendida
Se descuenta el stock de cada producto vendido.

- Confirmar transacción
```sql
COMMIT TRANSACTION;
-- Manejo de Errores
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
```

En caso de error:

Se revierte toda la operación
Se evita inconsistencia en los datos.

## Ejecución de Ejemplo
```sql
DECLARE @Detalle Agregar_n_producto;

INSERT INTO @Detalle VALUES (4, 2);
INSERT INTO @Detalle VALUES (7, 3);
INSERT INTO @Detalle VALUES (8, 1);

EXEC usp_agregar_venta_multiple 'ANTON', @Detalle;
-- Consultas de Verificación
-- Verificar stock
SELECT * 
FROM CatProducto
WHERE id_Producto = 4;
-- Verificar venta
SELECT * 
FROM TblVenta
WHERE id_Cliente = 'ANTON';
-- Verificar detalle de venta
SELECT * 
FROM TblDetalleVenta
WHERE id_Venta = 12259;
```

## Consideraciones
El parámetro @Detalle es de solo lectura (READONLY)
Se utilizan operaciones masivas con JOIN para mayor eficiencia
El procedimiento evita el uso de cursores
Se garantiza integridad con transacciones (BEGIN TRANSACTION)