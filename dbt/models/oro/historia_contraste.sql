-- HISTORIA · alquileres por plaza con el registro tal cual llega (con reenvíos) y limpio (pregunta_4).
-- Demuestra que la conclusión no sale de un error de datos: limpio, Estación; sin limpiar, Playa.
select
    q.zona,
    s.alquileres_por_plaza as sin_limpiar,
    q.alquileres_por_plaza as limpio,
    q.alquileres,
    q.plazas
from {{ ref('pregunta_4') }} q
join {{ ref('registro_sin_deduplicar') }} s using (zona)
order by limpio desc, q.zona
