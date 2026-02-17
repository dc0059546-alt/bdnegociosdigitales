-- Consultas simples con SQL-LMD

SELECT *
FROM Categories;

SELECT *
FROM Products;

SELECT *
FROM Orders;

SELECT *
FROM [Order Details];

-- Proyeccion (seleccionar algunos campos)

SELECT 
ProductID, 
ProductName, 
UnitPrice, 
UnitsInStock
FROM Products;

-- Alias de columnas
SELECT 
ProductID AS [NUMERO DE PRODUCTO], 
ProductName  'NOMBRE DE PRODUCTO', 
UnitPrice AS [PRECIO UNITARIO], 
UnitsInStock AS STOCK
FROM Products;

SELECT 
CompanyName AS CLIENTE,
CITY AS CIUDAD,
COUNTRY AS PAIS 
FROM Customers;

-- Campos calculados 

-- Seleccionar los productos y calcular el valor del inventario 
SELECT *,(UnitPrice * UnitsInStock) AS [Costo Inventario]
FROM Products;

SELECT 
ProductID,
ProductName,
UnitPrice,
UnitsInStock,
(UnitPrice * UnitsInStock) AS [Costo Inventario]
FROM Products;

-- Calcular el importe 
SELECT 
OrderID, 
ProductID, 
UnitPrice, 
Quantity, 
(UnitPrice * Quantity) AS IMPORTE
FROM [Order Details]

SELECT *
FROM [Order Details];

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



-- Operadores Relacionales (<,>,<=,>=,=, != o <>)

/*
Selecionar los productos con precio mayor a 30
Seleccionar los productos con stock menor o igual a 20
Seleccionar los pedidos posteriores a 1997
*/

SELECT 
ProductID AS [Numero de Producto],
ProductName AS [Nombre Producto],
UnitPrice AS [Precio Unitario],
UnitsInStock AS [Stock]
FROM Products
WHERE UnitPrice>30
ORDER BY UnitPrice DESC;

SELECT 
ProductID AS [Numero de Producto],
ProductName AS [Nombre Producto],
UnitPrice AS [Precio Unitario],
UnitsInStock AS [Stock]
FROM Products
WHERE UnitsInStock <=20;

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
WHERE OrderDate > '1997-12-31';

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
WHERE YEAR (OrderDate) > 1997;

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

--Operadores Logicos (not, and, or)
/*
Seleccionar los productos que tengan un precio mayor a 20
y menos de 100 unidades en  stock

Mostrar los clientes que sean de Estados unidos o Canada

Obtener los pedidos que no tengan region
*/

SELECT ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20 and UnitsInStock < 100;

SELECT CustomerID, CompanyName, Region, Country
FROM Customers
WHERE country = 'USA' or country = 'CANADA';

SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE ShipRegion Is null;

SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE ShipRegion Is not null;

-- Operador IN

/*
Mostrar los clientes de Alemania, Francia y UK.

Obtener los productos donde la categoria sea 1,3o 5
*/

SELECT *
FROM Customers
WHERE Country IN ('Germany', 'France', 'UK')
ORDER BY Country DESC;

SELECT *
FROM Customers
WHERE Country = 'Germany' or Country = 'France' or Country = 'UK';

SELECT *
FROM Categories
WHERE CategoryID = 1 or CategoryID = 3 or CategoryID = 5;

-- Operador Between

/*
Mostrar los productos cuyos precios entre 20 y 40
*/

SELECT *
FROM Products
WHERE UnitPrice Between 20 and 40
ORDER BY UnitPrice;

SELECT *
FROM Products
WHERE UnitPrice>=20 and UnitPrice<= 40
ORDER BY UnitPrice;

-- Operador Like

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

--Seleccionar los clientes que contengan la letra l

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE City LIKE '%me%';

--Seleccionar todos los clientes que en su nombre cominzen con o b

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE NOT CompanyName LIKE 'a%' or CompanyName LIKE 'b%';

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE NOT (CompanyName LIKE 'a%' or CompanyName LIKE 'b%');

--Seleccionar todos los clientes que comienze con b y termine con s

SELECT CustomerID, CompanyName, city, region, country
FROM Customers
WHERE CompanyName LIKE 'b%s';

SELECT 
	CustomerID, 
	CompanyName, 
	city, 
	region, 
	country
FROM Customers
WHERE CompanyName LIKE 'a__%';

--Seleccionar todos los clientes (Nombre) que comienzen con "b", "s", o "p"

SELECT 
	CustomerID, 
	CompanyName, 
	city, 
	region, 
	country
FROM Customers
WHERE CompanyName LIKE '[bsp]%';

--Seleccionar todos los customers que  comiencen con a, b,c....

SELECT 
	CustomerID, 
	CompanyName, 
	city, 
	region, 
	country
FROM Customers
WHERE CompanyName LIKE '[a-f]%'
ORDER BY 2 ASC;

SELECT 
	CustomerID, 
	CompanyName, 
	city, 
	region, 
	country
FROM Customers
WHERE CompanyName LIKE '[^bsp]%';

SELECT 
	CustomerID, 
	CompanyName, 
	city, 
	region, 
	country
FROM Customers
WHERE CompanyName LIKE '[^a-f]%'
ORDER BY 2 ASC;

--Seleccionar todos loc clientes de USA o Canada quue inicien con B 

SELECT 
	CustomerID, 
	CompanyName, 
	city, 
	region, 
	country
FROM Customers
WHERE Country IN ('USA', 'CANADA') 
and CompanyName LIKE 'b%';