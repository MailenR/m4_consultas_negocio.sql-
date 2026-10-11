CREATE DATABASE Ventas_Tech_DB;

USE Ventas_Tech_DB;

 -- SECCION 1: DROP TABLES --

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- SECCION 2: CREATE TABLES -- 

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo BIT DEFAULT 1,
    FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
);
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
);
-- SECCION 3: INSERT INTO -- 

INSERT INTO categorias
    (id_categoria, nombre_categoria, descripcion)
VALUES
    (1, 'Computación', 'Laptops, PCs y monitores'),
    (2, 'Accesorios', 'Periféricos y complementos'),
    (3, 'Audio', 'Auriculares y parlantes'),
    (4, 'Almacenamiento', 'Discos y memorias');

    INSERT INTO clientes
    (id_cliente, nombre, email, ciudad, fecha_registro)
VALUES
    (1, 'María López', 'maria@mail.com', 'Buenos Aires', '2024-01-05'),
    (2, 'Carlos Ruiz', 'carlos@mail.com', 'Córdoba', '2024-01-10'),
    (3, 'Ana Gómez', 'ana@mail.com', 'Rosario', '2024-02-01'),
    (4, 'Pedro Sanz', 'pedro@mail.com', 'Mendoza', '2024-02-15'),
    (5, 'Laura Torres', 'laura@mail.com', 'Tucumán', '2024-03-01');

    INSERT INTO productos
    (id_producto, nombre_producto, id_categoria, precio, stock, activo)
VALUES
    (1, 'Laptop Pro 15', 1, 1200.00, 15, 1),
    (2, 'Mouse Inalámbrico', 2, 28.00, 80, 1),
    (3, 'Monitor 4K 27', 1, 450.00, 12, 1),
    (4, 'Auriculares BT Pro', 3, 120.00, 35, 1),
    (5, 'SSD Externo 1TB', 4, 130.00, 18, 1),
    (6, 'Teclado Mecánico', 2, 95.00, 40, 1);

    INSERT INTO ventas
    (id_venta, id_cliente, id_producto, cantidad,
     precio_unitario, fecha_venta)
VALUES
    (1, 1, 1, 2, 1200.00, '2024-03-05'),
    (2, 2, 2, 5, 28.00, '2024-03-06'),
    (3, 3, 3, 1, 450.00, '2024-03-07'),
    (4, 1, 4, 2, 120.00, '2024-03-08'),
    (5, 4, 5, 3, 130.00, '2024-03-10'),
    (6, 2, 6, 4, 95.00, '2024-03-11'),
    (7, 5, 1, 1, 1200.00, '2024-03-12'),
    (8, 3, 2, 8, 28.00, '2024-03-13'),
    (9, 4, 4, 1, 120.00, '2024-03-14'),
    (10, 5, 3, 2, 450.00, '2024-03-15');

    -- SECCION 4: VALIDACION -- 

    SELECT * FROM categorias; 
SELECT * FROM clientes;    
SELECT * FROM productos;   
SELECT * FROM ventas;      


 -- PROYECTO RETAILPRo. PRE-ENTREGA 4: CONSULTAS SQL DE NEGOCIO -- 

USE Ventas_Tech_DB;

-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL  --

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- CONSULTA 2: RANKING DE PRODUCTOS  --

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- CONSULTA 3: CLIENTES RECURRENTES --

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

-- CONSULTA 4: MESES POR ENCIMA O POR DEBAJO DEL PROMEDIO --

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    AVG(total_facturado) OVER () AS promedio_mensual,
    CASE
        WHEN total_facturado > AVG(total_facturado) OVER ()
            THEN 'Por encima'
        ELSE 'Por debajo o igual'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;

-- BLOQUE DE CIERRE: HALLAZGOS DEL ANALISIS --

-- 1: El producto con mayor facturacion fue el ID_1, con un total facturado de 3600.00.

-- 2: Todos los clientes registraron 2 pedidos, por lo que no se observan diferencias en la cantidad de compas entre los clientes analizados. 

-- 3: El mes con mayor facturacion fue el mes 3, con un total de 6444.00.











