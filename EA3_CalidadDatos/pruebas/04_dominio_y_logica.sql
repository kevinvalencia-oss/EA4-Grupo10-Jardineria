-- ============================================================
-- EA3 PRUEBA 04: DOMINIO Y CONSISTENCIA LÓGICA
-- Verifica rangos permitidos y relaciones temporales/lógicas
-- Base: jardineria.db | Resultado esperado: 0 filas por prueba
-- ============================================================
SELECT 'P04-01' prueba,'Precio venta negativo/cero', ID_producto, precio_venta
FROM producto WHERE precio_venta<=0;

SELECT 'P04-02','Margen negativo (prov > venta)', ID_producto, precio_venta, precio_proveedor
FROM producto WHERE precio_proveedor > precio_venta;

SELECT 'P04-03','Stock negativo', ID_producto, cantidad_en_stock
FROM producto WHERE cantidad_en_stock<0;

SELECT 'P04-04','Límite crédito negativo', ID_cliente, limite_credito
FROM cliente WHERE limite_credito<0;

SELECT 'P04-05','Pago con total<=0', ID_pago, total
FROM pago WHERE total<=0;

SELECT 'P04-06','Cantidad pedido negativa/cero', ID_detalle_pedido, cantidad
FROM detalle_pedido WHERE cantidad<=0;

SELECT 'P04-07','Estado pedido inválido', ID_pedido, estado
FROM pedido WHERE estado NOT IN ('Entregado','Pendiente','Rechazado','En proceso');

SELECT 'P04-08','Entrega anterior a pedido', ID_pedido, fecha_pedido, fecha_entrega
FROM pedido WHERE fecha_entrega < fecha_pedido;

SELECT 'P04-09','Entregado sin fecha_entrega', ID_pedido, estado
FROM pedido WHERE estado='Entregado' AND fecha_entrega IS NULL;

SELECT 'P04-10','Empleado es su propio jefe', ID_empleado, nombre
FROM empleado WHERE ID_jefe=ID_empleado;
