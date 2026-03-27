-- ============================================================
-- EA2 — Creación Base de Datos Staging (Star Schema)
-- Motor: SQLite | Autor: Kevin Andrés Valencia Daza
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
    total_linea   NUMERIC(15,2),   -- cantidad × precio_unidad (precalculado)
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
