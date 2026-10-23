-- P2 · ¿Qué usuario gasta más batería por minuto? En % de batería cada 10 minutos de trayecto.
select
    usuario,
    round(sum(bateria_pct) / sum(minutos) * 10, 2) as bateria_10min,
    count(*)                                       as trayectos,
    sum(minutos)                                   as minutos
from {{ ref('fact_trayectos') }}
group by usuario
order by bateria_10min desc, usuario
