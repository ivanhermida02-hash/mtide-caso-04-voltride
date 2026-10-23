-- ORO · tabla de hechos: un trayecto por fila (el grano del parte), con sus medidas.
-- usuario, patinete y zona son las claves hacia dim_usuario, dim_patinete y dim_zona.
select
    trayecto,
    fecha,
    usuario,
    patinete,
    zona,
    minutos,
    bateria_pct,
    importe_eur,
    incidencia is not null as con_incidencia
from {{ ref('stg_parte') }}
