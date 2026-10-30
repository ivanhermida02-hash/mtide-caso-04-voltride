-- Después del arreglo de la remesa, ninguna batería de plata puede quedar en fracción (0-1):
-- vigila que el cambio de unidad del firmware no vuelva a colarse.
select trayecto, fecha, bateria_pct from {{ ref('stg_parte') }}
where bateria_pct < 1
