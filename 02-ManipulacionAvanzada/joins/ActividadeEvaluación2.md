# Actividad Script de consultas simples y de agregado, group by y having

## 1. Creaccion de  Base de Datos

```sql
-- Aqui se cre una base de datos llamada"tienda"
CREATE DATABASE tienda;
GO
```
- ### CREATE DATABASE tienda; 
  Crea una nueva base de datos llamada **tienda**.

- ### GO  
  Indica el final del bloque de instrucciones (batch) en SQL Server.  
  Permite ejecutar la instrucción anterior antes de continuar.

---

## 2. Seleccion de la Base de Datos

```sql
USE tienda;
```

- USE tienda;  
  Cambia el contexto actual a la base de datos **tienda**, permitiendo crear tablas y ejecutar consultas dentro de ella.

---

## Script 

```sql
CREATE DATABASE tienda;
GO

USE tienda;
```

## 3. INSERT INTO y VALUES 
#### Ejemplo:
```sql
 INSERT INTO clientes
 VALUES (1, 'Goku', 'linterna', 'superman', 450, '1578-01-17', 100)

 INSERT INTO clientes
 VALUES (2, 'PANCRACIO', 'RIVERO', 'PATROCLO', 20, '1005-01-17', 100)

 INSERT INTO clientes
 (nombre, cliente_id, limite_credito, fecha_nacimiento, apellido_paterno, edad)
 VALUES ('Arcadia',3,45800, '2000-01-22', 'Ramirez', 26)

  INSERT INTO clientes
 VALUES (4, 'Vanesa', 'Buena Vista', NULL, 26, '2000-04-25', 3000)

 INSERT INTO clientes
 VALUES 
 (5, 'Soyla', 'Vaca', 'Del corral', 42, '1983-04-06', 78955),
 (6, 'Bad Bunny', 'Perez', 'Sinsentido', 22, '1999-05-06', 85858),
 (7, 'Jose Luis', 'Herrera', 'Gallardo', 42, '1983-04-06', 14000);
```

- ### Insert Into: 
  Se utiliza para agregar nuevos registros (filas) a una tabla dentro de una base de datos..

  - ### INSERT INTO clientes 
  Indica que se va a insertar un nuevo registro en la tabla llamada clientes.

- ### VALUES: 
 La palabra VALUES indica los datos que se van a agregar a la tabla.

Los valores deben colocarse en el mismo orden en que están definidas las columnas en la estructura de la tabla.

## 4. GETDATE() y DEFAULT
### EJEMPLO
```sql
--obtiene la fecha del sistema
 CREATE TABLE Clientes_2(
 cliente_id INT NOT NULL identity(1,1),
 nombre NVARCHAR (50) NOT NULL,
 edad INT NOT NULL,
 fecha_registro DATE DEFAULT GETDATE(),
 limite_credito MONEY NOT NULL
 CONSTRAINT pk_clientes_2
 PRIMARY KEY (cliente_id),
 );
```
- ### GETDATE(): 
  Es una función de SQL Server que devuelve la fecha y hora actual del sistema en el momento en que se ejecuta la consulta.
    - La columna fecha_registro es de tipo DATE (solo guarda año, mes y día).
    Si al insertar un registro no se especifica un valor para fecha_registro, automáticamente se usará la fecha actual del sistema.

- ### DEFAULT: 
  La palabra DEFAULT indica un valor automático cuando no se proporciona uno al insertar datos.

    - Si no se especifica fecha_registro, se usa la fecha actual.

    - Si sí se especifica, se usará el valor que tú envíes.

 ## 5.
 ### Ejemplo:
 ```sql
 CREATE TABLE suppliers (
supplier_id INT NOT NULL,
[name] NVARCHAR(30) NOT NULL,
date_register DATE NOT NULL DEFAULT GETDATE(),
tipo CHAR(1) NOT NULL,
credit_limit Money NOT NULL,
CONSTRAINT pk_supplier_id
PRIMARY KEY (supplier_id),
CONSTRAINT unique_name
UNIQUE ([name]),
CONSTRAINt chk_credit_limit
CHECK (credit_limit > 0.0 and credit_limit <=50000),
CONSTRAINT chk_tipo
CHECK (tipo in ('A','B','C'))
);
 ```
