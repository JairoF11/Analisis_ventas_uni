-- Crear base de datos
CREATE DATABASE IF NOT EXISTS tienda_uniformes;
USE tienda_uniformes;
-- Creamos las tablas de clientes, productos, factuas y ventas
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
CREATE TABLE productos (
    id_producto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    valor_unitario DOUBLE
    );
    
CREATE TABLE facturas (
    id_factura INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fecha_factura DATE,
    id_cliente INT,
    total_factura DOUBLE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE SET NULL
);

CREATE TABLE ventas_uni (
    id_venta_uni INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_factura INT,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    total DOUBLE NOT NULL,
    nota TEXT,
    FOREIGN KEY (id_factura) REFERENCES facturas(id_factura) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Modificamos las tablas con las columnas que olvidamos incluir
ALTER TABLE clientes
ADD COLUMN (
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE productos
ADD COLUMN (
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Cargamos los archivos CSV anteriormente limpiados en EXCEL para rellenar las tablas anteriormente creadas

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clientes.csv'
INTO TABLE clientes
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@nombre, created_at)
SET nombre = NULLIF(@nombre, '');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/facturas.csv'
INTO TABLE facturas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_factura, @fecha_factura, @id_cliente, @total_factura)
SET fecha_factura = STR_TO_DATE(NULLIF(TRIM(@fecha_factura), '1900-01-01'), '%Y-%m-%d'), 
    id_cliente = NULLIF(@id_cliente, ''),
    total_factura = NULLIF(@total_factura, '');
    
    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/productos.csv'
INTO TABLE productos
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@codigo, @descripcion, @categoria, @valor_unitario)
SET codigo = NULLIF(@codigo, ''),
    descripcion = NULLIF(@descripcion, ''),
    categoria = NULLIF(@categoria, ''),
    valor_unitario = IF(TRIM(@valor_unitario) REGEXP '^[0-9]+(\.[0-9]+)?$', TRIM(@valor_unitario), NULL);
    
    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ventas_uni.csv'
INTO TABLE ventas_uni
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@id_factura, @id_cliente, @id_producto, @cantidad, @total, @nota)
SET id_factura = NULLIF(@id_factura, ''), 
    id_cliente = NULLIF(@id_cliente, ''),
    id_producto = NULLIF(@id_producto, ''),
	cantidad = NULLIF(@cantidad, ''),
    total = NULLIF(@total, ''),
    nota = NULLIF(@nota, '');
    
-- Realizamos algunas consulta comprobar que los datos fueron cargados correctamente
SELECT COUNT(*) FROM clientes;
SELECT * FROM clientes;
SELECT id_cliente FROM clientes ORDER BY id_cliente ASC;
SELECT COUNT(*) FROM facturas;
SELECT * FROM productos;
SELECT * FROM ventas_uni;

-- Codigo de apoyo usado para borrar las tablas (estructura) y la informacion en ella por problemas en el momento de la carga de informacion
DROP TABLE IF EXISTS ventas_uni;
DROP TABLE IF EXISTS facturas;
DROP TABLE IF EXISTS productos;  
DROP TABLE IF EXISTS ventas_uni;  

TRUNCATE TABLE facturas;
TRUNCATE TABLE clientes;
TRUNCATE TABLE productos;
TRUNCATE TABLE ventas_uni;

DELETE FROM facturas WHERE id_factura > 0;
DELETE FROM clientes WHERE id_cliente > 0;
DELETE FROM productos WHERE id_producto > 0;
DELETE FROM ventas_uni WHERE id_venta_uni > 0;
ALTER TABLE facturas AUTO_INCREMENT = 1;
ALTER TABLE clientes AUTO_INCREMENT = 1;
ALTER TABLE productos AUTO_INCREMENT = 1;
ALTER TABLE ventas_uni AUTO_INCREMENT = 1;

-- Consulta para revisar la informacion total cargada
SELECT COUNT(*) AS total_clientes FROM clientes;
SELECT COUNT(*) AS total_productos FROM productos;
SELECT COUNT(*) AS total_facturas FROM facturas;
SELECT COUNT(*) AS total_ventas_producto FROM ventas_uni;

-- Consultas preeliminares para ver ventas totales y cantidad vendida
SELECT SUM(total) AS total_ingresos FROM ventas_uni;
SELECT SUM(cantidad) AS productos_vendidos FROM ventas_uni;

-- Consulta join para crear un query con informacion amigable para el lector (Ej: no se muestran los IDs de clientes si no los nombres)

SELECT
 v.id_venta_uni,
 v.id_factura,
 f.fecha_factura,
 c.nombre,
 p.descripcion,
 v.cantidad,
 v.total
FROM ventas_uni AS v
JOIN clientes AS c ON v.id_cliente = c.id_cliente
JOIN productos AS p ON v.id_producto = p.id_producto
JOIN facturas AS f ON v.id_factura = f.id_factura
ORDER BY v.id_venta_uni ASC;

-- Obtener la cantidad de veces que se ha vendido cada producto
SELECT p.descripcion, COUNT(v.cantidad) AS total_ventas
FROM productos AS p
JOIN ventas_uni AS v ON p.id_producto = v.id_producto
GROUP BY p.descripcion
ORDER BY total_ventas DESC;

-- Obtener la cantidad total de unidades vendidas por producto
SELECT p.descripcion, SUM(v.cantidad) AS ventas_producto
FROM productos AS p
JOIN ventas_uni AS v ON p.id_producto = v.id_producto
GROUP BY p.descripcion
ORDER BY ventas_producto DESC;

-- Identificar productos con ventas pendientes
SELECT p.descripcion, SUM(v.cantidad) AS total_pendientes
FROM productos AS p
JOIN ventas_uni AS v ON p.id_producto = v.id_producto
WHERE v.nota LIKE '%pte%'
GROUP BY p.descripcion
ORDER BY total_pendientes DESC;

-- Total de productos vendidos por día
SELECT f.fecha_factura AS dia, SUM(v.cantidad) AS total_vendidos
FROM ventas_uni AS v
JOIN facturas AS f ON v.id_factura = f.id_factura
GROUP BY dia
ORDER BY total_vendidos DESC;

-- Productos que nunca se han vendido
SELECT p.id_producto, p.descripcion, COUNT(v.id_producto) AS total_vendidos
FROM productos AS p
LEFT JOIN ventas_uni AS v ON p.id_producto = v.id_producto
GROUP BY p.id_producto, p.descripcion
HAVING total_vendidos = 0;

-- Facturas sin productos asociados
SELECT f.id_factura, f.fecha_factura, COUNT(v.id_venta_uni) AS total_productos
FROM facturas AS f
LEFT JOIN ventas_uni AS v ON f.id_factura = v.id_factura
GROUP BY f.id_factura, f.fecha_factura
HAVING total_productos = 0;

-- Identificar los clientes que tienen facturas registradas pero no existen en la tabla de clientes
SELECT f.id_cliente 
FROM facturas f
LEFT JOIN clientes c ON f.id_cliente = c.id_cliente  -- Relacionar facturas con clientes
WHERE c.id_cliente IS NULL;  -- Filtrar solo los clientes que no aparecen en la tabla de clientes