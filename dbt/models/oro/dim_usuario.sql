-- ORO · dimensión usuario: una fila por cada valor distinto de usuario en el parte limpio.
select distinct usuario
from {{ ref('stg_parte') }}
where usuario is not null
order by usuario