- ### PRIMARY KEY: 

-Identifica de manera única cada registro de la tabla.

-No permite valores repetidos.

-No permite valores NULL.

#### En la tabla:

- supplier_id será el identificador único de cada proveedor.

- No pueden existir dos proveedores con el mismo supplier_id.

- ### UNIQUE: 

-No permite valores duplicados en la columna especificada.

- A diferencia del PRIMARY KEY, sí puede permitir un NULL (aunque depende del diseño).

#### En la tabla

- No puede haber dos proveedores con el mismo nombre.

- ### CHECK: 

- Solo permite valores mayores a 0

- Y menores o iguales a 50,000

## 6. UPPER
### Ejemplo: 
```sql
SELECT *
FROM suppliers;

INSERT INTO suppliers
VALUES (1,UPPER('bimbo'), DEFAULT,UPPER('c'), 45000);

INSERT INTO suppliers
VALUES (2,UPPER('tia rosa'), '2026-01-21',UPPER('a'), 49999.999);

INSERT INTO suppliers (name, tipo, credit_limit)
VALUES (3,UPPER('tia mensa'),UPPER('a'), 49999.999);
```
- ### UPPER()
Es una función de SQL que convierte un texto a mayúsculas

## 7. Alias 
### Ejemplo: 
```sql
SELECT 
ProductID AS [NUMERO DE PRODUCTO], 
ProductName  'NOMBRE DE PRODUCTO', 
UnitPrice AS [PRECIO UNITARIO], 
UnitsInStock AS STOCK
FROM Products;
```
### AS
- Un alias es un nombre temporal que se le asigna a una columna o a una tabla para que el resultado de una consulta sea más claro o más fácil de leer.

    - No modifica la estructura de la tabla, solo cambia el nombre que se muestra en el resultado de la consulta.

## 8. Campos Calculados 
### Ejemplo: 
```sql
-- Seleccionar la venta con el calculo con importe con descuento 
-- del importe con descuento

SELECT 
OrderID, 
UnitPrice, 
Quantity, 
Discount,
(UnitPrice * Quantity) AS Importe,
(UnitPrice * Quantity) - ((UnitPrice * Quantity) * Discount) 
AS [Importe con Descuento 1], 
(UnitPrice * Quantity) - (1 - Discount) 
AS [Importe con Descuento 2]
FROM [Order Details]
```

- Un campo calculado es una columna que no existe físicamente en la tabla, sino que se genera en el momento de ejecutar la consulta mediante una operación matemática o expresión.

Se crea dentro del SELECT usando operaciones como:

- (+) suma

- (-)resta

- (*)multiplicación

- (/)división

Funciones matemáticas

Funciones de texto

No modifica la tabla original.

## 7. Operadores Relacionales 

### Ejemplo
```sql
Obtener los pedidos que no tengan region
*/

SELECT ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20 and UnitsInStock < 100;

SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE ShipRegion Is not null;
```
```sql
SELECT 
ProductID AS [Numero de Producto],
ProductName AS [Nombre Producto],
UnitPrice AS [Precio Unitario],
UnitsInStock AS [Stock]
FROM Products
WHERE UnitsInStock <=20;
```
### ¿QUE SON?
Se usan para comparar valores en una condición, generalmente dentro de WHERE.
-  __(>) Mayor que.__

Devuelve verdadero si el valor de la izquierda es mayor que el de la derecha.
    

- __(<) Menor que.__

Devuelve verdadero si el valor de la izquierda es menor que el de la derecha.

- __(>=)__ Mayor o igual que.

