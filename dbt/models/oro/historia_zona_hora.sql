-- HISTORIA · zona × hora: alquileres que empiezan y los mismos divididos entre las plazas de la zona.
-- Cada parte se lleva a zona × hora antes de unir con las plazas (una fila por zona), así no se multiplican.
with conteo as (
    select zona, hora, count(*) as alquileres
    from {{ ref('historia_alquileres') }}
    group by zona, hora
)
select
    c.zona,
    c.hora,
    c.alquileres,
    round(c.alquileres / p.plazas, 2) as alquileres_por_plaza
from conteo c
join {{ ref('stg_aparcamientos') }} p using (zona)
order by c.zona, c.hora
