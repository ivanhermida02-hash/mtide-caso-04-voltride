# Cómo se construyó la historia

La portada cuenta el destino. Aquí queda el viaje: la decisión que hay detrás, lo que buscamos en los datos y lo que dejamos fuera.

## Paso 1 · De tema a decisión

| | |
|---|---|
| **Tema** | El aparcamiento de los patinetes en la ciudad |
| **Pregunta** | ¿En qué zona se piden más alquileres por cada plaza de aparcamiento? |
| **Decisión** | La dirección de operaciones decide en qué zona amplía plazas, para el piloto del 1 de junio de 2026. Si se equivoca, gasta en plazas que no se usan y deja sin sitio la zona que las necesita. |

**La prueba:** después de leer la portada, la dirección sabe dónde poner las plazas nuevas (Estación) y dónde no (Playa), y cuántas hacen falta más o menos.

## Paso 2 · Qué se mueve en los datos

### 2a · El terreno

```cifras
{{ historia_terreno.alquileres[0] }} | alquileres en el registro del 6 de mayo, ya sin copias
{{ historia_terreno.plazas[0] }} | plazas de aparcamiento en las 8 zonas
{{ historia_terreno.alquileres_por_plaza_ciudad[0] }} | alquileres por plaza de media en la ciudad
{{ historia_terreno.duracion_mediana_min[0] }} min | duración típica (mediana) de un alquiler
```

```grafico
tipo: linea
titular: Alquileres que empiezan en cada hora del día, en la ciudad y en Estación
modelo: historia_hora
x: hora
y: alquileres, alquileres_estacion
```

```grafico
tipo: histograma
titular: Cuánto dura un alquiler
modelo: historia_alquileres
columna: duracion_min
tramo: 2
marcas: media, mediana
```

```grafico
titular: Alquileres por zona en el día
modelo: pregunta_4
barras: zona → alquileres
orden: desc
```

A simple vista no destaca nada: los alquileres se reparten de forma bastante plana entre las 7 y las 22 h, casi todos duran entre 5 y 30 minutos, y en número absoluto Playa y Estación están empatadas en cabeza.

### 2b · El disparador

El disparador aparece al dividir los alquileres entre las plazas de cada zona: Estación sube a {{ pregunta_4.alquileres_por_plaza[0] }} alquileres por plaza, {{ historia_terreno.veces_la_segunda[0] }} veces más que la segunda ({{ pregunta_4.zona[1] }}, {{ pregunta_4.alquileres_por_plaza[1] }}). Por zona y hora se ve que no es un momento puntual.

```grafico
tipo: calor
titular: Alquileres por plaza según zona y hora de inicio
modelo: historia_zona_hora
filas: zona
columnas: hora
valor: alquileres_por_plaza
```

**El hallazgo en una frase:** Estación tiene la demanda de una zona grande ({{ pregunta_4.alquileres[0] }} alquileres) con el aparcamiento de la zona más pequeña ({{ pregunta_4.plazas[0] }} plazas), y por eso soporta {{ pregunta_4.alquileres_por_plaza[0] }} alquileres por plaza durante casi todo el día. El motivo de esa demanda (los trenes) es una **hipótesis**: no está en los datos.

### 2c · Qué lo puede explicar

- **Anomalía:** no. Estación va por encima de las demás en {{ historia_terreno.horas_estacion_por_encima[0] }} de sus {{ historia_terreno.horas_estacion[0] }} horas, así que no es un pico raro de una hora.
- **Cambio significativo:** no lo podemos saber, porque solo tenemos un día de registro.
- **Fuerzas del mercado:** probablemente sí. Una estación de tren mueve viajeros todo el día, pero es una hipótesis.
- **Iniciativas propias:** no. No sabemos de ninguna promoción de VoltRide en Estación.

## Paso 3 · Qué datos entran y cuáles se quedan fuera

| Dato candidato | ¿Pasa el filtro? | Dónde se usa |
|---|---|---|
| Alquileres por plaza y zona (pregunta 4) | Sí: es la decisión | Titular y primer gráfico de la portada |
| Alquileres por zona y hora | Sí: demuestra que no es un pico | Mapa de calor de la portada |
| Registro sin limpiar frente a limpio | Sí: demuestra que no es un error de datos | Contraste de la portada |
| Duración de los alquileres | No: no cambia dónde poner plazas | Solo en el terreno (2a) |
| Ingreso por minuto, batería e incidencias (preguntas 1 a 3) | No: son otras decisiones | Memo para la dirección |

**Sin limpiar frente a limpio.** Al limpiar el registro quitamos {{ registro_sin_deduplicar.eventos_repetidos[0] }} eventos que llegaban repetidos, casi todos de Playa. Con el registro tal cual, la más cargada sería {{ registro_sin_deduplicar.zona[0] }} ({{ registro_sin_deduplicar.alquileres_por_plaza[0] }}); limpio, es {{ pregunta_4.zona[0] }} ({{ pregunta_4.alquileres_por_plaza[0] }}). Estación es la primera limpia y la segunda sin limpiar, así que la conclusión aguanta y no sale del error.

```grafico
tipo: eje
titular: Mismos datos, dos lecturas: el eje manda
modelo: pregunta_4
barras: zona → alquileres
corte: 70
```

Con el eje cortado en 70, Playa y Estación parecen tener ocho veces más alquileres que Centro; con el eje desde cero se ve la realidad: algo menos del doble.

**El alcance.** Los datos salen de dos ficheros que mandó VoltRide: las plazas de aparcamiento de las 8 zonas y el registro de alquileres de la app del 6 de mayo de 2026 ({{ registro_sin_deduplicar.filas_bronce[0] }} filas, que se quedan en {{ stg_eventos.filas }} eventos y {{ historia_terreno.alquileres[0] }} alquileres al quitar las copias). No se ha quitado ningún alquiler: solo las copias del mismo evento.

## Las cinco comprobaciones

- **Hay una decisión detrás:** dónde ampliar plazas de aparcamiento para el piloto del 1 de junio.
- **El titular afirma:** «Estación necesita más plazas», con su cifra ({{ pregunta_4.alquileres_por_plaza[0] }} alquileres por plaza).
- **Cada cifra tiene fuente:** todas salen con marca de los modelos de oro (`pregunta_4`, `historia_*`, `registro_sin_deduplicar`), y cada gráfico lleva la fuente al pie.
- **La evidencia es diversa:** barras, mapa de calor, contraste sin limpiar frente a limpio, línea, histograma y eje.
- **Lo que no cuadra se dice:** solo hay un día de datos, contamos la zona de inicio y no la de fin, y el motivo (los trenes) es una hipótesis.