Devuelve verdadero si el valor es mayor o igual al comparado.

- __(<=) Menor o igual que.__

Devuelve verdadero si el valor es menor o igual al comparado.

- __(=) Igual a.__

Devuelve verdadero si ambos valores son exactamente iguales.

- __(<>) Diferente de.__

Devuelve verdadero si los valores no son iguales.
    
- __(!=) También significa diferente de.__

Es otra forma válida en SQL Server.

- __BETWEEN__

Evalúa si un valor está dentro de un rango específico.
Incluye los valores límite.
```sql
/*
Mostrar los productos cuyos precios entre 20 y 40
*/
SELECT *
FROM Products
WHERE UnitPrice Between 20 and 40
ORDER BY UnitPrice;

```

- __IN__

Verifica si un valor se encuentra dentro de una lista de valores específicos.
```sql
SELECT *
FROM Customers
WHERE Country IN ('Germany', 'France', 'UK')
ORDER BY Country DESC;
```

- __LIKE__

Se usa para búsquedas con patrones en texto.
Permite utilizar comodines para encontrar coincidencias parciales.
```sql
--Selceccionar todos los c,ientes que comienzen con la letra a 

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE CompanyName LIKE 'a%';

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE CompanyName LIKE 'an%';

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE City LIKE 'l_nd__%';

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE CompanyName LIKE '%as';
```

- __IS NULL__

Verifica si un valor está vacío (NULL).
No compara con igual, porque NULL no es un valor, es ausencia de valor.

```sql
SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE ShipRegion Is null;
```

- __IS NOTT NULL__

```sql
SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE ShipRegion Is not null;
```

## 8. Funciones de Fecha
### Ejemplo: 
```sql
SET LANGUAGE SPANISH;
SELECT 
OrderID,
OrderDate,
CustomerID,
ShipCountry,
YEAR(OrderDate) AS Año,
MONTH(OrderDate) AS Mes,
DAY(OrderDate) AS Dia,
DATEPART(YEAR, OrderDate) AS AÑO2,
DATEPART(QUARTER, OrderDate) AS Trimestre,
DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE DATEPART (YEAR,OrderDate) > 1997;
```

- __SET LANGUAGE SPANISH;__

Cambia el idioma de la sesión actual en SQL Server.

Esto afecta:

El nombre de los días

El nombre de los meses

El primer día de la semana

Formatos de fecha

___

- YEAR() 

        YEAR(OrderDate)
    
    Devuelve el año de la fecha.
    Ejemplo:
    1998-05-12 → 1998

- MONTH()
        
        MONTH(OrderDate)
    
    Devuelve el número del mes.
    Ejemplo:
    1998-05-12 → 5

- DAY()

        DAY(OrderDate)
    
    Devuelve el día del mes.
    Ejemplo:
    1998-05-12 → 12

- DATEPART()

        DATEPART(parte, fecha)
    
    Devuelve una parte específica de la fecha.
    - Ejemplo
    ```sql
    DATEPART(YEAR, OrderDate)
    DATEPART(MONTH, OrderDate)
    DATEPART(DAY, OrderDate)
    DATEPART(QUARTER, OrderDate)
    DATEPART(WEEKDAY, OrderDate)
    DATEPART(WEEK, OrderDate)
    DATEPART(HOUR, fecha)
    DATEPART(MINUTE, fecha)
    DATEPART(SECOND, fecha)
    ```
    DATEPART(YEAR, OrderDate) → Año

    DATEPART(QUARTER, OrderDate) → Trimestre (1 a 4)

    DATEPART(WEEKDAY, OrderDate) → Número del día de la semana

- DATENAME()

        DATENAME(WEEKDAY, OrderDate)
    - Devuelve el nombre textual del valor.

        Ejemplo con idioma español:

        Lunes
        Martes
        Miércoles

        Depende del SET LANGUAGE.

## 9. Operadores Logicos
- AND

