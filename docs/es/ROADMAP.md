<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

[English](../../ROADMAP.md) · [Українська](../uk/ROADMAP.md)

# Hoja de ruta

## Hoja de ruta del proyecto

### Reseed que funciona tras un cortafuegos

- **Problema.** La configuración del router no tiene claves de reseed, así que recurre a hosts de reseed HTTPS de clearnet — justo lo primero que falla tras un cortafuegos nacional, dejando al operador de una red censurada con un router que nunca construye una base de datos de red.
- **En estudio.** URLs de reseed configurables por entorno, una opción de reseed a través de Tor o un paquete de reseed sin conexión incluido, de modo que el primer arranque alcance un netDb funcional en un entorno censurado.
- **Depende de.** Las claves de configuración `i2p.reseed.*` de I2P; la imagen hermana `f5m/tor`, por la que saldría una ruta de reseed sobre Tor.

### Outproxy y SOCKS configurables

- **Problema.** Los hosts del outproxy están cableados y no hay ningún túnel SOCKS, así que un operador que quiera una salida clearnet distinta — o cualquier cliente SOCKS5 — debe editar la plantilla; peor aún, el outproxy HTTPS predeterminado enruta silenciosamente el tráfico clearnet a través de un nodo Tor de terceros.
- **En estudio.** Templar los outproxys HTTP y HTTPS desde el entorno y añadir un túnel cliente SOCKS activable en un puerto convencional, de modo que el operador elija la salida y cualquier aplicación SOCKS funcione.
- **Depende de.** Las claves de túnel outproxy de I2P y su tipo de túnel cliente SOCKS; la plantilla Jinja2 existente que ya define los túneles HTTP y CONNECT.

### Salida Tor unificada con f5m/tor

- **Problema.** El outproxy HTTPS apunta a un nodo Tor de terceros, así que el operador confía su tráfico clearnet a un desconocido, y I2P y Tor corren como pilas separadas sin salida ni observabilidad compartidas.
- **En estudio.** Una única pila compose que use el contenedor `f5m/tor` del propio operador como outproxy clearnet de I2P y salida de reseed, eliminando la confianza en terceros y unificando la identidad persistente y las métricas de ambos.
- **Depende de.** El puerto SOCKS de la imagen hermana `f5m/tor` y las claves de outproxy y reseed de I2P ya templadas; la maquinaria compose existente que ambas imágenes comparten.
<!-- textlint-enable -->
