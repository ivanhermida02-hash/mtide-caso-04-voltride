-- P4 · ¿En qué zona se piden más alquileres por cada plaza de aparcamiento?
-- Nivel de respuesta: una fila por zona. Cada parte se lleva a ese nivel por separado y luego se unen:
--   alquileres: alquiler_id distintos con evento de inicio en stg_eventos (ya sin reenvíos),
--   plazas: una fila por zona en stg_aparcamientos.
-- Unirlas antes de agrupar multiplicaría las filas.
with alquileres as (
    select zona, count(distinct alquiler_id) as alquileres
    from {{ ref('stg_eventos') }}
    where tipo = 'inicio'
    group by zona
)
select
    p.zona,
    round(a.alquileres / p.plazas, 2)  as alquileres_por_plaza,
    a.alquileres,
    p.plazas
from {{ ref('stg_aparcamientos') }} p
join alquileres a using (zona)
order by alquileres_por_plaza desc, p.zona
