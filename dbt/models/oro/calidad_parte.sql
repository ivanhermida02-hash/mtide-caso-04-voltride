-- Control de calidad del parte: cuántos trayectos ha tenido que corregir plata, por problema.
-- Lo usa el portal para citar las cifras del bloque 1 con marcas (no es una de las tablas del encargo).
select 'bateria_en_fraccion' as problema,
       count(*) filter (where bateria_corregida)         as filas,
       min(fecha) filter (where bateria_corregida)       as desde,
       count(distinct fecha_carga) filter (where bateria_corregida) as entregas
from {{ ref('stg_parte') }}
union all
select 'minutos_fuera_de_rango',
       count(*) filter (where minutos_corregido),
       min(fecha) filter (where minutos_corregido),
       count(distinct fecha_carga) filter (where minutos_corregido)
from {{ ref('stg_parte') }}
