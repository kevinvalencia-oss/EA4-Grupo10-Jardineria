-- ============================================================
-- EA2 — Script de migración ETL: Jardinería → Staging
-- Requiere: ATTACH DATABASE 'jardineria.db' AS jard;
-- ============================================================

-- PASO 1: Dimensiones (datos de contexto)
INSERT INTO dim_oficina
SELECT ID_oficina, Descripcion, ciudad, pais, region, codigo_postal, telefono
FROM jard.oficina;

INSERT INTO dim_empleado
SELECT ID_empleado,
  TRIM(nombre || ' ' || apellido1 ||
    CASE WHEN COALESCE(apellido2,'') <> '' THEN ' ' || apellido2 ELSE '' END),
  email, puesto, ID_oficina, ID_jefe
FROM jard.empleado;

INSERT INTO dim_cliente
SELECT ID_cliente, nombre_cliente,
  TRIM(COALESCE(nombre_contacto,'') || ' ' || COALESCE(apellido_contacto,'')),
  telefono, ciudad, pais, limite_credito, ID_empleado_rep_ventas
FROM jard.cliente;

INSERT INTO dim_categoria
SELECT Id_Categoria, Desc_Categoria FROM jard.Categoria_producto;

INSERT INTO dim_producto
SELECT ID_producto, CodigoProducto, nombre, Categoria,
       proveedor, cantidad_en_stock, precio_venta, precio_proveedor
FROM jard.producto;

-- PASO 2: Tablas de hechos (métricas del negocio)
INSERT INTO fact_pedidos
SELECT dp.ID_detalle_pedido, dp.ID_pedido,
       p.fecha_pedido, p.fecha_entrega, p.estado, p.ID_cliente,
       dp.ID_producto, dp.cantidad, dp.precio_unidad,
       ROUND(dp.cantidad * dp.precio_unidad, 2),
       dp.numero_linea
FROM jard.detalle_pedido dp
JOIN jard.pedido p ON dp.ID_pedido = p.ID_pedido;

INSERT INTO fact_pagos
SELECT ID_pago, ID_cliente, forma_pago, id_transaccion, fecha_pago, total
FROM jard.pago;
