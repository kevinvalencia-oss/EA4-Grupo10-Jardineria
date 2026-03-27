# Reporte de Calidad de Datos — EA3 Grupo 10
**Proyecto:** Jardinería & Staging  
**Autor:** Kevin Andrés Valencia Daza  
**Docente:** Antonio Jesús Valderrama  
**Institución:** Institución Universitaria Digital de Antioquia — 2026  

---

## Resumen de Pruebas

| Categoría | # Pruebas | Descripción |
|-----------|-----------|-------------|
| Completitud | 8 | Nulos en campos obligatorios |
| Unicidad | 7 | Duplicados en PKs y campos únicos |
| Integridad Referencial | 7 | Claves foráneas huérfanas |
| Dominio y Lógica | 10 | Rangos, estados y coherencia temporal |
| Completitud Staging | 4 | Nulos en dimensiones y hechos |
| Unicidad Staging | 4 | Duplicados en star schema |
| Integridad Ref. Staging | 4 | FKs huérfanas en staging |
| Dominio Staging | 3 | Campo calculado y precios |
| Conteo ETL | 7 | Jardinería = Staging por tabla |
| **TOTAL** | **54** | |

---

## Categorías de Calidad

### 1. Completitud
Garantiza que los campos declarados NOT NULL en el modelo relacional no contengan nulos ni strings vacíos. Campos críticos verificados: `ciudad`, `pais` (oficina) · `email`, `puesto` (empleado) · `nombre_cliente` (cliente) · `precio_venta` (producto) · `fecha_pedido`, `estado` (pedido) · `total`, `id_transaccion` (pago).

### 2. Unicidad
Verifica que las claves primarias y campos con restricción UNIQUE no presenten duplicados. Se verifican: `ID_oficina`, `ID_empleado`, `ID_cliente`, `ID_producto`, `email` (empleado), `id_transaccion` (pago), `CodigoProducto`.

### 3. Integridad Referencial
Detecta registros huérfanos usando `LEFT JOIN ... WHERE IS NULL`. Relaciones verificadas: empleado→oficina · cliente→empleado(rep_ventas) · pedido→cliente · detalle_pedido→pedido · detalle_pedido→producto · pago→cliente · producto→Categoria_producto.

### 4. Consistencia de Dominio
Valida rangos numéricos y conjuntos de valores permitidos: `precio_venta > 0` · `precio_proveedor ≤ precio_venta` · `stock ≥ 0` · `limite_credito ≥ 0` · `total (pago) > 0` · `cantidad > 0` · `estado IN ('Entregado','Pendiente','Rechazado')`.

### 5. Consistencia Lógica
Verifica coherencia entre campos: `fecha_entrega ≥ fecha_pedido` · pedidos 'Entregado' deben tener `fecha_entrega` · ningún empleado puede ser su propio jefe.

### 6. Calidad en Staging
Verifica: `total_linea = ROUND(cantidad × precio_unidad, 2)` · todas las FKs en tablas de hechos apuntan a dimensiones existentes · sin transacciones duplicadas.

### 7. Conteo ETL
Confirma que el proceso ETL no perdió ni duplicó registros: `oficina ↔ dim_oficina` · `empleado ↔ dim_empleado` · `cliente ↔ dim_cliente` · `Categoria_producto ↔ dim_categoria` · `producto ↔ dim_producto` · `detalle_pedido ↔ fact_pedidos` · `pago ↔ fact_pagos`.

---

## Cómo Ejecutar

```bash
# SQLite — pruebas individuales
sqlite3 EA2_Staging/backups/BK_jardineria.db < EA3_CalidadDatos/pruebas/01_completitud.sql
sqlite3 EA2_Staging/backups/BK_jardineria.db < EA3_CalidadDatos/pruebas/02_unicidad.sql
sqlite3 EA2_Staging/backups/BK_jardineria.db < EA3_CalidadDatos/pruebas/03_integridad_referencial.sql
sqlite3 EA2_Staging/backups/BK_jardineria.db < EA3_CalidadDatos/pruebas/04_dominio_y_logica.sql
sqlite3 EA2_Staging/backups/BK_staging.db   < EA3_CalidadDatos/pruebas/05_staging_calidad.sql

# Python — script completo con reporte automático
python EA3_CalidadDatos/scripts/pruebas_calidad.py
```
