-- PLATA · registro de alquileres de la app: un evento (inicio o fin) por fila.
-- ARREGLO DEL GIRO · Los patinetes mandan cada evento «al menos una vez»: si no reciben confirmación,
-- lo reenvían con el MISMO evento_id. En bronce hay 2.435 filas pero solo 1.548 evento_id distintos,
-- y casi todos los reenvíos son de Playa (mala cobertura). Si no se quitan, Playa parece tener
-- muchos más alquileres de los reales. Las copias son idénticas (mismo alquiler, tipo, zona y hora),
-- así que me quedo con una fila por evento_id; ordeno por ts y por la posición en el fichero para
-- que la elección sea siempre la misma. El orden de llegada no importa: la hora que vale es ts.
with bruto as (
    select *, row_number() over () as orden_llegada
    from {{ source('bronce', 'eventos') }}
)
select
    evento_id,
    alquiler_id,
    patinete,
    trim(zona)           as zona,
    lower(trim(tipo))    as tipo,
    ts::timestamp        as ts
from bruto
qualify row_number() over (partition by evento_id order by ts, orden_llegada) = 1