Devuelve verdadero solo si todas las condiciones son verdaderas.
Si una condición es falsa, el resultado completo es falso.
Se usa cuando quieres que se cumplan varias reglas al mismo tiempo.

```sql
SELECT ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20 and UnitsInStock < 100;

SELECT *
FROM Products
WHERE UnitPrice Between 20 and 40
ORDER BY UnitPrice;

SELECT *
FROM Products
WHERE UnitPrice>=20 and UnitPrice<= 40
ORDER BY UnitPrice;
```

- OR

Devuelve verdadero si al menos una de las condiciones es verdadera.
Solo será falso si todas las condiciones son falsas.
Se usa cuando basta con que una condición se cumpla.

```sql
SELECT CustomerID, CompanyName, Region, Country
FROM Customers
WHERE country = 'USA' or country = 'CANADA';

SELECT *
FROM Customers
WHERE Country = 'Germany' or Country = 'France' or Country = 'UK';

SELECT *
FROM Categories
WHERE CategoryID = 1 or CategoryID = 3 or CategoryID = 5;
```

- NOT

Niega una condición.
Convierte:

Verdadero en falso o
Falso en verdadero

Se usa para excluir resultados o invertir una condición.

## Funciones de Agregado

- SUM()
Calcula la suma total de los valores de una columna numérica.

    - Solo funciona con datos numéricos.

    - Ignora valores NULL.

    - Devuelve el total acumulado.
```sql
--Total de los precios de los prdutcos

SELECT SUM(UnitPrice) 
FROM Products;

--Obtener el total de dinero percibido por las ventas 

SELECT 
	SUM ((UnitPrice * Quantity * (1-Discount))) 
	AS [Importe mas bajo]
FROM [Order Details];

--Seleccionar las ventas totales de los productos 4, 10 y 20

SELECT  SUM(UnitsOnOrder) AS [Ventas Totales]
FROM Products
WHERE ProductID IN (4, 10, 20);
```

- MAX()
Devuelve el valor máximo de una columna.

    - Puede usarse con números, fechas o texto.

    - En texto devuelve el valor más alto según orden alfabético.

    - Ignora valores NULL.
```sql
--Seleccionar la fecha de compra mas actual

SELECT MAX(OrderDate) AS [Ultima fecha de compra]
FROM Orders;

SELECT *
FROM Orders;

--Selecciona el año de la fecha de compra mas actual

SELECT MAX(YEAR(OrderDate)) AS [Año mas actual]
FROM Orders;

SELECT YEAR(MAX(OrderDate)) AS [Año mas actual]
FROM Orders;

SELECT MAX(DATEPART(YEAR, OrderDate)) AS [Año mas actual]
FROM Orders;

SELECT DATEPART(YEAR, MAX (OrderDate)) AS [Año mas actual]
FROM Orders;
```
- MIN() Devuelve el valor mínimo de una columna.

    - Funciona con números, fechas o texto.

    - En texto devuelve el primer valor según orden alfabético.

    - Ignora valores NULL.
```sql
--Cual es la minima cantidad de los pedidos
SELECT MIN (UnitPrice) AS [Minima cantidad de productos]
FROM [Order Details];

--Cual es el importe mas bajo de  las compras
SELECT 
	MIN ((UnitPrice * Quantity * (1-Discount))) AS [Importe mas bajo]
FROM [Order Details];
```
- AVG() Calcula el promedio (media aritmética) de una columna numérica.

    - Suma todos los valores.

    - Los divide entre la cantidad de valores no NULL.

    - Ignora valores NULL.

- ROUND se usa para redondear un número a una cantidad específica de decimales.

    - Recibe principalmente dos parámetros:

    - El número que se quiere redondear.

    - La cantidad de posiciones decimales.

- COUNT(campo) Cuenta cuántos valores no NULL existen en una columna específica.

    - No cuenta los valores NULL.

    - Solo cuenta los registros donde ese campo tiene información.
