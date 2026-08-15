<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Alojamiento de eepsites con identidad persistente

- La capacidad de proxy inverso publica un servicio local como eepsite de I2P (sitio oculto).
- La clave de identidad del eepsite persiste entre reinicios mediante un volumen Docker.
- La clave de identidad se puede cargar desde secretos Docker para direcciones `.b32.i2p` reproducibles.
- La dirección `.b32.i2p` se extrae y registra automáticamente al inicio.
- Comando de generación de claves disponible mediante el tipo de secreto `docker-run`.
- Cabecera Host suplantada configurable para el frente Traefik con HostRegexp.
