/*
Funciones Agregado:

1.sum()
2.max()
3.min()
4.avg()
5.count(*)
6.count(campo)

Nota: Rstas funciones solo regresan un solo registro

*/

--Seleccionar los paises de donde son los clientes (DISTINCT borra los repetidos)

SELECT Distinct Country
FROM Customers;

--Agregacion count(*) cuenta el numero de registros que tiene una tabla

SELECT COUNT(*) AS [Total Ordenes]
FROM Orders;

SELECT *
FROM Customers;

SELECT count(CustomerID)
FROM Customers;

SELECT count(Region)
FROM Customers;

-- Selecciona de cuantas ciudades son las ciudades de los clientes 

SELECT city
FROM Customers
Order by city ASC;

SELECT count(city)
FROM Customers;

SELECT DISTINCT (city)
FROM Customers
Order by city ASC;

SELECT COUNT (DISTINCT city) AS [Ciudades CLIENTES]
FROM Customers;

--Selecciona el precio mas alto de los productos

SELECT *
FROM Products
ORDER BY UnitPrice DESC;

SELECT MAX(UnitPrice) AS [Precio mas alto]
FROM Products;

--Seleccionar el total de ordenes que fueron enviadas a Alemania

SELECT COUNT(*) AS [Total de ordenes]
FROM Orders
WHERE ShipCountry = 'Germany';

SELECT shipcountry, COUNT(*) AS [Total de ordenes]
FROM Orders
GROUP BY shipcountry;

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

--Cual es la minima cantidad de los pedidos

SELECT MIN (UnitPrice) AS [Minima cantidad de productos]
FROM [Order Details];

--Cual es el importe mas bajo de  las compras 

SELECT (UnitPrice * Quantity * (1-Discount)) AS Importe
FROM [Order Details]
ORDER BY Importe ASC;

SELECT (UnitPrice * Quantity * (1-Discount)) AS Importe
FROM [Order Details]
ORDER BY (UnitPrice * Quantity * (1-Discount)) ASC;

SELECT 
	MIN ((UnitPrice * Quantity * (1-Discount))) AS [Importe mas bajo]
FROM [Order Details];

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

/*
Selecciona el numero de ordenes hechas por los siguientes clientes
Around the Horn
Bolido Comidas preparadas
Chop-suey Chinese
*/

SELECT COUNT (*)
FROM Orders
WHERE CustomerID IN ('AROUT', 'BOLID', 'CHOPS');

SELECT *
FROM Customers;

--Seleccionar el total de ordenes del segundo trimestre de 1995

SELECT COUNT (*)
FROM Orders
WHERE datepart(q, OrderDate) = 3
AND DATEPART(YEAR, OrderDate) = 1995 

-- Seleccionar el numero de ordenes entre 1996 a 1997

SELECT COUNT(*) AS [Numero de Ordenes]
FROM Orders
WHERE DATEPART(YEAR ,OrderDate) BETWEEN 1996 AND 1997;

--Seleccionar el numero de clientes que comienza con A o B

SELECT COUNT(*) AS[Numer de Clientes]
FROM Customers
WHERE companyName LIKE 'a%b%'
OR companyName LIKE 'b%';

--Seleccionaar el numero de clientes que comienzen con b y que terminan con s

SELECT COUNT(*) AS[Numer de Clientes]
FROM Customers
WHERE companyName LIKE 'b%s';

--Seleccionar el numero de ordenes realizadas por el cliente Chop-suey Chinese en 1996

SELECT *
FROM Customers
WHERE CompanyName = 'Chop-suey Chinese';

SELECT COUNT(*) AS [Numeroo de Ordenes], 
sum(OrderID) AS [Suma de las ordenes]
FROM Orders
WHERE CustomerID = 'CHOPS'
AND YEAR(OrderDate) = 1996;

/*
	GROUP BY Y HAVING 
*/

SELECT 
	customerid, 
	COUNT (*) AS [Numero de Ordenes]
FROM Orders
GROUP BY CustomerID
Order BY 2 DESC;


SELECT 
	Customers.CompanyName, 
	COUNT (*) AS [Numero de Ordenes]
