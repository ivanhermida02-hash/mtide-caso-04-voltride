-- Un alquiler son dos eventos: exactamente un inicio y un fin, y el fin no puede ser anterior al inicio.
-- Devuelve los alquileres que lo incumplen (con reenvíos sin quitar, saldrían con 2, 3... inicios).
select alquiler_id,
       count(*) filter (where tipo = 'inicio') as inicios,
       count(*) filter (where tipo = 'fin')    as fines,
       min(ts) filter (where tipo = 'inicio')  as ts_inicio,
       max(ts) filter (where tipo = 'fin')     as ts_fin
from {{ ref('stg_eventos') }}
group by alquiler_id
having inicios <> 1 or fines <> 1 or ts_fin < ts_inicio
