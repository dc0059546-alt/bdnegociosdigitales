
# Contenedor de SQLSERVER Sin volumen

```shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name  servidorsqlserver\
   -d \
   mcr.microsoft.com/mssql/server:2019-latest