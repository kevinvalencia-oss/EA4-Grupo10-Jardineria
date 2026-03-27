-- ============================================================
-- EA1 — Consultas analíticas sobre el Modelo Estrella
-- Demuestran el valor del modelo dimensional vs OLTP
-- ============================================================

-- 1. Total de ventas por mes y año
SELECT t.anio, t.nombre_mes, t.mes,
       ROUND(SUM(h.total_venta), 2) AS ingresos,
       SUM(h.cantidad)              AS unidades
FROM HECHO_VENTAS h
JOIN DIM_TIEMPO t ON h.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes, t.nombre_mes
ORDER BY t.anio, t.mes;

-- 2. Top 10 productos por ingresos totales
SELECT p.nombre, p.gama,
       SUM(h.cantidad)              AS unidades_vendidas,
       ROUND(SUM(h.total_venta), 2) AS ingresos_totales,
       ROUND(AVG(h.precio_unitario),2) AS precio_promedio
FROM HECHO_VENTAS h
JOIN DIM_PRODUCTO p ON h.id_producto = p.id_producto
GROUP BY p.id_producto
ORDER BY ingresos_totales DESC
LIMIT 10;

-- 3. Rendimiento de empleados por trimestre
SELECT t.anio, t.trimestre,
       e.nombre || ' ' || e.apellido1 AS empleado,
       e.puesto,
       COUNT(DISTINCT h.codigo_pedido) AS pedidos_gestionados,
       ROUND(SUM(h.total_venta), 2)    AS total_vendido
FROM HECHO_VENTAS h
JOIN DIM_EMPLEADO e ON h.id_empleado = e.id_empleado
JOIN DIM_TIEMPO   t ON h.id_tiempo   = t.id_tiempo
GROUP BY t.anio, t.trimestre, e.id_empleado
ORDER BY t.anio, t.trimestre, total_vendido DESC;

-- 4. Ventas por país (cliente + oficina)
SELECT c.pais AS pais_cliente,
       o.pais AS pais_oficina,
       ROUND(SUM(h.total_venta), 2) AS ingresos
FROM HECHO_VENTAS h
JOIN DIM_CLIENTE c ON h.id_cliente = c.id_cliente
JOIN DIM_OFICINA o ON h.id_oficina = o.id_oficina
GROUP BY c.pais, o.pais
ORDER BY ingresos DESC;

-- 5. Clientes con mayor volumen (top 5)
SELECT c.nombre_cliente, c.ciudad, c.pais,
       COUNT(DISTINCT h.codigo_pedido) AS pedidos,
       ROUND(SUM(h.total_venta), 2)    AS total_comprado
FROM HECHO_VENTAS h
JOIN DIM_CLIENTE c ON h.id_cliente = c.id_cliente
GROUP BY c.id_cliente
ORDER BY total_comprado DESC
LIMIT 5;
