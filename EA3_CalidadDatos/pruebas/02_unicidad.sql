-- ============================================================
-- EA3 PRUEBA 02: UNICIDAD
-- Detecta duplicados en claves primarias y campos únicos
-- Base: jardineria.db | Resultado esperado: 0 filas por prueba
-- ============================================================
SELECT 'P02-01' prueba, ID_oficina, COUNT(*) duplicados
FROM oficina GROUP BY ID_oficina HAVING COUNT(*)>1;

SELECT 'P02-02', ID_empleado, COUNT(*) FROM empleado
GROUP BY ID_empleado HAVING COUNT(*)>1;

SELECT 'P02-03', ID_cliente, COUNT(*) FROM cliente
GROUP BY ID_cliente HAVING COUNT(*)>1;

SELECT 'P02-04', ID_producto, COUNT(*) FROM producto
GROUP BY ID_producto HAVING COUNT(*)>1;

SELECT 'P02-05', email, COUNT(*) FROM empleado
GROUP BY email HAVING COUNT(*)>1;

SELECT 'P02-06', id_transaccion, COUNT(*) FROM pago
GROUP BY id_transaccion HAVING COUNT(*)>1;

SELECT 'P02-07', CodigoProducto, COUNT(*) FROM producto
GROUP BY CodigoProducto HAVING COUNT(*)>1;
