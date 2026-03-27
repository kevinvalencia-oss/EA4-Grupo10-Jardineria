-- ============================================================
-- EA3 PRUEBA 01: COMPLETITUD
-- Verifica que campos obligatorios no tengan nulos ni vacíos
-- Base: jardineria.db | Resultado esperado: 0 filas por prueba
-- ============================================================
SELECT 'P01-01' prueba,'Oficinas sin ciudad/pais' descripcion, COUNT(*) problemas
FROM oficina WHERE ciudad IS NULL OR ciudad='' OR pais IS NULL OR pais='';

SELECT 'P01-02','Empleados sin email', COUNT(*) FROM empleado
WHERE email IS NULL OR email='';

SELECT 'P01-03','Empleados sin puesto', COUNT(*) FROM empleado
WHERE puesto IS NULL OR puesto='';

SELECT 'P01-04','Clientes sin nombre', COUNT(*) FROM cliente
WHERE nombre_cliente IS NULL OR nombre_cliente='';

SELECT 'P01-05','Clientes sin teléfono', COUNT(*) FROM cliente
WHERE telefono IS NULL OR telefono='';

SELECT 'P01-06','Productos sin nombre', COUNT(*) FROM producto
WHERE nombre IS NULL OR nombre='';

SELECT 'P01-07','Productos sin precio_venta', COUNT(*) FROM producto
WHERE precio_venta IS NULL;

SELECT 'P01-08','Pedidos sin fecha_pedido', COUNT(*) FROM pedido
WHERE fecha_pedido IS NULL;

SELECT 'P01-09','Pagos sin total', COUNT(*) FROM pago
WHERE total IS NULL;

SELECT 'P01-10','Pagos sin id_transaccion', COUNT(*) FROM pago
WHERE id_transaccion IS NULL OR id_transaccion='';
