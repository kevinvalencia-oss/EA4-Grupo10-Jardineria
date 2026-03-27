"""
================================================================
EA3 — Script de Pruebas de Calidad de Datos
Proyecto: Jardinería & Staging | Grupo 10
Autor: Kevin Andrés Valencia Daza
Docente: Antonio Jesús Valderrama
Institución Universitaria Digital de Antioquia — 2026
================================================================
Ejecución:
    Google Colab: exec(open('pruebas_calidad.py').read())
    Local:        python pruebas_calidad.py
================================================================
"""
import sqlite3, os
from datetime import datetime

def get_db(name):
    for path in [f"/content/{name}.db", f"{name}.db",
                 f"EA2_Staging/backups/{name}.db"]:
        if os.path.exists(path): return path
    return f"{name}.db"

resultados = []
errores = 0

def prueba(nombre, categoria, sql, conn, espera_vacio=True):
    global errores
    try:
        filas = conn.execute(sql).fetchall()
        ok = len(filas) == 0 if espera_vacio else len(filas) > 0
        estado = "✅ PASÓ" if ok else "❌ FALLÓ"
        if not ok: errores += 1
        resultados.append(dict(categoria=categoria, nombre=nombre,
                               estado=estado, filas=len(filas),
                               detalle=filas[:3] if not ok else []))
        print(f"  {estado}  [{categoria}] {nombre} ({len(filas)} registros)")
    except Exception as e:
        errores += 1
        resultados.append(dict(categoria=categoria, nombre=nombre,
                               estado="⚠️ ERROR", filas=-1, detalle=[str(e)]))
        print(f"  ⚠️ ERROR  [{categoria}] {nombre}: {e}")

# ── JARDINERÍA ──────────────────────────────────────────────
print("\n" + "="*60 + "\nPRUEBAS — jardineria\n" + "="*60)
cj = sqlite3.connect(get_db("BK_jardineria"))

print("\n📋 1. Completitud")
prueba("Oficinas sin ciudad/país",       "Completitud", "SELECT * FROM oficina WHERE ciudad IS NULL OR ciudad='' OR pais IS NULL OR pais=''", cj)
prueba("Empleados sin email",            "Completitud", "SELECT * FROM empleado WHERE email IS NULL OR email=''", cj)
prueba("Empleados sin puesto",           "Completitud", "SELECT * FROM empleado WHERE puesto IS NULL OR puesto=''", cj)
prueba("Clientes sin nombre",            "Completitud", "SELECT * FROM cliente WHERE nombre_cliente IS NULL OR nombre_cliente=''", cj)
prueba("Productos sin precio_venta",     "Completitud", "SELECT * FROM producto WHERE precio_venta IS NULL", cj)
prueba("Pedidos sin fecha_pedido",       "Completitud", "SELECT * FROM pedido WHERE fecha_pedido IS NULL", cj)
prueba("Pagos sin total",                "Completitud", "SELECT * FROM pago WHERE total IS NULL", cj)
prueba("Pagos sin id_transaccion",       "Completitud", "SELECT * FROM pago WHERE id_transaccion IS NULL OR id_transaccion=''", cj)

print("\n🔑 2. Unicidad")
prueba("PKs duplicadas en oficina",      "Unicidad", "SELECT ID_oficina, COUNT(*) FROM oficina GROUP BY ID_oficina HAVING COUNT(*)>1", cj)
prueba("PKs duplicadas en empleado",     "Unicidad", "SELECT ID_empleado, COUNT(*) FROM empleado GROUP BY ID_empleado HAVING COUNT(*)>1", cj)
prueba("PKs duplicadas en cliente",      "Unicidad", "SELECT ID_cliente, COUNT(*) FROM cliente GROUP BY ID_cliente HAVING COUNT(*)>1", cj)
prueba("PKs duplicadas en producto",     "Unicidad", "SELECT ID_producto, COUNT(*) FROM producto GROUP BY ID_producto HAVING COUNT(*)>1", cj)
prueba("Emails duplicados",              "Unicidad", "SELECT email, COUNT(*) FROM empleado GROUP BY email HAVING COUNT(*)>1", cj)
prueba("Transacciones duplicadas",       "Unicidad", "SELECT id_transaccion, COUNT(*) FROM pago GROUP BY id_transaccion HAVING COUNT(*)>1", cj)
prueba("CódigosProducto duplicados",     "Unicidad", "SELECT CodigoProducto, COUNT(*) FROM producto GROUP BY CodigoProducto HAVING COUNT(*)>1", cj)

