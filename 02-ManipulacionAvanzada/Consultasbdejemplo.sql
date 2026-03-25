use bdejemplo;

SELECT * FROM Clientes;
SELECT * FROM Representantes ;
SELECT * FROM Oficinas;
SELECT * FROM Productos;
SELECT * FROM pedidos;

--- crear una vista que visualice el total de los importes agrupados por productos 
CREATE OR ALTER VIEW vw_importes_productos 
AS
SELECT pr.Descripcion AS [NOMBRE DEL PRODUCTO],
      SUM (p.Importe) AS [Total],
      SUM (P.Importe * 1.15) AS [ImportrDescuento]
FROM Pedidos AS p
INNER JOIN Productos AS pr
ON p.Fab =pr.Id_fab
AND p.PRODUCTO = pr.Id_producto
GROUP BY pr. Descripcion;

SELECT *
FROM vw_importes_productos
WHERE [Nombre del producto] LIKE '%brazo'
AND ImportrDescuento > 34000;
GO


--seleccionar los nombres de los representantes y de las oficinas de donde trabajan
CREATE OR ALTER VIEW vw_oficinas_representantes AS
SELECT 
r.Nombre, 
r.Ventas AS [ventasrepresentantes], 
o.Ciudad, 
o.Region, 
o.Ventas AS [ventasoficinas]
FROM  Representantes as r
INNER JOIN Oficinas as o
ON r.Oficina_Rep = o.Oficina;

SELECT *
FROM Representantes
WHERE Nombre = 'Daniel Ruidrobo';

SELECT NOMBRE, Ciudad
FROM vw_oficinas_representantes
ORDER BY nombre DESC;

--Seleccionar los pedidos con fecha e importe, el nombre del representante 
--que lo realizo y el cliente que lo solicito

SELECT p.Num_Pedido, p.Fecha_Pedido, p.Importe, c.Empresa, r.Nombre
FROM Pedidos AS p
INNER JOIN 
Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = p.Rep;

SELECT p.Num_Pedido, p.Fecha_Pedido, p.Importe, c.Empresa, r.Nombre
FROM Pedidos AS p
INNER JOIN 
Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = c.Rep_Cli

--Seleccionar los pedidos con fecha e importe, el nombre del representante 
--que ATENDIO y el cliente que lo solicito

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

--Mostrar el número de cliente, nombre de empresa 
--y límite de crédito de los clientes cuyo límite de crédito esté entre 10,000 y 30,000.
SELECT Num_Cli, Empresa, Limite_Credito
FROM Clientes
WHERE Limite_Credito BETWEEN 10000 AND 30000;

--Mostrar todos los representantes cuyo nombre empiece con la letra "A" 
--y cuya cuota sea mayor a 50,000.
SELECT *
From Representantes
WHERE Cuota > 50000 AND NOMBRE LIKE '%A';

--Mostrar el cliente, número de pedido y cantidad de los pedidos cuya cantidad sea mayor a 20.
SELECT Cliente, Num_Pedido, Cantidad
FROM Pedidos
WHERE Cantidad > 20;

--Mostrar los productos cuyo precio esté entre 50 y 200, ordenados de menor a mayor precio.
SELECT *
FROM Productos
WHERE Precio BETWEEN 50 AND 200
Order by Precio ASC;

--Mostrar el cliente y el representante que lo atiende.
SELECT Num_Cli, Rep_Cli, Nombre AS [Nombre Empleado], Puesto
FROM Clientes AS c
INNER JOIN Representantes AS r
ON c.Rep_Cli = Num_Empl;

--Mostrar cliente, número de pedido y producto comprado.
SELECT c.Num_Cli, Num_Pedido, Id_producto
FROM Clientes AS c
INNER JOIN Pedidos AS pe
ON c.Num_Cli = pe.Cliente
INNER JOIN Productos as pr
ON pe.Producto = pr.Id_producto;

--Mostrar los clientes que pertenecen a las oficinas 11, 12 o 13.
SELECT c.Num_Cli, r.Oficina_Rep 
FROM Representantes AS r
INNER JOIN Clientes AS c
ON r.Num_Empl = c.Rep_Cli
WHERE r.Oficina_Rep IN (11, 12, 13);

--Mostrar los productos cuyo nombre contenga la palabra "Pro".
SELECT *
FROM Productos
WHERE Descripcion LIKE '%Pro%';

--Mostrar el total vendido por cada representante.
SELECT Rep, SUM(Cantidad) AS [Total Vendido]
FROM Pedidos
GROUP BY Rep;

--Mostrar el promedio de importe de pedidos por cliente.
SELECT Cliente, AVG(Importe) AS [Promedio de importe]
FROM Pedidos
GROUP BY Cliente;

--Mostrar los representantes que hayan vendido más de 100,000.
SELECT Rep, SUM(Importe) AS [Ventas de Representante]
FROM Pedidos
GROUP BY Rep
HAVING SUM(Importe) > 100000;

-- Mostrar el cliente y el total de dinero que ha comprado.
SELECT Cliente, SUM(Importe)
FROM Pedidos
GROUP BY Cliente;

--Mostrar el número de pedido, cantidad, importe y el total calculado.
SELECT Num_Pedido, Cantidad, Importe, (Cantidad * Importe) AS [Total Calculado]
FROM Pedidos;

