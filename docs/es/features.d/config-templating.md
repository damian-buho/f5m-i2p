<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Configuración de I2P renderizada con Jinja2

- El router, los túneles, los clientes, el wrapper y las opciones de la JVM se renderizan todos desde plantillas Jinja2 al inicio.
- Cada subsistema de I2P (SAM, IRC, POP3, SMTP, Jetty, SSH, lanzamiento del navegador) se puede activar o desactivar mediante variables de entorno.
- La longitud y la cantidad de túneles de entrada y salida son configurables por túnel de eepsite.
