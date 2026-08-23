<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Outproxy y SOCKS configurables

- **Problema.** Los hosts del outproxy están cableados y no hay ningún túnel SOCKS, así que un operador que quiera una salida clearnet distinta — o cualquier cliente SOCKS5 — debe editar la plantilla; peor aún, el outproxy HTTPS predeterminado enruta silenciosamente el tráfico clearnet a través de un nodo Tor de terceros.
- **En estudio.** Templar los outproxys HTTP y HTTPS desde el entorno y añadir un túnel cliente SOCKS activable en un puerto convencional, de modo que el operador elija la salida y cualquier aplicación SOCKS funcione.
- **Depende de.** Las claves de túnel outproxy de I2P y su tipo de túnel cliente SOCKS; la plantilla Jinja2 existente que ya define los túneles HTTP y CONNECT.

<!-- textlint-enable -->
