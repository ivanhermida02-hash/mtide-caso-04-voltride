-- PLATA · el parte diario limpio: la limpieza que hiciste en la J3, ahora como modelo dbt.
-- Cada entrega del parte es una carpeta fecha_carga=… en bronce: aquí se leen todas juntas.
with bruto as (
    select *, parse_filename(filename) as archivo
    from {{ source('bronce', 'parte') }}
),
sin_dup as (
    -- una fila por trayecto
    select * from bruto
    qualify row_number() over (partition by trayecto order by fecha_carga desc) = 1
),
mediana_zona as (
    select zona, median(minutos::integer) as minutos_mediana
    from sin_dup
    where minutos::integer between 1 and 180
    group by zona
)
select
    s.trayecto,
    s.fecha::date                                              as fecha,
    upper(trim(s.usuario))                                         as usuario,
    s.patinete,
    s.zona,
    case when s.minutos::integer between 1 and 180 then s.minutos::integer
         else round(m.minutos_mediana)::integer end               as minutos,
    not (s.minutos::integer between 1 and 180)                   as minutos_corregido,
    -- ARREGLO REMESA 2026-05-04 · Desde el 2026-04-29 (actualización de firmware) los patinetes mandan
    -- bateria_pct como fracción (0.071 = 7,1 %) en vez de en puntos porcentuales: 59 trayectos de la
    -- remesa, todos con valores entre 0 y 1, cuando antes nunca bajaba de 1.75. Lo descubrió el test
    -- rango_consumo (FAIL 59). Lo arreglo aquí y no en bronce porque bronce es la prueba de lo que llegó.
    -- Multiplico por 100 los valores < 1: es el mismo dato en otra unidad y así no pierdo ninguna fila;
    -- uso el valor y no la fecha para que una entrega futura con el firmware viejo o nuevo se trate bien.
    case when s.bateria_pct::double < 1 then round(s.bateria_pct::double * 100, 1)
         else s.bateria_pct::double end                           as bateria_pct,
    s.bateria_pct::double < 1                                     as bateria_corregida,
    s.importe_eur::double                                      as importe_eur,
    s.incidencia,
    s.archivo,
    s.fecha_carga
from sin_dup s
join mediana_zona m using (zona)
