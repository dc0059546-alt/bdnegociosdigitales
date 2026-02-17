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

