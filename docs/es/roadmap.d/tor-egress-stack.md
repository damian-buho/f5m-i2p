<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Salida Tor unificada con f5m/tor

- **Problema.** El outproxy HTTPS apunta a un nodo Tor de terceros, así que el operador confía su tráfico clearnet a un desconocido, y I2P y Tor corren como pilas separadas sin salida ni observabilidad compartidas.
- **En estudio.** Una única pila compose que use el contenedor `f5m/tor` del propio operador como outproxy clearnet de I2P y salida de reseed, eliminando la confianza en terceros y unificando la identidad persistente y las métricas de ambos.
- **Depende de.** El puerto SOCKS de la imagen hermana `f5m/tor` y las claves de outproxy y reseed de I2P ya templadas; la maquinaria compose existente que ambas imágenes comparten.

<!-- textlint-enable -->
