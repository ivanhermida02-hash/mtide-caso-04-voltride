-- ORO · dimensión patinete: una fila por cada valor distinto de patinete en el parte limpio.
select distinct patinete
from {{ ref('stg_parte') }}
where patinete is not null
order by patinete
