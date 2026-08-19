<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

<!-- textlint-disable terminology,common-misspellings -->

[English](../../README.md) · [Українська](../uk/README.md)

# F5M/I2P

Distribución de I2P mantenida por la comunidad, basada en B19/Java

[![Stand with Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://damian-buho.github.io/support-ukraine/) [![License](https://img.shields.io/static/v1?label=license&message=MIT&color=4c1&style=flat-square)](LICENSE) ![Commit style](https://img.shields.io/static/v1?label=commits&message=conventional&color=blue&style=flat-square) ![Workflow](https://img.shields.io/static/v1?label=workflow&message=git-flow&color=blue&style=flat-square) ![Versioning](https://img.shields.io/static/v1?label=versioning&message=semantic&color=blue&style=flat-square) [![PRs welcome](https://img.shields.io/static/v1?label=PRs&message=welcome&color=4c1&style=flat-square)](CONTRIBUTING.md) [![Citation](https://img.shields.io/static/v1?label=citation&message=cff&color=blue&style=flat-square)](CITATION.cff) [![REUSE compliance](https://api.reuse.software/badge/codeberg.org/f5m/i2p)](https://api.reuse.software/info/codeberg.org/f5m/i2p)

![Project status](https://img.shields.io/static/v1?label=status&message=maintained&color=1d63ed&style=flat-square) [![Last commit](https://img.shields.io/gitea/last-commit/f5m/i2p?gitea_url=https://codeberg.org&style=flat-square)](https://codeberg.org/f5m/i2p)

[![Build status on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/published.yaml/badge.svg)](https://kiota.ch/f5m/i2p/actions)

## Características

- Configuración de I2P renderizada con Jinja2
- Alojamiento de eepsites con identidad persistente
- Router de anonimato I2P

### Heredado de B19/Ubuntu 1.4.0

- Caché APT persistente entre compilaciones
- Gestión de procesos de servicio con enrutado de logs (b19-exec)
- Descargas de artefactos con caché y verificación de integridad (b19-fetch)
- Ejecución de comandos temporizada con informe de fallos (b19-run)
- Inicialización de una sola vez (bootstrap.d)
- Hooks de compilación modulares (build.d)
- Detección automática del número de CPUs (NUMPROCS)
- Gestión declarativa de dependencias (b19-deps)
- Sistema de arranque conectable (entrypoint.d)
- Conmutadores de funcionalidades para todos los subsistemas
- Monitorización de estado integrada (healthcheck.d)
- Salida de shell multilingüe (b19-i18n)
- Seguimiento del linaje de la imagen
- Logging estructurado con filtro por nivel (b19-log)
- Contenedor sin privilegios de root por defecto
- Soporte de compilación y runtime aislados de internet (air-gapped/offline)
- Inyección de overlays en runtime
- Imagen base reproducible (fijada por digest)
- Validación de puertos
- Familia unificada de runners del ciclo de vida
- Autocarga de secretos de Docker (secrets)
- Hooks de shell interactivo (shell.d)
- Gestión elegante de señales
- Plantillas de configuración Jinja2 (minijinja-cli)
- Framework de tests integrado (test.d)
- Herramientas de utilidad preinstaladas
- Rutas XDG Base Directory

Consulta [FEATURES.md](FEATURES.md) para ver la lista completa.

## Qué entrega este proyecto

- **Imagen de contenedor** `ghcr.io/damian-buho/f5m/i2p:latest`
- **Imagen de contenedor** `docker.io/damianbuho/f5m-i2p:latest`

## Instalación

Descarga la imagen de contenedor publicada:

### Descargar de GHCR

```sh
docker pull ghcr.io/damian-buho/f5m/i2p:latest
```

### Descargar de DockerHub

```sh
docker pull docker.io/damianbuho/f5m-i2p:latest
```

Las versiones estables también publican las etiquetas `X.Y.Z`, `X.Y` y `X`: descarga el nivel de precisión que quieras fijar.

Si los registros anteriores no están disponibles, descarga desde el origen:

### Descargar de Kiota

```sh
docker pull kiota.ch/f5m/i2p:latest
```

## Uso

Levanta la pila localmente:

```sh
make dc-up
make dc-logs
make dc-down
```

## Compilación

Ejecuta `make` sin argumentos para el destino predeterminado; ejecuta `make help` para listar todos los destinos.

Para el bucle de desarrollo local, `make dev-container` levanta el dev-container.

Puntos de entrada de la canalización:

- `make analyze` — Run the heavy analysis sweep (mutation testing, benchmarks)
- `make audited` — Re-scan the pinned dependencies and published artifacts for new vulnerabilities
- `make check-outdated` — Report every pinned dependency that lags upstream
- `make ready-to-publish` — Run the pseudo-CI pipeline locally — build, test and scan, without publishing

## Hoja de ruta

Consulta la [ROADMAP.md](../../ROADMAP.md) para ver lo que viene.

## Políticas

- [Cómo contribuir](CONTRIBUTING.md)
- [Política de seguridad](SECURITY.md)
- [Cómo obtener ayuda](SUPPORT.md)
- [Código de conducta](CODE_OF_CONDUCT.md)
- [Política sobre IA y LLM](AI_POLICY.md)

## Enlaces

- [Especificación de Projectfile](https://projectfile.org)

## Licencia

Este proyecto se publica bajo la licencia MIT — consulta el archivo [LICENSE](LICENSE) para más detalles.

<!-- textlint-enable -->
