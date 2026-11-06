-- HISTORIA · un alquiler por fila (ya sin reenvíos): zona, hora de inicio y duración.
-- Junta el evento de inicio y el de fin de cada alquiler_id agrupando (un hecho, dos filas en el registro).
select
    alquiler_id,
    any_value(zona)                                        as zona,
    min(ts) filter (where tipo = 'inicio')                 as inicio,
    max(ts) filter (where tipo = 'fin')                    as fin,
    hour(min(ts) filter (where tipo = 'inicio'))           as hora,
    round(date_diff('second', min(ts) filter (where tipo = 'inicio'),
                              max(ts) filter (where tipo = 'fin')) / 60.0, 1) as duracion_min
from {{ ref('stg_eventos') }}
group by alquiler_id
