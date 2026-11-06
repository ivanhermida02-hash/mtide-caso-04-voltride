-- HISTORIA · alquileres que empiezan en cada hora del día: en toda la ciudad y solo en Estación.
select
    hora,
    count(*)                                      as alquileres,
    count(*) filter (where zona = 'Estación')     as alquileres_estacion
from {{ ref('historia_alquileres') }}
group by hora
order by hora
