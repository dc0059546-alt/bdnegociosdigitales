-- CREA UNA BASE DE DATOS
CREATE DATABASE tienda;
GO

use tienda;

-- CREAR TABLA CLIENTE
 CReATE TABLE cliente (
 id int not null,
 nombre nvarchar(30) not null,
 apaterno nvarchar(10) not null,
 amaterno nvarchar(10) null,
 sexo nchar (1)not null,
 edad int not null,
 direccion nvarchar(80) not null,
 rfc nvarchar(20) not null,
 limitecredito money not null DEFAULT 500.0
 );
 GO

 --Restriciones
 CREATE TABLE clientes (
 cliente_id INT not null PRIMARY KEY,
 nombre NVARCHAR(30) NOT NULL,
 apellido_paterno NVARCHAR(20) NOT NULL,
 apellido_materno NVARCHAR (20),
 edad INT NOT NULL,
 fecha_nacimiento DATE NOT NULL,
 limite_credito MONEY NOT NULL
 );
 GO

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

 SELECT GETDATE (); --obtiene la fecha del sistema
 
 CREATE TABLE Clientes_2(
 cliente_id INT NOT NULL identity(1,1),
 nombre NVARCHAR (50) NOT NULL,
 edad INT NOT NULL,
 fecha_registro DATE DEFAULT GETDATE(),
 limite_credito MONEY NOT NULL
 CONSTRAINT pk_clientes_2
 PRIMARY KEY (cliente_id),
 );

 SELECT *
 FROM clientes_2;

INSERT INTO  Clientes_2
VALUES ('Chespirito', 89,DEFAULT, 45500);

INSERT INTO  Clientes_2 (nombre, edad, limite_credito)
VALUES ('Batman',45, 89000);

INSERT INTO  Clientes_2 
VALUES ('Robin',45,'2026-01-19', 89.32);

INSERT INTO  Clientes_2 (limite_credito, edad, nombre, fecha_registro)
VALUES (12.33, 24,'Flash Reverso','2026-01-21');

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

SELECT *
FROM suppliers;

INSERT INTO suppliers
VALUES (1,UPPER('bimbo'), DEFAULT,UPPER('c'), 45000);

INSERT INTO suppliers
VALUES (2,UPPER('tia rosa'), '2026-01-21',UPPER('a'), 49999.999);

INSERT INTO suppliers (name, tipo, credit_limit)
VALUES (3,UPPER('tia mensa'),UPPER('a'), 49999.999);

--CREAR BASE DE DATOS
CREATE DATABASE dborders;
GO

USE dborders;
GO

--CREAR TABLA CUSTUMERS
CREATE TABLE  customers (
customer_id INT NOT NULL IDENTITY (1,1),
first_name NVARCHAR (20) NOT NULL,
last_name NVARCHAR (30),
[address] NVARCHAR (80) NOT NULL,
number int,
CONSTRAINT pk_customers
PRIMARY KEY (customer_id)
);
GO

CREATE TABLE products (
product_id INT NOT NULL IDENTITY (1,1),
[name] NVARCHAR (40) NOT NULL,
quantity int NOT NULL,
unit_price MONEY NOT NULL,
supplier_id INT,
CONSTRAINT unique_name_products
UNIQUE ([name]),
CONSTRAINT chk_quantity
CHECK (quantity BETWEEN 1 AND 100),
CONSTRAINT chk_unitprice
CHECK (unit_price > 0 and unit_price <=100000),
CONSTRAINT fk_products_suppliers
FOREIGN KEY (supplier_id)
REFERENCES suppliers (supplier_id)
ON DELETE SET NULL
ON UPDATE NO ACTION
);
GO

DROP TABLE products
DROP TABLE suppliers
---------------------------------------------------------------------- SET NULL-------------------------------------------------
DROP TABLE products

CREATE TABLE products (
product_id INT NOT NULL IDENTITY (1,1),
[name] NVARCHAR (40) NOT NULL,
quantity int NOT NULL,
unit_price MONEY NOT NULL,
supplier_id INT,
CONSTRAINT unique_name_products
UNIQUE ([name]),
CONSTRAINT chk_quantity
CHECK (quantity BETWEEN 1 AND 100),
CONSTRAINT chk_unitprice
CHECK (unit_price > 0 and unit_price <=100000),
CONSTRAINT fk_products_suppliers
FOREIGN KEY (supplier_id)
REFERENCES suppliers (supplier_id)
ON DELETE SET NULL
ON UPDATE NO ACTION
);
GO

ALTER TABLE products
DROP CONSTRAINT  fk_products_suppliers;

DROP TABLE suppliers
--DROP TABLE products;

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
GO

UPDATE products 
SET supplier_id = NULL;

INSERT INTO suppliers
VALUES (1,UPPER('Chino S.A.'), DEFAULT,UPPER('c'), 45000);

INSERT INTO suppliers
VALUES (2,UPPER('Chanclotas'), '2026-01-21',UPPER('a'), 49999.999);

INSERT INTO suppliers (supplier_id,name, tipo, credit_limit)
VALUES (3,UPPER('rama-ma'),UPPER('a'), 49999.999);

SELECT*
FROM suppliers; 

INSERT INTO products
VALUES('papas', 10 , 5.3, 1);

INSERT INTO products
VALUES('rollo primavera', 20 , 100, 1);

INSERT INTO products
VALUES('Clanclas pata de gallo', 50 , 20, 10);

INSERT INTO products
VALUES('Chanclas buenas', 30 , 56.7, 10),
       ('Ramita chiquita', 56,78.23,3)

INSERT INTO products
VALUES('Azulito', 100 , 15.3, NULL);

--comprobacion de un delete no action

--eliminar los hijos

DELETE FROM products
WHERE supplier_id = 1;

DELETE FROM products
WHERE product_id = 4;

-- eliminar al padre

DELETE FROM SUPPLIERS
WHERE supplier_id = 1;

SELECT*
FROM products;
SELECT*
FROM suppliers; 
GO

ALTER TABLE products
ALTER COLUMN supplier_id INT NULL;
--comprobar el UPDATE NO ACTION

UPDATE products
SET supplier_id = Null
WHERE supplier_id  = 2;

UPDATE suppliers
SET supplier_id = 10 WHERE supplier_id = 2;

DELETE FROM products 
WHERE supplier_id = 1;

UPDATE products
SET supplier_id = 2
WHERE product_id IN (1006,1007):

UPDATE products
SET supplier_id = 2
WHERE product_id = 1006
OR product_id = 1007;

UPDATE products
SET supplier_id = 2
WHERE product_id = 1008;

SELECT*
FROM products;
SELECT*
FROM suppliers;

UPDATE suppliers
SET supplier_id = 10
WHERE supplier_id = 2;

UPDATE products
SET supplier_id = 10
WHERE product_id IN (3,4);

--------------Comprobar ON DELETE SET N ULL
DELETE suppliers 
WHERE supplier_id = 10

-- Comprobar ON UPDARTE SET NULL

UPDATE suppliers
set supplier_id = 20
WHERE supplier_id = 1;

SELECT *
FROM products;
SELECT*
FROM suppliers;