USE [dbsubconsultas];
--Subconculta esscalar (un valor)

--Escalar en select

SELECT o.OrderID,
	  (od.Quantity * od.UnitPrice) AS [Total],
	  (SELECT AVG((od.Quantity * od.UnitPrice)) FROM [Order Details] AS od) AS [AVGTOTAL]
FROM Orders AS o
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID;

--Mostrar el nombre del producto y el precio promedio de todos los productos

SELECT ProductName,
	   (SELECT AVG(UnitPrice) FROM Products) AS [Precio Promedio]
FROM Products AS p;

--Mostrar cada empleado y la cantidad totaal de pedidos que tiene
SELECT e.EmployeeID, FirstName, lastname,
(
	SELECT COUNT(*)
) AS [NUMERO DE PEDIDOS]
FROM Employees AS e;

-- Corelacionada

SELECT e.EmployeeID, FirstName, lastname,
(
	SELECT COUNT(*)
	FROM Orders AS o
	WHERE e.EmployeeID = o.EmployeeID
) AS [NUMERO DE PEDIDOS]
FROM Employees AS e;

SELECT e.EmployeeID, FirstName, lastname, COUNT(o.OrderID) AS [NUMERO DE ORDENES]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, FirstName, LastName;

SELECT *
FROM Employees;

-- Mostrar cada cliente y la fecha de su ultimo pedido

--Mostrar pedidos con nombre del cliente y total del pedido (ssum)

SELECT o.OrderID, c.CompanyName, 
	   (SELECT SUM (od.Quantity * od.UnitPrice) FROM [Order Details] AS od
	   WHERE od.OrderI = o.OrderID) AS Total
FROM Orders AS o
INNER JOIN Customerss AS c
ON o.CustomerID = c.CustomerID
Order BY c.CompanyName;

-- Datos de ejemplo

CREATE DATABASE dbsubconsultas;
GO

USE dbsubconsultas;
Go

CREATE TABLE CLIENTES(
 id_cliente INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
 nombre NVARCHAR(50) NOT NULL,
 ciudad NCHAR(20) NOT NULL
)

CREATE TABLE PEDIDOS(
 id_pedido INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
 id_cliente INT NOT NULL,
 total MONEY NOT NULL,
 fecha DATE NOT NULL,
 CONSTRAINT fk_pedidos_clientes
 FOREIGN KEY (id_cliente)
 REFERENCES clientes(id_cliente)
)

INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

--Consulta escalar

--Seleccionar los pedidos en donde el total sea igual ala total sea el maximo de ellos 

SELECT MAX(total)
FROM pedidos;

SELECT *
FROM pedidos
WHERE total = (
SELECT MAX(total)
from pedidos);

SELECT TOP 1 p.id_cliente, c.nombre, p.fecha, p.total
FROM pedidos as p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.total = (SELECT MAX(total)
from pedidos);
Order BY p.total DESC;

SELECT p.id_cliente, c.nombre, p.fecha, p.total
FROM pedidos as p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.total = (SELECT MAX(total)
from pedidos);

-- Seleccionar los pedidos mayore al promedio

SELECT AVG(total)
FROM pedidos;

SELECT * 
FROM pedidos
WHERE total > (
SELECT AVG(total)
FROM pedidos
);

-- Seleccionar todoss los pedidos on del cliente que tenga el menor id 

SELECT MIN (id_cliente)
FROM pedidos;

SELECT id_cliente,	count(*) AS [Numero Pedidos]
FROM pedidos
WHERE id_cliente = (
	SELECT MIN (id_cliente)
	FROM pedidos
)
GROUP BY id_cliente;


--Mostrar los datos del pedido de la ultima orden 

SELECT MAX(fecha)
FROM pedidos;

SELECT p.id_pedido, c.nombre, p.fecha, p.total
FROM pedidos AS p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE fecha =(
SELECT MAX(fecha)
FROM pedidos
); 

--Mostrar todos los pedidos con un total que sea el mas baajo
SELECT MIN(total) AS [Total mas Bajo]
FROM pedidos;

SELECT *
FROM pedidos AS p
WHERE total = (SELECT MIN(total) AS [Total mas Bajo]
FROM pedidos);

--Seleccionar los pedidoss con el nombre del cliente ccuyo total (Freight)
-- sea maayor al promedio generalde freight 

USE NORTHWND;

SELECT AVG(Freight)
FROM Orders;

SELECT o.OrderID, c.CompanyName, o.Freight
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
WHERE o.Freight > (
	SELECT AVG(Freight)
	FROM Orders
)
ORDER BY o.Freight DESC;

SELECT o.OrderID, c.CompanyName, o.Freight, CONCAT(e.FirstName, ' ', e.LastName ) AS [FULLNAME]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE o.Freight > (
	SELECT AVG(Freight)
	FROM Orders
)
ORDER BY o.Freight DESC;

