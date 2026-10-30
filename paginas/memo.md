# Memo para la dirección de VoltRide

*Datos: parte de trayectos del 6 de abril al 3 de mayo ({{ fact_trayectos.filas }} trayectos) y registro de alquileres de la app del 6 de mayo ({{ stg_eventos.filas }} eventos). Todas las cifras se recalculan solas cuando llegan datos nuevos.*

## Qué hemos visto

- **Hay que poner plazas en {{ pregunta_4.zona[0] }}.** Allí se piden **{{ pregunta_4.alquileres_por_plaza[0] }} alquileres por cada plaza** de aparcamiento ({{ pregunta_4.alquileres[0] }} alquileres en un día para {{ pregunta_4.plazas[0] }} plazas). La siguiente zona, {{ pregunta_4.zona[1] }}, se queda en {{ pregunta_4.alquileres_por_plaza[1] }}.
- **{{ pregunta_1.zona[0] }} es la zona que menos ingresa por minuto**: **{{ pregunta_1.ingreso_min[0] }} €/min**, frente a {{ pregunta_1.ingreso_min[7] }} €/min de {{ pregunta_1.zona[7] }}, la que más.
- **{{ pregunta_2.usuario[0] }} es el usuario que más batería gasta**: **{{ pregunta_2.bateria_10min[0] }} % cada 10 minutos**, frente a {{ pregunta_2.bateria_10min[1] }} % del siguiente.
- **El patinete {{ pregunta_3.patinete[0] }} es el que más incidencias acumula**: **{{ pregunta_3.incidencias_100min[0] }} cada 100 minutos de uso**, el doble que el siguiente ({{ pregunta_3.patinete[1] }}, {{ pregunta_3.incidencias_100min[1] }}).

## Qué recomendamos

1. **Ampliar el aparcamiento de {{ pregunta_4.zona[0] }}** antes que en ninguna otra zona. Con {{ pregunta_4.plazas[0] }} plazas soporta {{ pregunta_4.alquileres_por_plaza[0] }} alquileres por plaza; para bajar al nivel de la segunda zona ({{ pregunta_4.alquileres_por_plaza[1] }}) haría falta del orden del triple de plazas. **No ampliar Playa por ahora**: tiene muchos alquileres, pero también {{ pregunta_4.plazas[2] }} plazas ({{ pregunta_4.alquileres_por_plaza[2] }} por plaza).
2. **Revisar la tarifa de {{ pregunta_1.zona[0] }}.** Cada minuto allí deja {{ pregunta_1.ingreso_min[0] }} €, casi la mitad que en el resto: conviene mirar si hay un bono o una promoción que se aplique solo allí.
3. **Mandar el patinete {{ pregunta_3.patinete[0] }} a revisión** ({{ pregunta_3.incidencias[0] }} incidencias en {{ pregunta_3.minutos[0] }} minutos).
4. **Hablar con {{ pregunta_2.usuario[0] }}** o revisar sus trayectos: gasta más batería por minuto que nadie y eso acorta la autonomía de la flota.
5. **Mejorar la cobertura en Playa**: allí los patinetes reenvían sus mensajes una y otra vez (el registro del día tiene {{ registro_sin_deduplicar.filas_bronce[0] }} filas para {{ registro_sin_deduplicar.eventos_distintos[0] }} eventos reales, casi todas las copias de Playa), y con datos así cualquier recuento sin limpiar engaña.

## Qué no sabemos todavía

- **Un solo día de alquileres.** La pregunta 4 sale del registro del 6 de mayo. Antes de invertir en plazas habría que confirmarla con varias semanas, incluidos fines de semana.
- **Supuesto de la pregunta 4**: cada alquiler cuenta en la zona donde empieza. Si lo que llena el aparcamiento es dónde **terminan**, habría que repetir el cálculo con los eventos de fin.
- **No sabemos por qué {{ pregunta_1.zona[0] }} ingresa tan poco**: el parte no trae la tarifa aplicada a cada trayecto.
- **Lo que hemos corregido en los datos**: {{ calidad_parte.filas[0] }} trayectos con la batería en otra unidad tras el cambio de firmware, {{ calidad_parte.filas[1] }} trayectos con minutos imposibles (sustituidos por la mediana de su zona), nombres de usuario escritos de varias formas y {{ registro_sin_deduplicar.eventos_repetidos[0] }} eventos repetidos en el registro.

## Cómo se ha hecho

Los datos llegan a un *lakehouse* en tres capas: **bronce** guarda tal cual lo que manda cada sistema, **plata** lo limpia y **oro** lo resume en una tabla de trayectos con sus usuarios, patinetes y zonas, y en las cuatro respuestas. Cada paso tiene pruebas automáticas que paran el proceso si un dato no cumple las reglas del negocio.

- **El problema de calidad**: desde el {{ calidad_parte.desde[0] }}, tras una actualización de firmware, los patinetes mandan la batería como fracción (0,07 en lugar de 7 %). Lo detectó la prueba `rango_consumo` y se corrige en plata; la prueba `bateria_en_porcentaje` vigila desde ahora que no vuelva a pasar. Sin ese arreglo, la respuesta sobre consumo de batería habría sido errónea.
- **El test protagonista**: `unique` sobre `evento_id` en `stg_eventos` (cada evento cuenta una sola vez). Sin quitar los reenvíos fallaba con {{ registro_sin_deduplicar.eventos_repetidos[0] }} eventos repetidos y la pregunta 4 señalaba a {{ registro_sin_deduplicar.zona[0] }} ({{ registro_sin_deduplicar.alquileres_por_plaza[0] }} por plaza) en lugar de a {{ pregunta_4.zona[0] }}.
