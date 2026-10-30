-- PLATA · plazas de aparcamiento de cada zona (fuente de referencia nueva), tipada.
-- Viene limpia: solo se quitan espacios y se fija el tipo de plazas.
select
    trim(zona)        as zona,
    plazas::integer   as plazas
from {{ source('bronce', 'aparcamientos') }}
