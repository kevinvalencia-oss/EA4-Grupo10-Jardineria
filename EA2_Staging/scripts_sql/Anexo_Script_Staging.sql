
-- ============================================================
-- SCRIPT: Creación y carga de la base de datos STAGING
-- Motor:  SQLite (compatible con adaptación a SQL Server)
-- Autor:  Proyecto Jardinería
-- ============================================================

-- PARTE 1: ESTRUCTURA (DDL)
-- ============================================================

CREATE TABLE IF NOT EXISTS dim_oficina (
    ID_oficina    INTEGER PRIMARY KEY,
    descripcion   VARCHAR(10),
    ciudad        VARCHAR(30),
    pais          VARCHAR(50),
    region        VARCHAR(50),
    codigo_postal VARCHAR(10),
    telefono      VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS dim_empleado (
    ID_empleado     INTEGER PRIMARY KEY,
    nombre_completo VARCHAR(150),
    email           VARCHAR(100),
    puesto          VARCHAR(50),
    ID_oficina      INTEGER,
    ID_jefe         INTEGER
);

CREATE TABLE IF NOT EXISTS dim_cliente (
    ID_cliente      INTEGER PRIMARY KEY,
    nombre_cliente  VARCHAR(50),
    nombre_contacto VARCHAR(60),
    telefono        VARCHAR(15),
    ciudad          VARCHAR(50),
    pais            VARCHAR(50),
    limite_credito  NUMERIC(15,2),
    ID_empleado_rep INTEGER
);

CREATE TABLE IF NOT EXISTS dim_categoria (
    ID_categoria INTEGER PRIMARY KEY,
    descripcion  VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_producto (
    ID_producto       INTEGER PRIMARY KEY,
    codigo            VARCHAR(15),
    nombre            VARCHAR(70),
    ID_categoria      INTEGER,
    proveedor         VARCHAR(50),
    cantidad_en_stock INTEGER,
    precio_venta      NUMERIC(15,2),
    precio_proveedor  NUMERIC(15,2)
);

CREATE TABLE IF NOT EXISTS fact_pedidos (
    ID_detalle    INTEGER PRIMARY KEY,
    ID_pedido     INTEGER,
    fecha_pedido  DATE,
    fecha_entrega DATE,
    estado        VARCHAR(15),
    ID_cliente    INTEGER,
    ID_producto   INTEGER,
    cantidad      INTEGER,
    precio_unidad NUMERIC(15,2),
    total_linea   NUMERIC(15,2),
    numero_linea  INTEGER
);

CREATE TABLE IF NOT EXISTS fact_pagos (
    ID_pago        INTEGER PRIMARY KEY,
    ID_cliente     INTEGER,
    forma_pago     VARCHAR(40),
    id_transaccion VARCHAR(50),
    fecha_pago     DATE,
    total          NUMERIC(15,2)
);

-- ============================================================
-- PARTE 2: MIGRACIÓN DE DATOS (DML)
-- Asume que jardineria está disponible como base adjunta
-- En SQLite: ATTACH DATABASE 'jardineria.db' AS jard;
-- ============================================================

INSERT INTO dim_oficina
SELECT ID_oficina, Descripcion, ciudad, pais, region, codigo_postal, telefono
FROM jard.oficina;

INSERT INTO dim_empleado
SELECT
  ID_empleado,
  TRIM(nombre || ' ' || apellido1 ||
    CASE WHEN COALESCE(apellido2,'') <> '' THEN ' ' || apellido2 ELSE '' END),
  email, puesto, ID_oficina, ID_jefe
FROM jard.empleado;

INSERT INTO dim_cliente
SELECT
  ID_cliente, nombre_cliente,
  TRIM(COALESCE(nombre_contacto,'') || ' ' || COALESCE(apellido_contacto,''))
  , telefono, ciudad, pais, limite_credito, ID_empleado_rep_ventas
FROM jard.cliente;

INSERT INTO dim_categoria
SELECT Id_Categoria, Desc_Categoria FROM jard.Categoria_producto;

INSERT INTO dim_producto
SELECT ID_producto, CodigoProducto, nombre, Categoria,
       proveedor, cantidad_en_stock, precio_venta, precio_proveedor
FROM jard.producto;

INSERT INTO fact_pedidos
SELECT
  dp.ID_detalle_pedido, dp.ID_pedido,
  p.fecha_pedido, p.fecha_entrega, p.estado, p.ID_cliente,
  dp.ID_producto, dp.cantidad, dp.precio_unidad,
  ROUND(dp.cantidad * dp.precio_unidad, 2),
  dp.numero_linea
FROM jard.detalle_pedido dp
JOIN jard.pedido p ON dp.ID_pedido = p.ID_pedido;

INSERT INTO fact_pagos
SELECT ID_pago, ID_cliente, forma_pago, id_transaccion, fecha_pago, total
FROM jard.pago;
