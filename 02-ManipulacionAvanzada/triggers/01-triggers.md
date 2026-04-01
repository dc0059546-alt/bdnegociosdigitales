# Triggers en SQL Server

## 1. ¿Que es un trigger?

Un trigger (diparador) es un bloue de codigo SQL que se jecuta automaaticamente, cuando ocurre un evento en una tabla 

- Eventos principales: 
    - INSERT
    - UPDATE
    - DELETE

Nota: no se ejecuta manualmente, se activan solos 

## 2.¿Para que sirven los triggers?
    - Validaciones
    - Auditorias (guardar historial)
    - Reglas de negocio
    - Automatizacion

## 3. Tipos de Triggers en SQL Server

    - AFTER TRIGGER

    se ejecuta despues del evento


    - Insted of trigger

    remplaza la operacion original

    ## Sintaxis Basica

    ```sql
    CREATE OR ALTER TRIGGER 
    ON nombre_tabla
    AFTER INSERT
    AS
    BEGIN
    END;
    ```

    ## 5. Tablas especiales

| Tabla | Contenido |
| :--- | :--- |
| inserted | Nuevos datos |
| deleted | Datos anteriores | 

    