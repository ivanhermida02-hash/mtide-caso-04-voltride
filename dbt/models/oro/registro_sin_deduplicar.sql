-- Contrafactual para el portal: la pregunta 4 si se contaran las filas de inicio de bronce tal cual,
-- sin quitar los reenvíos «al menos una vez». Sirve para enseñar qué habría salido sin tratar el giro.
with inicios as (
    select zona, count(*) as filas_inicio
    from {{ source('bronce', 'eventos') }}
    where tipo = 'inicio'
    group by zona
)
select
    p.zona,
    round(i.filas_inicio / p.plazas, 2) as alquileres_por_plaza,
    i.filas_inicio,
    p.plazas,
    (select count(*) from {{ source('bronce', 'eventos') }})                       as filas_bronce,
    (select count(distinct evento_id) from {{ source('bronce', 'eventos') }})       as eventos_distintos,
    (select count(*) from (select evento_id from {{ source('bronce', 'eventos') }}
                           group by evento_id having count(*) > 1))                 as eventos_repetidos
from {{ ref('stg_aparcamientos') }} p
join inicios i using (zona)
order by alquileres_por_plaza desc, p.zona
