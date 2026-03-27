-- ============================================================
-- EA1 — Modelo Estrella Jardinería
-- DDL completo: dimensiones + tabla de hechos
-- Motor: SQLite / compatible con SQL Server
-- Autor: Kevin Andrés Valencia Daza
-- ============================================================

-- DIM_TIEMPO: generada por ETL (un registro por día)
CREATE TABLE IF NOT EXISTS DIM_TIEMPO (
    id_tiempo      INTEGER PRIMARY KEY,  -- YYYYMMDD (ej: 20240315)
    fecha          DATE        NOT NULL,
    anio           SMALLINT    NOT NULL,
    trimestre      SMALLINT    NOT NULL CHECK(trimestre BETWEEN 1 AND 4),
    mes            SMALLINT    NOT NULL CHECK(mes BETWEEN 1 AND 12),
    nombre_mes     VARCHAR(15) NOT NULL,
    semana         SMALLINT    NOT NULL,
    dia            SMALLINT    NOT NULL CHECK(dia BETWEEN 1 AND 31),
    dia_semana     VARCHAR(15) NOT NULL,
    es_fin_semana  BOOLEAN     NOT NULL DEFAULT 0
);

-- DIM_CLIENTE
CREATE TABLE IF NOT EXISTS DIM_CLIENTE (
    id_cliente         INTEGER PRIMARY KEY,
    codigo_cliente     INTEGER     NOT NULL,
    nombre_cliente     VARCHAR(50) NOT NULL,
    nombre_contacto    VARCHAR(30),
    apellido_contacto  VARCHAR(30),
    telefono           VARCHAR(15),
    ciudad             VARCHAR(50),
    region             VARCHAR(50),
    pais               VARCHAR(50),
    codigo_postal      VARCHAR(10),
    limite_credito     DECIMAL(15,2)
);

-- DIM_PRODUCTO
CREATE TABLE IF NOT EXISTS DIM_PRODUCTO (
    id_producto       INTEGER PRIMARY KEY,
    codigo_producto   VARCHAR(15) NOT NULL,
    nombre            VARCHAR(70) NOT NULL,
    gama              VARCHAR(50),
    proveedor         VARCHAR(50),
    descripcion       TEXT,
    precio_venta      DECIMAL(15,2) NOT NULL,
    precio_proveedor  DECIMAL(15,2),
    dimensiones       VARCHAR(25)
);

-- DIM_EMPLEADO
CREATE TABLE IF NOT EXISTS DIM_EMPLEADO (
    id_empleado      INTEGER PRIMARY KEY,
    codigo_empleado  INTEGER     NOT NULL,
    nombre           VARCHAR(50) NOT NULL,
    apellido1        VARCHAR(50) NOT NULL,
    apellido2        VARCHAR(50),
    puesto           VARCHAR(50),
    email            VARCHAR(100),
    extension        VARCHAR(10)
);

-- DIM_OFICINA
CREATE TABLE IF NOT EXISTS DIM_OFICINA (
    id_oficina       VARCHAR(10) PRIMARY KEY,
    codigo_oficina   VARCHAR(10),
    ciudad           VARCHAR(30),
    pais             VARCHAR(50),
    region           VARCHAR(50),
    codigo_postal    VARCHAR(10),
    telefono         VARCHAR(20),
    linea_direccion1 VARCHAR(50)
);

-- HECHO_VENTAS (tabla central del modelo estrella)
CREATE TABLE IF NOT EXISTS HECHO_VENTAS (
    id_venta       INTEGER PRIMARY KEY,
    id_tiempo      INTEGER      NOT NULL REFERENCES DIM_TIEMPO(id_tiempo),
    id_cliente     INTEGER      NOT NULL REFERENCES DIM_CLIENTE(id_cliente),
    id_producto    INTEGER      NOT NULL REFERENCES DIM_PRODUCTO(id_producto),
    id_empleado    INTEGER      NOT NULL REFERENCES DIM_EMPLEADO(id_empleado),
    id_oficina     VARCHAR(10)  NOT NULL REFERENCES DIM_OFICINA(id_oficina),
    -- Métricas
    cantidad       INTEGER      NOT NULL,
    precio_unitario DECIMAL(15,2) NOT NULL,
    total_venta    DECIMAL(15,2) NOT NULL,   -- cantidad × precio_unitario
    descuento      DECIMAL(5,2)  DEFAULT 0,
    -- Atributos degenerados (no justifican dimensión propia)
    estado_pedido  VARCHAR(15),
    numero_linea   SMALLINT,
    codigo_pedido  INTEGER
);
