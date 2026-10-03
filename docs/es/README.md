<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

<!-- textlint-disable terminology,common-misspellings -->

[English](../../README.md) · [Українська](../uk/README.md)

# F5M / I2P

Distribución de I2P mantenida por la comunidad, construida sobre B19/Java. Este repositorio contiene únicamente el empaquetado — Dockerfile, scripts de compilación y configuración, todo con licencia MIT; el código original de I2P se obtiene en tiempo de compilación y conserva su propia licencia.

[![Stand with Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://damian-buho.github.io/support-ukraine/) [![Projectfile inside](https://badges.kiota.ch/static/v1?label=projectfile&message=inside&labelColor=0d0d0d&color=8c6723&style=flat-square)](https://projectfile.org) [![License](https://badges.kiota.ch/static/v1?label=license&message=MIT&color=1e5913&style=flat-square)](LICENSE) [![PRs welcome](https://badges.kiota.ch/static/v1?label=PRs&message=welcome&color=1e5913&style=flat-square)](CONTRIBUTING.md) [![REUSE compliance](https://api.reuse.software/badge/github.com/damian-buho/f5m-i2p)](https://api.reuse.software/info/github.com/damian-buho/f5m-i2p)

![Project status](https://badges.kiota.ch/static/v1?label=status&message=maintained&color=1d63ed&style=flat-square) [![Last commit on GitHub](https://badges.kiota.ch/github/last-commit/damian-buho/f5m-i2p?label=last%20commit%20on%20GitHub&style=flat-square)](https://github.com/damian-buho/f5m-i2p) [![Last commit on kiota.ch](https://badges.kiota.ch/gitea/last-commit/f5m/i2p?gitea_url=https://kiota.ch&label=last%20commit%20on%20kiota.ch&style=flat-square)](https://kiota.ch/f5m/i2p)

[![Publish pipeline on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/published.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Vulnerability audit on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/audited.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Dependency freshness on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/check-outdated.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Analysis sweep on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/analyzed.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions)

[![Publish pipeline on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/published.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Vulnerability audit on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/audited.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Dependency freshness on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/check-outdated.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Analysis sweep on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/analyze.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions)

## Características

- Configuración de I2P renderizada con Jinja2
- Alojamiento de eepsites con identidad persistente
- Router de anonimato I2P
- Preajustes de reseed y suscripciones para redes censuradas

También hereda las características de B19 / Ubuntu; consulta [Características](FEATURES.md) para ver la lista completa.

## Qué entrega este proyecto

- **Imagen de contenedor** `ghcr.io/damian-buho/f5m/i2p:latest`
- **Imagen de contenedor** `damianbuho/f5m-i2p:latest`

## Instalación

Descarga la imagen de contenedor publicada:

### Descargar de GHCR — linux/amd64

```sh
docker pull ghcr.io/damian-buho/f5m/i2p:latest
```

### Descargar de DockerHub — linux/amd64

```sh
docker pull damianbuho/f5m-i2p:latest
```

Las versiones estables también publican las etiquetas `X.Y.Z`, `X.Y` y `X`: descarga el nivel de precisión que quieras fijar.

Si los registros anteriores no están disponibles, descarga desde el origen:

### Descargar de Kiota — linux/amd64

```sh
docker pull kiota.ch/f5m/i2p:latest
```

## Compilación

Clona el repositorio con sus submódulos:

```sh
git clone --recurse-submodules https://github.com/damian-buho/f5m-i2p i2p && cd i2p
```

Construye la imagen de contenedor en local:

```sh
make container-build
```

- [Referencia del Makefile](../how-to/MAKEFILE.md)

Ejecuta `make` sin argumentos para el destino predeterminado; ejecuta `make help` para listar todos los destinos.

Para el bucle de desarrollo local, `make dev-container` levanta el dev-container.

Puntos de entrada de la canalización:

- `make analyzed` — Ejecuta el análisis pesado (pruebas de mutación, benchmarks)
- `make audited` — Vuelve a escanear las dependencias fijadas y los artefactos publicados en busca de vulnerabilidades nuevas
- `make check-outdated` — Informa de cada dependencia fijada que va por detrás de su versión upstream
- `make ready-to-publish` — Ejecuta localmente el pipeline pseudo-CI — compila, prueba y escanea, sin publicar

## Hoja de ruta

Consulta la [Hoja de ruta](../ROADMAP.md) para ver lo que viene.

## Políticas

- [Cómo contribuir](CONTRIBUTING.md)
- [Política de seguridad](SECURITY.md)
- [Cómo obtener ayuda](SUPPORT.md)
- [Código de conducta](CODE_OF_CONDUCT.md)
- [Política sobre IA y LLM](AI_POLICY.md)

## Enlaces

- [Especificación de Projectfile](https://projectfile.org)

Proyectos relacionados: [F5M/Tor](https://kiota.ch/f5m/tor) | [F5M/Tor Snowflake](https://kiota.ch/f5m/tor-snowflake) | [F5M/OONI Probe](https://kiota.ch/f5m/ooni) | [F5M/Knot](https://kiota.ch/f5m/knot) | [F5M/Radicle](https://kiota.ch/f5m/radicle) | [F5M/Solid](https://kiota.ch/f5m/solid) | [F5M/SSH](https://kiota.ch/f5m/ssh)

## Licencia

Este proyecto se publica bajo la licencia MIT — consulta el archivo [LICENSE](LICENSE) para más detalles.

<!-- textlint-enable -->