FROM Orders
INNER JOIN Customers 
ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.CompanyName
Order BY 2 DESC;


SELECT 
	C.CompanyName, 
	COUNT (*) AS [Numero de Ordenes]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
Order BY 2 DESC;

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

/*Seleccionar el precio promedio del proveedor de los productos

SELECT SupplierID
FROM Supplier;*/
/*redondear a doss decimales el resultado
Y ordenar de forma descendente por el precio promedio*/

/*
Seleccionar el numero de clientes por pais yordenarlos por pais alfabeticamente 
*/

/*
Obtener la cantidad total po producto y por pedido
*/

SELECT *
FROM [Order Details];

SELECT *, (UnitPrice * Quantity) AS [Cantidad Total]
FROM [Order Details]

SELECT SUM (UnitPrice * Quantity) AS [Cantidad Total]
FROM [Order Details]

SELECT ProductID, SUM (UnitPrice * Quantity) AS [Cantidad Total]
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID;

SELECT ProductID,OrderID,SUM (UnitPrice * Quantity) AS [Cantidad Total]
FROM [Order Details]
GROUP BY ProductID, OrderID
ORDER BY ProductID, [Cantidad Total] DESC

SELECT *, (UnitPrice * Quantity) AS [Total]
FROM [Order Details]
WHERE OrderID = 10847 
AND ProductID = 1


/*
Seleccionar la cantidad maxima vendida por producto en cada pedido
*/

SELECT ProductID, OrderID, MAX(Quantity) AS [Cantidad Maxima]
FROM [Order Details]
group by ProductID, OrderID
Order by ProductID, OrderID;


/*
	Flujo Logigo de ejecucion de sql

	1.From
	2.Join
	3.Where
	4.Gruop By
	5.Having
	6.Select
	7.Distinct
	8.Order By
*/

--Having (filtro de grupos)
/*
Seleccionar los clientes que hayan realizado mas de diez pedidos
*/

SELECT CustomerID, COUNT(*) AS [Numero de ordenes ]
FROM Orders
GROUP BY CustomerID
ORDER BY 2 DESC;

SELECT CustomerID, ShipCountry, COUNT(*) AS [Numero de ordenes ]
FROM Orders
WHERE ShipCountry IN('Germany', 'France', 'Brazil')
GROUP BY CustomerID, ShipCountry
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

SELECT c.CompanyName, COUNT(*) AS [Numero de ordenes ]
FROM Orders AS o
INNER JOIN Customers AS c ON  o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

SELECT CustomerID, COUNT(*) AS [Numero de ordenes ]
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 10
ORDER BY 2 DESC;


/*
Seleccionarr los empleados que hayan gestionado pedidos por un total superior a 50,000 en ventas 
(Mostrar el nombre del empleado, el id, y el total de compras )
*/

SELECT *
FROM Employees AS e
INNER JOIN Orders AS o 
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID;

SELECT 
	CONCAT (e.FirstName,' ',e.LastName) AS [Nombre Completo], 
	(od.Quantity * od.UnitPrice * (1- od.Discount)) AS IMPORTE
FROM Employees AS e
INNER JOIN Orders AS o 
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
ORDER BY e.FirstName ASC;

SELECT 
	CONCAT (e.FirstName,' ',e.LastName) AS [Nombre Completo], 
	ROUND(SUM(od.Quantity * od.UnitPrice * (1- od.Discount)), 2) AS IMPORTE
FROM Employees AS e
INNER JOIN Orders AS o 
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
GROUP BY e.FirstName, e.LastName
HAVING SUM(od.Quantity * od.UnitPrice * (1- od.Discount))>100000
ORDER BY [IMPORTE] DESC;

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

/*
SELECCIONAR el precio maximo de productos por categoria solo si la suma de unidades es menor a 200 
Ademas que no esten descontinuados 
*/

SELECT 
c.CategoryID,
c.CategoryName,
p.ProductName,
MAX(p.UnitPrice) AS [Precio Maximo]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0
GROUP BY c.CategoryID,
		 c.CategoryName,
		 p.ProductName
HAVING SUM(p.UnitsInStock) < 200
ORDER BY CategoryName DESC, P.ProductName ASC;