print("\n🔗 3. Integridad Referencial")
prueba("Empleado→oficina huérfana",      "Integ. Ref.", "SELECT e.ID_empleado FROM empleado e LEFT JOIN oficina o ON e.ID_oficina=o.ID_oficina WHERE o.ID_oficina IS NULL", cj)
prueba("Cliente→rep_ventas huérfano",    "Integ. Ref.", "SELECT c.ID_cliente FROM cliente c LEFT JOIN empleado e ON c.ID_empleado_rep_ventas=e.ID_empleado WHERE c.ID_empleado_rep_ventas IS NOT NULL AND e.ID_empleado IS NULL", cj)
prueba("Pedido→cliente huérfano",        "Integ. Ref.", "SELECT p.ID_pedido FROM pedido p LEFT JOIN cliente c ON p.ID_cliente=c.ID_cliente WHERE c.ID_cliente IS NULL", cj)
prueba("Detalle→pedido huérfano",        "Integ. Ref.", "SELECT d.ID_detalle_pedido FROM detalle_pedido d LEFT JOIN pedido p ON d.ID_pedido=p.ID_pedido WHERE p.ID_pedido IS NULL", cj)
prueba("Detalle→producto huérfano",      "Integ. Ref.", "SELECT d.ID_detalle_pedido FROM detalle_pedido d LEFT JOIN producto p ON d.ID_producto=p.ID_producto WHERE p.ID_producto IS NULL", cj)
prueba("Pago→cliente huérfano",          "Integ. Ref.", "SELECT pg.ID_pago FROM pago pg LEFT JOIN cliente c ON pg.ID_cliente=c.ID_cliente WHERE c.ID_cliente IS NULL", cj)
prueba("Producto→categoría huérfano",    "Integ. Ref.", "SELECT p.ID_producto FROM producto p LEFT JOIN Categoria_producto c ON p.Categoria=c.Id_Categoria WHERE c.Id_Categoria IS NULL", cj)

print("\n📏 4. Dominio y Lógica")
prueba("Precio venta ≤ 0",               "Dominio", "SELECT * FROM producto WHERE precio_venta<=0", cj)
prueba("Margen negativo",                "Dominio", "SELECT * FROM producto WHERE precio_proveedor>precio_venta", cj)
prueba("Stock negativo",                 "Dominio", "SELECT * FROM producto WHERE cantidad_en_stock<0", cj)
prueba("Límite crédito negativo",        "Dominio", "SELECT * FROM cliente WHERE limite_credito<0", cj)
prueba("Pago total ≤ 0",                 "Dominio", "SELECT * FROM pago WHERE total<=0", cj)
prueba("Cantidad pedido ≤ 0",            "Dominio", "SELECT * FROM detalle_pedido WHERE cantidad<=0", cj)
prueba("Estado pedido inválido",         "Dominio", "SELECT * FROM pedido WHERE estado NOT IN ('Entregado','Pendiente','Rechazado','En proceso')", cj)
prueba("Entrega antes que pedido",       "Lógica", "SELECT * FROM pedido WHERE fecha_entrega < fecha_pedido", cj)
prueba("Entregado sin fecha_entrega",    "Lógica", "SELECT * FROM pedido WHERE estado='Entregado' AND fecha_entrega IS NULL", cj)
prueba("Empleado es su propio jefe",     "Lógica", "SELECT * FROM empleado WHERE ID_jefe=ID_empleado", cj)
cj.close()

# ── STAGING ─────────────────────────────────────────────────
print("\n" + "="*60 + "\nPRUEBAS — staging\n" + "="*60)
cs = sqlite3.connect(get_db("BK_staging"))

print("\n📋 5. Completitud Staging")
prueba("dim_cliente sin nombre",         "Complet. Staging", "SELECT * FROM dim_cliente WHERE nombre_cliente IS NULL OR nombre_cliente=''", cs)
prueba("dim_producto sin precio_venta",  "Complet. Staging", "SELECT * FROM dim_producto WHERE precio_venta IS NULL", cs)
prueba("fact_pedidos sin fecha_pedido",  "Complet. Staging", "SELECT * FROM fact_pedidos WHERE fecha_pedido IS NULL", cs)
prueba("fact_pagos sin total",           "Complet. Staging", "SELECT * FROM fact_pagos WHERE total IS NULL OR total<=0", cs)

print("\n🔑 6. Unicidad Staging")
prueba("PKs dup. dim_cliente",           "Unicidad Staging", "SELECT ID_cliente, COUNT(*) FROM dim_cliente GROUP BY ID_cliente HAVING COUNT(*)>1", cs)
prueba("PKs dup. dim_producto",          "Unicidad Staging", "SELECT ID_producto, COUNT(*) FROM dim_producto GROUP BY ID_producto HAVING COUNT(*)>1", cs)
prueba("PKs dup. fact_pedidos",          "Unicidad Staging", "SELECT ID_detalle, COUNT(*) FROM fact_pedidos GROUP BY ID_detalle HAVING COUNT(*)>1", cs)
prueba("Transacciones dup. fact_pagos",  "Unicidad Staging", "SELECT id_transaccion, COUNT(*) FROM fact_pagos GROUP BY id_transaccion HAVING COUNT(*)>1", cs)