```sql
/*
Seleccionar los productos no descontinuados, 
calcular el precio promedio vendido,
y mostrar solo aquellos que se hayan vendido 
en menos de 15 pedidos distintos 
*/

SELECT *
FROM Products;

SELECT p.ProductName, ROUND(AVG(od.UnitPrice), 2) as [Precio Promedio]
FROM Products AS p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID
WHERE p.Discontinued = 0
GROUP BY p.ProductName
HAVING COUNT(OrderID) < 15;
```
- COUNT(*) Cuenta el número total de filas.

    - Cuenta todas las filas.

    - Incluye filas aunque tengan valores NULL.

    - No depende de una columna específica.

    - Devuelve la cantidad total de registros.
```sql
-- Seleccionar el numero de productos (conteo) por categoria, mostrar categoriaID, total de los produuctos
-- y ordenarlos de mayor a menor por el total de productos
SELECT *
FROM Products;

SELECT 
	CategoryID, COUNT(*) AS [Numero de Producto]
FROM Products
GROUP BY CategoryID
ORDER BY 2 DESC;

SELECT 
	CategoryID, COUNT(*) AS [Numero de Producto]
FROM Products
GROUP BY CategoryID
ORDER BY COUNT(*) DESC;
```
- CONCAT() une (concatena) dos o más valores en una sola cadena de texto.
Recibe dos o más argumentos y los combina en el orden indicado.

    Puede unir:

    - Texto

    - Números

    - Fechas

    - Otros campos

    SQL convierte automáticamente los valores a texto si es necesario
```sql
SELECT 
	CONCAT (e.FirstName,' ',e.LastName) AS [Nombre Completo], 
	(od.Quantity * od.UnitPrice * (1- od.Discount)) AS IMPORTE
FROM Employees AS e
INNER JOIN Orders AS o 
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
ORDER BY e.FirstName ASC;
```
- GROUP BY

es una cláusula que se utiliza para agrupar filas que tienen el mismo valor en una o más columnas. En lugar de mostrar cada registro individual, organiza los datos en grupos y permite aplicar funciones de agregado como SUM, COUNT, AVG, MAX o MIN sobre cada grupo. Es decir, primero divide la información en conjuntos según el campo indicado y después realiza los cálculos sobre cada conjunto. Sin GROUP BY, las funciones de agregado trabajan sobre toda la tabla; con GROUP BY, trabajan sobre cada grupo formado.

Por ejemplo, si agrupas por país, SQL reúne todos los registros de cada país y calcula los totales o promedios por separado para cada uno. Es importante saber que cuando se usa GROUP BY, todas las columnas del SELECT deben ser agregadas o estar incluidas en la agrupación.
```sql

```

- HAVING

se utiliza para filtrar los resultados después de que se han creado los grupos. Mientras que WHERE filtra filas antes de agrupar, HAVING filtra los grupos ya formados. Esto es especialmente útil cuando quieres aplicar una condición sobre una función de agregado, como mostrar únicamente los grupos cuyo total sea mayor a cierta cantidad o cuya cantidad de registros supere un número determinado.

En resumen, GROUP BY organiza los datos en grupos y permite realizar cálculos por cada grupo, y HAVING permite establecer condiciones sobre esos grupos ya calculados.
```sql
/*
Seleccionar los clientes que hayan realizado mas de diez pedidos
*/
SELECT CustomerID, COUNT(*) AS [Numero de ordenes ]
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

/*
Seleccionar el numero de los productos vendidos de mas de 20 pedidos distintos
Mostrar el id del producto, el nombre del producto, el numero de ordenes 
*/

SELECT *
FROM Products;

SELECT p.ProductID, p.ProductName, COUNT(Distinct o.OrderID) AS  [Numero de Pedidos]
FROM Products AS p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID
INNER JOIN Orders AS O
ON o.OrderID = od.OrderID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(Distinct o.OrderID)>20;
```