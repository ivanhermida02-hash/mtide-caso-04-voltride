-- HISTORIA · el terreno en una fila: cifras de contexto para la página «Cómo se construyó la historia».
select
    (select count(*) from {{ ref('historia_alquileres') }})                 as alquileres,
    (select sum(plazas) from {{ ref('stg_aparcamientos') }})                as plazas,
    (select round(sum(a.alquileres) / sum(a.plazas), 2) from {{ ref('pregunta_4') }} a) as alquileres_por_plaza_ciudad,
    (select median(duracion_min) from {{ ref('historia_alquileres') }})     as duracion_mediana_min,
    (select round(q.alquileres_por_plaza / (select alquileres_por_plaza from {{ ref('pregunta_4') }} limit 1 offset 1), 1)
       from {{ ref('pregunta_4') }} q limit 1)                              as veces_la_segunda,
    -- horas en las que Estación supera la peor hora (la más cargada) de cualquier otra zona
    (select count(*) from {{ ref('historia_zona_hora') }}
      where zona = 'Estación'
        and alquileres_por_plaza > (select max(alquileres_por_plaza) from {{ ref('historia_zona_hora') }} where zona <> 'Estación')
    )                                                                       as horas_estacion_por_encima,
    (select max(alquileres_por_plaza) from {{ ref('historia_zona_hora') }} where zona <> 'Estación') as maximo_otras_zonas,
    (select count(distinct hora) from {{ ref('historia_zona_hora') }} where zona = 'Estación') as horas_estacion
