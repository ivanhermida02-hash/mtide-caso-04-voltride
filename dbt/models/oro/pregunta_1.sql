-- P1 · ¿Qué zona deja menos ingreso por minuto de trayecto?
-- Cociente de totales (no media de cocientes): euros de la zona / minutos de la zona.
select
    zona,
    round(sum(importe_eur) / sum(minutos), 3) as ingreso_min,
    count(*)                                  as trayectos,
    sum(minutos)                              as minutos,
    round(sum(importe_eur), 2)                as importe_eur
from {{ ref('fact_trayectos') }}
group by zona
order by ingreso_min asc, zona
