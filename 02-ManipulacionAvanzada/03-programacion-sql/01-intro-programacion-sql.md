# Lenguaje Transact-SQL (MSServer)

## Fundamentos Programables

1. ¿Que es la parte programable T-SQL?

Es todo lo que permite: 

- Usar variables 
- Controlar el flujo (if, else, while, etc.)
- Crear procedimientos almacenados (Stored Procedures)
- Disparadores (Triggers)
- Manejar errores
- Crear Funciones
- Usar Transacciones 

Es convertir SQL en un lenguaje casi C/Java pero dentro del motor de base de datos 

2. 👻 Variables 

Una variable almacena un valor temporal  
```sql
/*===================================== Variables en Transact-SQL =================================*/
DECLARE @edad INT;
SET @edad = 21;

PRINT @edad
SELECT @edad AS [EDAD];

DECLARE @nombre AS VARCHAR(30) = 'San Gallardo';
SELECT @nombre AS [NOMBRE];
SET @nombre = 'San Adonai';
SELECT @nombre AS [Nombre];

/*===================================== Variables en Transact-SQL =================================*/

/*Ejercicio 1
	-Declarar una variable @Precio
	-Asignar el valor 150
	- Calcular el IVA (16)
	-Mostrar el total
*/ 

DECLARE @Precio AS MONEY = (150.00);
SELECT @Precio AS [PRECIO]
DECLARE @TotalIva AS INT = (150 *.16)
SELECT @TotalIva AS [IVA];

DECLARE @Precios MONEY = 150;
DECLARE @Iva DECIMAL(10,2);
DECLARE @Total MONEY;

SET @Iva = @Precios * 0.16;
SET @Total = @Precios + @Iva;

SELECT 
	@Precios AS [PRECIO], 
	CONCAT('$',@Iva) AS [IVA(16%)],
	CONCAT('$',@Total) AS [TOTAL]
``` 

3. IF/ELSE
Definicion: permite ejecutar codigo segun condicion 

```sql
DECLARE @edad INT; 
SET @edad = 18;

IF @edad >= 18
	PRINT 'Eres mayor de edad';
ELSE
	PRINT 'Eres menor de edad';

-- en donde se de la calificacion si es mayor a 7 aprobado si o reprobado
--que no sea negativo y que no exceda el diez
DECLARE @calificacion DECIMAL (10,2);
SET @calificacion = 9.5;

IF @calificacion >= 0.0 AND @calificacion<=10.0 
	BEGIN
	IF @calificacion >= 7.0
		BEGIN
		PRINT 'Aprobado'
		END 
		ELSE
		BEGIN
		PRINT 'Reprobado'
		END 
	END
	ELSE
	BEGIN
		SELECT CONCAT(@calificacion, 'Esta fuera de rango') AS [RESPUESTA]
	END
GO
```
/*===================================== WHILE =================================*/

4. WHILE (CICLOS)

```sql
WHILE (@i<=@limite)
	BEGIN
		PRINT CONCAT('Numero: ', @i)
		SET @i = @i + 1
	END
```
4.  CASE 
Este sirve para evaluar condicciones como un switch o un if mutiple 