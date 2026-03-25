/*
JOINS

1. INNER JOIN
2. LEFT JOIN
3. RIGHT JOIN
4. FULL JOIN
*/

-- Seleccionar las categorias y sus productosd

SELECT 
	categories.CategoryID, 
	Categories.CategoryName,
	Products.ProductID,
	Products.ProductName,
	Products.UnitPrice,
	Products.UnitsInStock,
	(products.UnitPrice * products.UnitsInStock)
	AS [Precio Inventario]
FROM Categories
INNER JOIN Products
ON categories.CategoryID = products.CategoryID
WHERE categories.CategoryID = 9;


--Crear unatabla a partir de una consulta 
SELECT TOP 0 CategoryID, CategoryName 
INTO categoria 
FROM Categories;

ALTER TABLE categoria
ADD CONSTRAINT pk_categoria
Primary Key (CategoryId);

INSERT INTO categoria 
VALUES ('C1'),('C2'),('C3'),('C4'),('5'); 


SELECT TOP 0
	ProductID AS [numero_producto],
	ProductName AS [nombre_producto],
	CategoryID AS [catego_id]
INTO producto
FROM Products;

ALTER TABLE producto
ADD CONSTRAINT pk_producto
PRIMARY KEY (numero_producto);

ALTER TABLE producto
ADD CONSTRAINT fk_producto_categoria
FOREIGN KEY (catego_id)
REFERENCES categoria (CategoryID)
ON DELETE CASCADE;

INSERT INTO  producto
VALUES ('P1', 1), 
	   ('P2', 1), 
	   ('P3', 2), 
	   ('P4', 2), 
	   ('P5', 3), 
	   ('P6', NULL);

--INNER JOIN 

SELECT *
FROM categoria AS c 
INNER JOIN 
producto AS p
ON c.CategoryID = p.catego_id;

--Left Join

SELECT *
FROM categoria AS c 
LEFT JOIN 
producto AS p
ON c.CategoryID = p.catego_id;

--RIGHT JOIN 

SELECT *
FROM categoria AS c 
RIGHT JOIN 
producto AS p
ON c.CategoryID = p.catego_id;


--FULL JOIN

SELECT *
FROM categoria AS c 
FULL JOIN 
producto AS p
ON c.CategoryID = p.catego_id;

-- Simular el right join de la query antterior con un lef join 

/*SELECT c.CategoryID, c.CategoryName,
	   p.numero_producto, p.nombre_producto,
	   p.catego_id;
FROM categoria AS c 
RIGHT JOIN 
producto AS p
ON c.CategoryID = p.catego_id;

SELECT c.CategoryID, c.CategoryName,
p.numero_producto, p.nombre_producto,
p.catego_id;
FROM categoria AS c 
LEFT JOIN 
producto AS p
ON c.CategoryID = p.catego_id;*/

--VIsualiza todas las categorias que no tienen productos 

SELECT *
FROM categoria AS c 
LEFT JOIN 
producto AS p
ON c.CategoryID = p.catego_id
WHERE numero_producto is null;

--Seleccionar todos los productoss que no tienen categoria 

SELECT *
FROM categoria AS c 
RIGHT JOIN 
producto AS p
ON c.CategoryID = p.catego_id
WHERE c.CategoryID is null;

SELECT *
FROM  producto AS p
LEFT JOIN 
categoria AS c
ON c.CategoryID = p.catego_id
WHERE c.CategoryID is null;

--Guardar en una tabla de productos nuevos todos aquellos que fueron agregados recientemente 
-- y no estan en esta tabla de apoyo 

--Crear tabla products_new a traves de Produucts, mediante una consulta
SELECT 
	TOP 0
	ProductID  AS [product_number],
	ProductName AS [product_name],
	UnitPrice AS [unit_price],
	UnitsInStock AS [stock],
	(UnitPrice * UnitsInStock) AS [total] 
INTO products_new
FROM Products;

ALTER TABLE products_new
ADD CONSTRAINT pk_products_new
PRIMARY KEY ([product_number]);

SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock,
	   (p.UnitPrice * p.UnitsInStock) as Total, 
	   pw.*
FROM Products AS p
LEFT JOIN products_new as pw
ON p.ProductID = pw.product_number;


SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock,
	   (p.UnitPrice * p.UnitsInStock) as Total
FROM Products AS p
LEFT JOIN products_new as pw
ON p.ProductID = pw.product_number
WHERE pw.product_number is null;

SELECT *
FROM products_new;

SELECT * 
FROM categoria;

SELECT *
FROM Producto;

--Mostrar el nombre del cliente y la fecha de su pedido
SELECT o.CustomerID, o.OrderID, c.CompanyName 
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID;

--Mostrar los pedidos con el nombre del empleado que los atendió
SELECT OrderID, CONCAT(FirstName,' ', LastName) AS [Empleado]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID = e.EmployeeID

--Mostrar los productos con el nombre de su proveedor
SELECT p.ProductID, s.CompanyName, p.UnitPrice
FROM Products AS p
INNER JOIN Suppliers AS s
ON p.SupplierID = s.SupplierID

--Mostrar el cliente, el número de pedido y el empleado que atendió el pedido
SELECT CompanyName, OrderID, CONCAT(FirstName,' ', LastName) AS [Empleado]
FROM Customers AS c
INNER JOIN Orders as o
ON c.CustomerID = o.CustomerID
INNER JOIN Employees AS e
ON o.EmployeeID = e.EmployeeID

--Mostrar el nombre del producto y la categoría a la que pertenece
SELECT p.ProductName, p.CategoryID, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID = c.CategoryID
--Mostrar cliente, producto y cantidad comprada
--Mostrar el empleado y cuántos pedidos ha realizado (usar GROUP BY)
SELECT CONCAT(FirstName, ' ', LastName) AS [Empleado], COUNT(OrderID) AS [Numero de pedidos]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
GROUP BY CONCAT(FirstName, ' ', LastName);
--Mostrar el producto, categoría y proveedor

--Mostrar: Cliente Número de pedido Producto Cantidad Precio

