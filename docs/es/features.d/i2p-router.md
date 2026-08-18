<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Router de anonimato I2P

- Router I2P completo instalado mediante instalador silencioso con verificación de hash.
- Consola del router accesible en el puerto 7657 con enrutado Traefik.
- Proxy HTTP (puerto 4444) para navegar eepsites de I2P; proxy HTTPS disponible (desactivado por defecto).
- Detección de IPv4 tras cortafuegos, IPv6 desactivado y UPnP desactivado por defecto para un recorrido de NAT predecible.
- Memoria de la JVM limitada por defecto a un heap de 128m a 256m, configurable mediante el entorno.

<!-- textlint-enable -->
