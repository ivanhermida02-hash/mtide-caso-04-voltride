-- ORO · dimensión zona: una fila por cada valor distinto de zona en el parte limpio.
select distinct zona
from {{ ref('stg_parte') }}
where zona is not null
order by zona
