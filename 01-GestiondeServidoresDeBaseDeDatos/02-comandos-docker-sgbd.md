# Documentacion de contenedores docker para SGBD

## Contendeores sin volumen


```shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name  servidorsqlserver\
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```
## Comando para contenedor sql
```
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name  servidorsqlserver\
   -v volume-mssqlevnd:/var/opt/mssql \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```

   CREATE DATABASE bdevnd;
GO

USE bdevnd;
GO 

CREATE TABLE tbl1(
id int not null IDENTITY(1,1),
nombre NVARCHAR(20) not null,
CONSTRAINT pk_tbl1
PRIMARY KEY (id)
);
GO

SELECT *
FROM tbl1;

SELECT nombre
FROM tbl1;