print("\n🔗 7. Integridad Referencial Staging")
prueba("fact_pedidos→dim_cliente",       "Integ. Staging", "SELECT f.ID_detalle FROM fact_pedidos f LEFT JOIN dim_cliente c ON f.ID_cliente=c.ID_cliente WHERE c.ID_cliente IS NULL", cs)
prueba("fact_pedidos→dim_producto",      "Integ. Staging", "SELECT f.ID_detalle FROM fact_pedidos f LEFT JOIN dim_producto p ON f.ID_producto=p.ID_producto WHERE p.ID_producto IS NULL", cs)
prueba("fact_pagos→dim_cliente",         "Integ. Staging", "SELECT f.ID_pago FROM fact_pagos f LEFT JOIN dim_cliente c ON f.ID_cliente=c.ID_cliente WHERE c.ID_cliente IS NULL", cs)
prueba("dim_producto→dim_categoria",     "Integ. Staging", "SELECT p.ID_producto FROM dim_producto p LEFT JOIN dim_categoria c ON p.ID_categoria=c.ID_categoria WHERE c.ID_categoria IS NULL", cs)

print("\n📏 8. Dominio Staging")
prueba("total_linea mal calculado",      "Dominio Staging", "SELECT * FROM fact_pedidos WHERE ABS(total_linea-ROUND(cantidad*precio_unidad,2))>0.01", cs)
prueba("total_linea ≤ 0",               "Dominio Staging", "SELECT * FROM fact_pedidos WHERE total_linea<=0", cs)
prueba("precio_venta ≤ 0 en producto",  "Dominio Staging", "SELECT * FROM dim_producto WHERE precio_venta<=0", cs)

# ── CONTEO ETL ──────────────────────────────────────────────
print("\n🔄 9. Conteo ETL (Jardinería vs Staging)")
cj2 = sqlite3.connect(get_db("BK_jardineria"))
pares = [("oficina","dim_oficina"),("empleado","dim_empleado"),
         ("cliente","dim_cliente"),("Categoria_producto","dim_categoria"),
         ("producto","dim_producto"),("pago","fact_pagos")]
for tj, ts in pares:
    nj = cj2.execute(f"SELECT COUNT(*) FROM {tj}").fetchone()[0]
    ns = cs.execute(f"SELECT COUNT(*) FROM {ts}").fetchone()[0]
    ok = nj == ns
    if not ok: errores += 1
    est = "✅ PASÓ" if ok else "❌ FALLÓ"
    resultados.append(dict(categoria="Conteo ETL", nombre=f"{tj}→{ts}",
                           estado=est, filas=abs(nj-ns), detalle=[] if ok else [f"jard={nj} stag={ns}"]))
    print(f"  {est}  [Conteo ETL] {tj}({nj}) → {ts}({ns})")

nj = cj2.execute("SELECT COUNT(*) FROM detalle_pedido").fetchone()[0]
ns = cs.execute("SELECT COUNT(*) FROM fact_pedidos").fetchone()[0]
ok = nj == ns
if not ok: errores += 1
est = "✅ PASÓ" if ok else "❌ FALLÓ"
print(f"  {est}  [Conteo ETL] detalle_pedido({nj}) → fact_pedidos({ns})")
resultados.append(dict(categoria="Conteo ETL", nombre="detalle_pedido→fact_pedidos",
                       estado=est, filas=abs(nj-ns), detalle=[]))
cj2.close(); cs.close()

# ── RESUMEN ──────────────────────────────────────────────────
total  = len(resultados)
ok_n   = sum(1 for r in resultados if "PASÓ"  in r["estado"])
fail_n = sum(1 for r in resultados if "FALLÓ" in r["estado"])
err_n  = sum(1 for r in resultados if "ERROR" in r["estado"])
pct    = round(ok_n/total*100,1)

print(f"""
{'='*60}
RESUMEN PRUEBAS DE CALIDAD — EA3 Grupo 10
{'='*60}
  Total pruebas  : {total}
  ✅ Pasaron     : {ok_n}
  ❌ Fallaron    : {fail_n}
  ⚠️  Errores     : {err_n}
  Calidad general: {pct}%
{'='*60}""")

# ── REPORTE MARKDOWN ─────────────────────────────────────────
reporte = f"""# Reporte de Calidad de Datos — EA3 Grupo 10
**Fecha:** {datetime.now().strftime('%Y-%m-%d %H:%M')}  
**Autor:** Kevin Andrés Valencia Daza  
**Docente:** Antonio Jesús Valderrama  

## Resumen

| Métrica | Valor |
|---------|-------|
| Total pruebas | {total} |
| ✅ Pasaron | {ok_n} |
| ❌ Fallaron | {fail_n} |
| ⚠️ Errores | {err_n} |
| **Calidad general** | **{pct}%** |

## Resultados Detallados

| Categoría | Prueba | Estado | Registros problemáticos |
|-----------|--------|--------|------------------------|
"""
for r in resultados:
    det = str(r["detalle"])[:50] if r["detalle"] else "—"
    reporte += f"| {r['categoria']} | {r['nombre']} | {r['estado']} | {r['filas'] if r['filas']>=0 else 'N/A'} |\n"

for path in ["EA3_CalidadDatos/reportes/reporte_calidad.md",
             "/content/reporte_calidad.md", "reporte_calidad.md"]:
    try:
        os.makedirs(os.path.dirname(path), exist_ok=True) if os.path.dirname(path) else None
        open(path,"w",encoding="utf-8").write(reporte)
        print(f"\n📄 Reporte guardado: {path}"); break
    except: continue
