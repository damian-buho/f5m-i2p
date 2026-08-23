<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Reseed que funciona tras un cortafuegos

- **Problema.** La configuración del router no tiene claves de reseed, así que recurre a hosts de reseed HTTPS de clearnet — justo lo primero que falla tras un cortafuegos nacional, dejando al operador de una red censurada con un router que nunca construye una base de datos de red.
- **En estudio.** URLs de reseed configurables por entorno, una opción de reseed a través de Tor o un paquete de reseed sin conexión incluido, de modo que el primer arranque alcance un netDb funcional en un entorno censurado.
- **Depende de.** Las claves de configuración `i2p.reseed.*` de I2P; la imagen hermana `f5m/tor`, por la que saldría una ruta de reseed sobre Tor.

<!-- textlint-enable -->