--Subqueries con IN, ANY, ALL (llevan una ssola coolumna) 
-- la clausula IN 

--CLIENTES que han hevho pedidoss 
SELECT id_cliente
FROM pedidos;

SELECT *
FROM clientes 
WHERE id_cliente IN (
SELECT id_cliente
FROM pedidos
);

SELECT DISTINCT c.id_cliente, c.nombre, c.ciudad
FROM clientes AS c
inner join pedidos AS p
ON c.id_cliente = p.id_cliente;

--Clientes que han hecho pedidos mayores a 800
	--Subconsulta

SELECT id_cliente
FROM pedidos
WHERE total > 800;
	--Consulta principal

SELECT *
FROM pedidos
WHERE id_cliente > IN (SELECT id_cliente
FROM pedidos
WHERE total > 800);

SELECT *
FROM pedidos
WHERE id_cliente IN (1,3,1);

-- Mostrar todos los clientes de la ciudad de Mexico que han hecho pedidos 

SELECT id_cliente
FROM Pedidos;

SELECT *
FROM clientes 
WHERE ciudad = 'CDMX'
AND  id_cliente IN (
	SELECT id_cliente
    FROM Pedidos
);

--Seleccionar clientes que no han hecho pedidos 

SELECT id_cliente
FROM pedidos;

SELECT *
FROM clientes 
WHERE id_cliente NOT IN(
	SELECT id_cliente
	FROM pedidos
);

SELECT c.id_cliente, c.nombre, c.ciudad 
FROM pedidos AS p
RIGHT JOIN 
clientes as c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente is null;

-- Selecconar los Pedidos de clientes de Monterrey

SELECT id_cliente
FROM clientes
WHERE ciudad = 'Monterrey';

SELECT *
FROM pedidos
WHERE id_cliente IN (
	SELECT id_cliente
	FROM clientes
	WHERE ciudad = 'Monterrey');

SELECT *
FROM pedidos AS c
LEFT JOIN pedidos AS p
ON c.id_cliente = p.id_cliente
WHERE ciudad = 'Monterrey';

--Operador ANY
-- Seleccionar pedidos mayores que algun pedido de Luis (id_cliente2)
	-- Primero la subconsulta

SELECT total
FROM pedidos 
WHERE id_cliente = 2;

	--Consulta principal

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos 
	WHERE id_cliente = 2); 

	SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	INNER JOIN 
	FROM pedidos 
	WHERE id_cliente = 2); 

--Seleccionar los pedidos mayores (total) de algun pedido de Ana
	--Subconsulta
SELECT total
FROM pedidos 
WHERE id_cliente = 1;

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos 
	WHERE id_cliente = 1); 

-- Seleccionar los pedidos mayores que algun pedido superior a 500
SELECT total
FROM pedidos 
WHERE total > 500

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos 
	WHERE total > 500);

--ALL

--	Seleccionar los pedidos donce el total sea mayor a todos los totales de los pedidos de Luis
SELECT total
FROM pedidos
WHERe id_cliente = 2;

SELECT total
FROM pedidos;

SELECT *
FROM pedidos
WHERE total > ALL (
SELECT total
FROM pedidos
WHERe id_cliente = 2
);

-- Seleccionar todos los clientes donde su id sea menor que todos los clientes de la ciudad de Mexico

SELECT *
FROM clientes
WHERE id_cliente < ALL (
SELECT total
FROM clientes
WHERE ciudad = 'CDMX');

-- Subconsultas correlacionadas 

SELECT SUM(total)
FROM pedidos as p;

SELECT *
FROM clientes as c
WHERE (SELECT SUM(total)
FROM pedidos as p
WHERE p.id_cliente = c.id_cliente) > 1000;

SELECT SUM(total)
FROM pedidos as p
WHERE p.id_cliente = 2;


--Seleccionar todos los clientes que han hecho mas de un pedido

SELECT COUNT(*)
FROM pedidos AS p
WHERE id_cliente = 2;

SELECT *
FROM clientes AS c
WHERE(
SELECT COUNT(*)
FROM pedidos AS p
WHERE id_cliente = c.id_cliente
)>1;

--Seleccionar todos los pedidos en donde su total debe ser mayor al promedio de los totales hechos por los clientes 

SELECT AVG(total) AS [promedio del total]
FROM pedidos AS p
WHERE p.id_cliente =;

SELECT *
FROM pedidos AS p 
WHERE total > (
SELECT AVG(total)
FROM pedidos AS pe
WHERE pe.id_cliente = p.id_cliente
);

--Selecionar todos lo clientes cuyo pedido maximo sea mayor a 1200

SELECT MAX(total)
FROM pedidos as p
WHERE p.id_cliente =

SELECT *
FROM clientes AS c
WHERE (
SELECT MAX(total)
FROM pedidos as p
WHERE p.id_cliente = c.id_cliente
) > 1200;

SELECT * FROM pedidos;
SELECT * FROM clientes;

