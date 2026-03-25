
/*
Clientes 
PK: Num_cli
FK(pedidos): Cliente

Productos:
PK: id_fab
PK: id_producto
FK(pedido): Fab
FK(pedido): Producto

Representantes: 
PK(Clientes/Pedidos/Oficinas): Num_Empl
FK(Clientes): Rep_Cli
FK(Pedidos): Rep
FK(Oficinas): Jef

Oficinas:
PK: Oficina
FK(Representantes): Oficina_Rep
*/
use bdejemplo;
--C1
SELECT Num_Pedido, Fecha_Pedido, Nombre, Puesto, Importe
FROM Representantes AS r
INNER JOIN Pedidos AS p
ON r.Num_Empl = p.Rep 
WHERE Puesto = 'Jefe Ventas'
Order BY Importe DESC;
--C2

--C3
SELECT Fab, Producto, SUM(Cantidad) AS [Total Unidades], SUM(Importe) AS [Total Importe]
FROM Pedidos
GROUP BY Fab, Producto
Order By SUM(Importe) DESC;

--C4 
SELECT Num_Empl, Nombre, Num_Pedido, SUM(Importe) AS [Total Importe]
FROM Representantes AS r
INNER JOIN Pedidos AS p
ON r.Num_Empl = p.Rep
GROUP BY Num_Empl, Nombre, Num_Pedido
HAVING SUM(Importe) >= 20000 AND SUM(Importe) > 20000
Order by SUM(Importe) DESC

--C5**
SELECT Distinct  Empresa
FROM Productos AS pr
INNER JOIN Pedidos AS p
ON p.Producto = pr.Id_producto
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
WHERE Descripcion LIKE 'Serie%' AND p.Producto = '41004' OR p.Producto = '41003' OR p.Producto = '41002';

SELECT Distinct  Empresa
FROM Productos AS pr
INNER JOIN Pedidos AS p
ON p.Producto = pr.Id_producto
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
WHERE p.Producto = '41004' OR p.Producto = '41003' OR p.Producto = '41002';

SELECT Distinct  Empresa, pr.Id_producto, pr.Descripcion
FROM Productos AS pr
INNER JOIN Pedidos AS p
ON p.Producto = pr.Id_producto
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
WHERE p.Producto = '41004' OR p.Producto = '41003' OR p.Producto = '41002';

--C6

--C7
CREATE OR ALTER VIEW vw_PedidoFull_C 
AS
SELECT pe.Num_Pedido, pe.Fecha_Pedido, pe.Rep, c.Empresa, o.Ciudad, o.Region, pr.Descripcion, pe.Cantidad, pe.Importe
FROM Pedidos AS pe
INNER JOIN Productos AS pr
ON pe.Producto = pr.Id_producto
INNER JOIN Clientes AS c
ON c.Num_Cli = pe.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = pe.Rep
INNER JOIN Oficinas AS o
ON r.Num_Empl = o.Jef;

select *
from vw_PedidoFull_C;


--C8