--Mostrar las oficinas y el promedio de ventas de sus representantes.
SELECT 
o.Oficina,
AVG(p.Importe) AS Promedio_Ventas
FROM Oficinas o
INNER JOIN Representantes r
ON o.Oficina = r.Oficina_Rep
INNER JOIN Pedidos p
ON r.Num_Empl = p.Rep
GROUP BY o.Oficina;
/*
--Mostrar los representantes que trabajan en oficinas del norte o sur y cuya cuota sea mayor a 40,000.
SELECT *
FROM Representantes as r
INNER JOIN Oficinas as o
ON r.Jefe = o.Oficina
WHERE (Region = 'Norte' OR Region = 'Sur')
AND Cuota > 40000;

--Mostrar los productos vendidos con su precio, cantidad y total de venta.
SELECT 
Producto,
Cantidad,
Importe,
Cantidad * Importe AS Total_Venta
FROM Pedidos;
--Mostrar los clientes que han realizado más de 3 pedidos.
SELECT Cliente, COUNT(*) AS Numero_Pedidos
FROM Pedidos
GROUP BY Cliente
HAVING COUNT(*) > 3;
--Mostrar los representantes cuyo nombre termine con "ez".
SELECT *
FROM Representantes
WHERE Nombre LIKE '%ez';
--Mostrar: cliente, representante, número de pedido, producto, cantidad, importe, total calculado
SELECT 
c.Empresa AS Cliente,
r.Nombre AS Representante,
p.Num_Pedido,
pr.Descripcion AS Producto,
p.Cantidad,
p.Importe,
(p.Cantidad * p.Importe) AS Total
FROM Pedidos p
INNER JOIN Clientes c
ON p.Cliente = c.Num_Cli
INNER JOIN Representantes r
ON p.Rep = r.Num_Empl
INNER JOIN Productos pr
ON p.Fab = pr.Id_fab
AND p.Producto = pr.Id_producto;*/













/*Resumen de la base de datos

Esta base de datos representa un sistema de ventas de una empresa.
Su objetivo es registrar clientes, representantes de ventas, productos, oficinas y los pedidos que realizan los clientes.

Cada tabla almacena un tipo de información diferente, y se relacionan entre sí mediante claves primarias (PK) y claves foráneas (FK).

Tablas principales
Clientes

La tabla Clientes guarda la información de las empresas o personas que compran productos.

Información que contiene normalmente:

número de cliente

nombre de la empresa

límite de crédito

representante asignado

Clave primaria:

Num_Cli

Relación importante:

Rep_Cli conecta al cliente con un representante.

Pedidos

La tabla Pedidos registra cada compra realizada por un cliente.

Información que contiene:

número de pedido

cliente que realizó el pedido

representante que atendió

producto comprado

cantidad

importe

Esta tabla es el centro de la base de datos, porque conecta clientes, representantes y productos.

Productos

La tabla Productos guarda la información de los productos que vende la empresa.

Información que contiene:

fabricante

identificador del producto

descripción

precio

Clave primaria compuesta:

Id_fab

Id_producto

Esto significa que un producto se identifica por el fabricante y su número de producto.

Representantes

La tabla Representantes almacena la información de los vendedores de la empresa.

Información que contiene:

número de empleado

nombre

oficina donde trabaja

cuota de ventas

jefe

Clave primaria:

Num_Empl

Oficinas

La tabla Oficinas contiene información sobre las sucursales de la empresa.

Información que contiene:

número de oficina

ciudad

región

objetivo de ventas

Clave primaria:

Oficina

Cómo se relacionan las tablas

Las tablas se conectan mediante claves foráneas.

Clientes > Representantes

Cada cliente tiene un representante asignado.

Relación:

Clientes.Rep_Cli > Representantes.Num_Empl

Esto significa que un representante puede atender a muchos clientes.

Relación: uno a muchos.

Clientes > Pedidos

Cada pedido pertenece a un cliente.

Relación:

Pedidos.Cliente > Clientes.Num_Cli

Esto significa que un cliente puede realizar muchos pedidos.

Relación: uno a muchos.

Representantes> Pedidos

Cada pedido es atendido por un representante.

Relación:

Pedidos.Rep > Representantes.Num_Empl

Esto permite saber qué vendedor realizó la venta.

Representantes >Oficinas

Cada representante trabaja en una oficina.

Relación:

Representantes.Oficina_Rep ? Oficinas.Oficina

Esto indica en qué sucursal trabaja el vendedor.

Pedidos > Productos

Los pedidos indican qué producto se vendió.

Relación:

Pedidos.Fab > Productos.Id_fab
Pedidos.Producto > Productos.Id_producto

Esto identifica qué producto se compró en cada pedido.

Flujo general de la base de datos

El funcionamiento general es el siguiente:

La empresa tiene oficinas.

En cada oficina trabajan representantes de ventas.

Los representantes atienden clientes.

Los clientes realizan pedidos.

Cada pedido contiene productos vendidos.

Estructura general

La relación entre las tablas se puede entender así:

Oficinas

Representantes

Clientes

Pedidos

Productos

Idea principal del sistema

La base de datos permite:

Registrar quién vende (representantes)

Registrar quién compra (clientes)

Registrar qué se vende (productos)

Registrar cuándo se vende (pedidos)

Analizar ventas por cliente, representante u oficina

Esto permite hacer consultas como:

ventas totales por representante

clientes con más compras

productos más vendidos

ventas por oficina*/