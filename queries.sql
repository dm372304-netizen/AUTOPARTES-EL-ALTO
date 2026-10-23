-- ============================================================
-- Consultas SELECT que responden preguntas reales del proyecto
-- ============================================================

-- Q1 (CU-06) Que productos estan en o bajo su stock minimo y hay que reponer?
SELECT p.codigo_barras,
       p.nombre,
       c.nombre                         AS categoria,
       p.stock_actual,
       p.stock_minimo,
       (p.stock_minimo - p.stock_actual) AS faltante
FROM producto p
JOIN categoria c ON c.id = p.id_categoria
WHERE p.stock_actual <= p.stock_minimo
ORDER BY faltante DESC;

-- Q2 (CU-10) Cuales son los 5 repuestos mas vendidos en los ultimos 30 dias?
SELECT p.nombre,
       SUM(dv.cantidad) AS unidades_vendidas,
       SUM(dv.subtotal) AS ingresos_bs
FROM detalle_venta dv
JOIN venta    v ON v.id = dv.id_venta
JOIN producto p ON p.id = dv.id_producto
WHERE v.fecha >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY p.id, p.nombre
ORDER BY unidades_vendidas DESC
LIMIT 5;

-- Q3 Cuanto vendio cada vendedor hoy? (apoyo al cuadre de caja)
SELECT u.nombre,
       COUNT(v.id)  AS nro_ventas,
       SUM(v.total) AS total_bs
FROM venta v
JOIN usuario u ON u.id = v.id_usuario
WHERE v.fecha::date = CURRENT_DATE
GROUP BY u.id, u.nombre
ORDER BY total_bs DESC;

-- Q4 Que productos no se vendieron en 90 dias (mercaderia obsoleta)?
SELECT p.nombre,
       p.stock_actual,
       (p.stock_actual * p.precio_venta) AS valor_inmovilizado_bs
FROM producto p
WHERE NOT EXISTS (
    SELECT 1
    FROM detalle_venta dv
    JOIN venta v ON v.id = dv.id_venta
    WHERE dv.id_producto = p.id
      AND v.fecha >= CURRENT_DATE - INTERVAL '90 days'
)
ORDER BY valor_inmovilizado_bs DESC;
