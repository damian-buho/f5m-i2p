<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Preajustes de reseed y suscripciones para redes censuradas

- Lista curada de servidores reseed incluida en la imagen, para que el primer arranque encuentre pares sin depender solo de los valores integrados.
- Suscripciones curadas a la libreta de direcciones incluidas en la imagen, para que los nombres de eepsites resuelvan desde el primer arranque.
- Servidores y suscripciones extra se agregan con variables de entorno; cada preajuste incluido se puede desactivar por separado.
- Los datos existentes del rúter nunca se sobrescriben — los cambios de la consola sobreviven a los reinicios.
- Reseed mediante proxy (HTTP, SOCKS4/5 o el outproxy de I2P) configurable con variables de entorno para redes con cortafuegos.

<!-- textlint-enable -->
