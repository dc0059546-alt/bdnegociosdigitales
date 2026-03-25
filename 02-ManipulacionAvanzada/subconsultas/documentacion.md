# ¿Que es una subconsulta?

Una subconsulta es un select dentro de otro select. Puede devolve:

1. Un solo valor (escalar)
1. Una listaa de valores (una columna, varias filas)
1.  Una tabla, (variascolumnas y/o varias filas)
1. Segun lo que devuelva, se elige el operador correcto (=, IN, EXISTS, etc).

Una subconsulta es una consukta anidada dentro de otra consulta
que permite resolver problemas en varios niveles de informacion 

```
Dependiendo de donde se coloque y que retorne,
cambia su comportamiento 

```

5 grandes formas de usarlas:
1. subconsultas escalares.
2. subconsultas con IN, ALL.
3. subconsultas correlacionadas.
4. subconsultas en select.
5. subconsultas en from (Tbalas derivadas).

1. Escalares:

Devueolven un unico valor, por eso se pueden utilizar
con operadores =,<,>.


Ejemplo: 

```sql
SELECT *
FROM pedidos
WHERE total = (
SELECT MAX(total)
from pedidos);
```

## Subconsulta con IN, ANY, ALL.

Devuelvee varios valores con una sola columna (IN)
>Seleccionar todos los clientes 
 ```sql
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
 ```

 ## Clausula ANY

 - Compara un valor contra una lista
 -La condicion se cumple si se cumple con al menos 1

 ```sql
 valor > ANY (subconsulta)
 ```

 >Es como decir: Mayor que al menos uno de los valores 

 - Seleccionar pedidos mayores que algun pedido de Luis (id_cliente2)

 ```sql
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
 ```

 ## Subconsultas correlacionadas 

 >Una subconsulta correlacionada depende de la fila actual de la consulta principal y se ejecuta una vez por cada fila 

 ---
1. Seleccionar los clientes cuyo total de compras sea mayor a 1000