# 🌿 EA4 — Integración Final: Jardinería & Staging
**Grupo:** 10  
**Estudiante:** Kevin Andrés Valencia Daza  
**Docente:** Antonio Jesús Valderrama  
**Curso:** Bases de datos II (PREICA2601B010048)  
**Institución:** Institución Universitaria Digital de Antioquia — 2026  

---

## 📁 Estructura del Repositorio

```
EA4_Grupo10_IntegracionFinal/
│
├── EA1_ModeloEstrella/              # Diseño del Modelo Estrella
│   ├── documentacion/               # EA1_Grupo10_ModeloEstrella.pdf
│   └── scripts_sql/
│       ├── modelo_estrella_DDL.sql  # CREATE TABLE para las 6 tablas del DW
│       └── consultas_analiticas.sql # 5 consultas OLAP de ejemplo
│
├── EA2_Staging/                     # Construcción de la Base Staging
│   ├── documentacion/               # EA2_Grupo10_Informe.pdf + .docx
│   ├── notebook/                    # Jardineria_Staging_Colab.ipynb
│   ├── scripts_sql/
│   │   ├── CreacionStaging_DDL.sql  # CREATE TABLE para star schema
│   │   └── migracion_ETL.sql        # INSERT INTO ... SELECT (ETL)
│   └── backups/
│       ├── BK_jardineria.db         # Backup base operacional
│       └── BK_staging.db            # Backup base analítica
│
├── EA3_CalidadDatos/                # Pruebas de Verificación de Calidad
│   ├── pruebas/
│   │   ├── 01_completitud.sql       # 10 pruebas de campos nulos
│   │   ├── 02_unicidad.sql          # 7 pruebas de duplicados
│   │   ├── 03_integridad_referencial.sql  # 7 pruebas de FKs
│   │   ├── 04_dominio_y_logica.sql  # 10 pruebas de rangos y lógica
│   │   └── 05_staging_calidad.sql   # 8 pruebas del star schema
│   ├── scripts/
│   │   └── pruebas_calidad.py       # Script Python: 54 pruebas + reporte
│   └── reportes/
│       └── reporte_calidad.md       # Documentación completa
│
├── .gitignore
└── README.md                        # Este archivo
```

---

## 🗄️ Bases de Datos

| Base | Motor | Tablas | Tipo |
|------|-------|--------|------|
| `jardineria` | SQLite | 8 (oficina, empleado, cliente, pedido, producto, Categoria_producto, detalle_pedido, pago) | OLTP |
| `staging` | SQLite | 7 (dim_oficina, dim_empleado, dim_cliente, dim_categoria, dim_producto, fact_pedidos, fact_pagos) | Star Schema |
| `DW_Jardinería` | Diseño | 6 (DIM_TIEMPO, DIM_CLIENTE, DIM_PRODUCTO, DIM_EMPLEADO, DIM_OFICINA, HECHO_VENTAS) | Data Warehouse |

---

## ▶️ Cómo Ejecutar

### Google Colab (recomendado)
1. Abrir `EA2_Staging/notebook/Jardineria_Staging_Colab.ipynb`
2. Ejecutar todas las celdas en orden

### SQLite local
```bash
# Pruebas de calidad (requiere tener los .db en la misma carpeta)
python EA3_CalidadDatos/scripts/pruebas_calidad.py

# O prueba por prueba:
sqlite3 EA2_Staging/backups/BK_jardineria.db < EA3_CalidadDatos/pruebas/01_completitud.sql
```

---

## ✅ Pruebas de Calidad — Resumen

| Categoría | Pruebas | Qué detecta |
|-----------|---------|-------------|
| Completitud | 12 | Campos obligatorios nulos o vacíos |
| Unicidad | 11 | PKs y campos únicos duplicados |
| Integridad Referencial | 11 | FKs apuntando a registros inexistentes |
| Dominio y Lógica | 10 | Precios negativos, stocks inválidos, fechas incoherentes |
| Staging | 10 | Campo `total_linea` calculado, FKs del star schema |
| Conteo ETL | 7 | Que Jardinería y Staging tengan los mismos registros |
| **Total** | **54** | |
