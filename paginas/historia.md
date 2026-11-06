# Estación necesita más plazas: {{ pregunta_4.alquileres_por_plaza[0] }} alquileres por plaza, {{ historia_terreno.veces_la_segunda[0] }} veces más que cualquier otra zona

En **Estación** se piden {{ pregunta_4.alquileres[0] }} alquileres al día para solo {{ pregunta_4.plazas[0] }} plazas de aparcamiento: {{ pregunta_4.alquileres_por_plaza[0] }} alquileres por plaza, cuando la media de la ciudad es {{ historia_terreno.alquileres_por_plaza_ciudad[0] }}. No es un pico de una hora: Estación va más cargada que la hora más cargada de cualquier otra zona en {{ historia_terreno.horas_estacion_por_encima[0] }} de sus {{ historia_terreno.horas_estacion[0] }} horas de servicio. **Proponemos ampliar el aparcamiento de Estación hasta unas 30 plazas, con un piloto que empiece el 1 de junio de 2026**, y no ampliar Playa, que parecía la zona más cargada solo por un error en los datos.

```grafico
titular: Estación pide casi el triple de alquileres por plaza que la siguiente zona
modelo: pregunta_4
barras: zona → alquileres_por_plaza
destacar: Estación
referencia: historia_terreno.alquileres_por_plaza_ciudad · media de la ciudad
```

```grafico
tipo: calor
titular: Estación va cargada todo el día, no solo en la hora punta
modelo: historia_zona_hora
filas: zona
columnas: hora
valor: alquileres_por_plaza
destacar: Estación
```

Y la conclusión no sale de un error de datos. Si contáramos el registro tal cual llega, con los mensajes que los patinetes repiten cuando no tienen cobertura, la zona más cargada sería **{{ registro_sin_deduplicar.zona[0] }}** ({{ registro_sin_deduplicar.alquileres_por_plaza[0] }} por plaza). Al quitar las copias, Playa baja a {{ historia_contraste.limpio[2] }} y Estación apenas se mueve.

```grafico
titular: Sin limpiar, Playa parecía la zona más cargada; limpio, es Estación
modelo: historia_contraste
barras: zona → sin_limpiar, limpio
leyenda: registro tal cual, sin quitar copias · registro limpio
destacar: Estación
```

## Qué proponemos

1. **Ampliar el aparcamiento de Estación** de {{ pregunta_4.plazas[0] }} a unas 30 plazas, lo que la dejaría cerca de la media de la ciudad. Lo decide la **dirección de operaciones** y lo ejecuta el **equipo de flota**, con un piloto de cuatro semanas a partir del **1 de junio de 2026**.
2. **No ampliar Playa por ahora** y mejorar su cobertura, para que la app deje de recibir mensajes repetidos. Lo hace el **equipo técnico** antes del **15 de junio de 2026**.

## Qué no sabemos todavía

- Solo tenemos el registro de alquileres de **un día** (6 de mayo de 2026). Antes de dar el piloto por bueno hay que repetir el cálculo con varias semanas, incluidos fines de semana.
- Contamos cada alquiler en la zona donde **empieza**. Si lo que llena un aparcamiento es dónde **terminan** los alquileres, habría que repetir el cálculo con los eventos de fin.
- No sabemos si la demanda de Estación viene de los trenes (viajeros que llegan y salen). Es una hipótesis que no hemos podido comprobar con estos datos.

## La misma historia para cada audiencia

- **Comité de dirección (5 segundos):** Estación necesita más plazas: {{ pregunta_4.alquileres_por_plaza[0] }} alquileres por plaza, casi el triple que cualquier otra zona.
- **Responsable de operaciones (1 minuto):** Estación tiene {{ pregunta_4.plazas[0] }} plazas para {{ pregunta_4.alquileres[0] }} alquileres al día y va cargada en {{ historia_terreno.horas_estacion_por_encima[0] }} de sus {{ historia_terreno.horas_estacion[0] }} horas. Dos acciones: piloto con unas 30 plazas desde el 1 de junio y no tocar Playa hasta arreglar su cobertura.
- **Equipo de datos (5 minutos):** alquileres distintos con evento de inicio en el registro del 6 de mayo, quitados los {{ registro_sin_deduplicar.eventos_repetidos[0] }} eventos reenviados, divididos entre las plazas de cada zona (modelos `pregunta_4`, `historia_zona_hora` e `historia_contraste`). Sin quitar las copias saldría Playa.
