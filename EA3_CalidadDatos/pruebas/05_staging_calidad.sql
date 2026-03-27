-- ============================================================
-- EA3 PRUEBA 05: CALIDAD EN STAGING
-- Verifica integridad del star schema y campo calculado
-- Base: staging.db | Resultado esperado: 0 filas por prueba
-- ============================================================

-- Campo calculado correcto
SELECT 'P05-01' prueba, ID_detalle, cantidad, precio_unidad, total_linea,
       ROUND(cantidad*precio_unidad,2) AS esperado
FROM fact_pedidos
WHERE ABS(total_linea - ROUND(cantidad*precio_unidad,2)) > 0.01;

-- FKs huérfanas en fact_pedidos
SELECT 'P05-02', f.ID_detalle, f.ID_cliente FROM fact_pedidos f
LEFT JOIN dim_cliente c ON f.ID_cliente=c.ID_cliente WHERE c.ID_cliente IS NULL;

SELECT 'P05-03', f.ID_detalle, f.ID_producto FROM fact_pedidos f
LEFT JOIN dim_producto p ON f.ID_producto=p.ID_producto WHERE p.ID_producto IS NULL;

-- FKs huérfanas en fact_pagos
SELECT 'P05-04', f.ID_pago, f.ID_cliente FROM fact_pagos f
LEFT JOIN dim_cliente c ON f.ID_cliente=c.ID_cliente WHERE c.ID_cliente IS NULL;

-- Dimensiones sin categoría
SELECT 'P05-05', p.ID_producto, p.ID_categoria FROM dim_producto p
LEFT JOIN dim_categoria c ON p.ID_categoria=c.ID_categoria WHERE c.ID_categoria IS NULL;

-- Transacciones duplicadas en staging
SELECT 'P05-06', id_transaccion, COUNT(*) FROM fact_pagos
GROUP BY id_transaccion HAVING COUNT(*)>1;

-- Unicidad PKs dimensiones
SELECT 'P05-07', ID_cliente, COUNT(*) FROM dim_cliente
GROUP BY ID_cliente HAVING COUNT(*)>1;

SELECT 'P05-08', ID_producto, COUNT(*) FROM dim_producto
GROUP BY ID_producto HAVING COUNT(*)>1;
