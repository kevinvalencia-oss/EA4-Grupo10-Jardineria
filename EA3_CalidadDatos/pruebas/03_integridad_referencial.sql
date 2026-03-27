-- ============================================================
-- EA3 PRUEBA 03: INTEGRIDAD REFERENCIAL
-- Detecta claves foráneas que apuntan a registros inexistentes
-- Base: jardineria.db | Resultado esperado: 0 filas por prueba
-- ============================================================
SELECT 'P03-01' prueba, e.ID_empleado, e.nombre, e.ID_oficina
FROM empleado e LEFT JOIN oficina o ON e.ID_oficina=o.ID_oficina
WHERE o.ID_oficina IS NULL;

SELECT 'P03-02', c.ID_cliente, c.nombre_cliente, c.ID_empleado_rep_ventas
FROM cliente c LEFT JOIN empleado e ON c.ID_empleado_rep_ventas=e.ID_empleado
WHERE c.ID_empleado_rep_ventas IS NOT NULL AND e.ID_empleado IS NULL;

SELECT 'P03-03', p.ID_pedido, p.ID_cliente FROM pedido p
LEFT JOIN cliente c ON p.ID_cliente=c.ID_cliente WHERE c.ID_cliente IS NULL;

SELECT 'P03-04', d.ID_detalle_pedido, d.ID_pedido FROM detalle_pedido d
LEFT JOIN pedido p ON d.ID_pedido=p.ID_pedido WHERE p.ID_pedido IS NULL;

SELECT 'P03-05', d.ID_detalle_pedido, d.ID_producto FROM detalle_pedido d
LEFT JOIN producto p ON d.ID_producto=p.ID_producto WHERE p.ID_producto IS NULL;

SELECT 'P03-06', pg.ID_pago, pg.ID_cliente FROM pago pg
LEFT JOIN cliente c ON pg.ID_cliente=c.ID_cliente WHERE c.ID_cliente IS NULL;

SELECT 'P03-07', p.ID_producto, p.Categoria FROM producto p
LEFT JOIN Categoria_producto c ON p.Categoria=c.Id_Categoria
WHERE c.Id_Categoria IS NULL;
