-- P3 · ¿Qué patinete acumula más incidencias por cada 100 minutos de uso?
select
    patinete,
    round(count(*) filter (where con_incidencia) / sum(minutos) * 100, 2) as incidencias_100min,
    count(*) filter (where con_incidencia)                               as incidencias,
    count(*)                                                             as trayectos,
    sum(minutos)                                                         as minutos
from {{ ref('fact_trayectos') }}
group by patinete
order by incidencias_100min desc, patinete
