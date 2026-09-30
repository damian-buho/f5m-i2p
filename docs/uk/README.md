<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

<!-- textlint-disable terminology,common-misspellings -->

[English](../../README.md) · [Español](../es/README.md)

# F5M / I2P

Дистрибуція I2P з підтримкою спільноти, зібрана на основі B19/Java. Цей репозиторій містить лише пакування — Dockerfile, скрипти збирання та конфігурацію, усе під ліцензією MIT; вихідний код I2P отримують під час збирання, і він зберігає власну ліцензію.

[![Stand with Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://damian-buho.github.io/support-ukraine/) [![Projectfile inside](https://badges.kiota.ch/static/v1?label=projectfile&message=inside&labelColor=0d0d0d&color=8c6723&style=flat-square)](https://projectfile.org) [![License](https://badges.kiota.ch/static/v1?label=license&message=MIT&color=1e5913&style=flat-square)](LICENSE) [![PRs welcome](https://badges.kiota.ch/static/v1?label=PRs&message=welcome&color=1e5913&style=flat-square)](CONTRIBUTING.md) [![REUSE compliance](https://api.reuse.software/badge/github.com/damian-buho/f5m-i2p)](https://api.reuse.software/info/github.com/damian-buho/f5m-i2p)

![Project status](https://badges.kiota.ch/static/v1?label=status&message=maintained&color=1d63ed&style=flat-square) [![Last commit on GitHub](https://badges.kiota.ch/github/last-commit/damian-buho/f5m-i2p?label=last%20commit%20on%20GitHub&style=flat-square)](https://github.com/damian-buho/f5m-i2p) [![Last commit on kiota.ch](https://badges.kiota.ch/gitea/last-commit/f5m/i2p?gitea_url=https://kiota.ch&label=last%20commit%20on%20kiota.ch&style=flat-square)](https://kiota.ch/f5m/i2p)

[![Publish pipeline on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/published.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Vulnerability audit on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/audited.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Dependency freshness on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/check-outdated.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Analysis sweep on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/analyze.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions)

[![Publish pipeline on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/published.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Vulnerability audit on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/audited.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Dependency freshness on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/check-outdated.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Analysis sweep on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/analyze.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions)

## Можливості

- Конфігурація I2P, відтворена з Jinja2
- Хостинг eepsite зі сталою ідентичністю
- Маршрутизатор анонімності I2P
- Пресети ресиду й підписок для цензурованих мереж

Також успадковує можливості B19 / Ubuntu — повний перелік див. у [Можливості](FEATURES.md).

## Що надає цей проєкт

- **Образ контейнера** `ghcr.io/damian-buho/f5m/i2p:latest`
- **Образ контейнера** `damianbuho/f5m-i2p:latest`

## Встановлення

Завантажте опублікований образ контейнера:

### Завантажити з GHCR — linux/amd64

```sh
docker pull ghcr.io/damian-buho/f5m/i2p:latest
```

### Завантажити з DockerHub — linux/amd64

```sh
docker pull damianbuho/f5m-i2p:latest
```

Стабільні випуски також публікують теґи `X.Y.Z`, `X.Y` і `X` — завантажте той рівень точності, який хочете зафіксувати.

Якщо наведені вище реєстри недоступні, завантажте з джерела:

### Завантажити з Kiota — linux/amd64

```sh
docker pull kiota.ch/f5m/i2p:latest
```

## Збирання

Клонуйте репозиторій разом із підмодулями:

```sh
git clone --recurse-submodules https://github.com/damian-buho/f5m-i2p i2p && cd i2p
```

Зберіть образ контейнера локально:

```sh
make container-build
```

- [Довідник із Makefile](../how-to/MAKEFILE.md)

Виконайте `make` без аргументів для типової цілі; виконайте `make help`, щоб переглянути всі цілі.

Для локального циклу розробки `make dev-container` піднімає dev-container.

Точки входу конвеєра:

- `make analyze` — Запускає важкий аналіз (мутаційне тестування, бенчмарки)
- `make audited` — Повторно сканує закріплені залежності й опубліковані артефакти на нові вразливості
- `make check-outdated` — Звітує про кожну закріплену залежність, що відстає від upstream
- `make ready-to-publish` — Запускає псевдо-CI локально — збирає, тестує й сканує без публікації

## Дорожня карта

Див. [Дорожня карта](../ROADMAP.md), щоб дізнатися про заплановане.

## Політики

- [Як зробити внесок](CONTRIBUTING.md)
- [Політика безпеки](SECURITY.md)
- [Як отримати підтримку](SUPPORT.md)
- [Кодекс поведінки](CODE_OF_CONDUCT.md)
- [Політика щодо ШІ та LLM](AI_POLICY.md)

## Посилання

- [Специфікація Projectfile](https://projectfile.org)

Пов’язані проєкти: [F5M/Tor](https://kiota.ch/f5m/tor) | [F5M/Tor Snowflake](https://kiota.ch/f5m/tor-snowflake) | [F5M/OONI Probe](https://kiota.ch/f5m/ooni) | [F5M/Knot](https://kiota.ch/f5m/knot) | [F5M/Radicle](https://kiota.ch/f5m/radicle) | [F5M/Solid](https://kiota.ch/f5m/solid) | [F5M/SSH](https://kiota.ch/f5m/ssh)

## Ліцензія

Цей проєкт ліцензовано на умовах MIT — див. файл [LICENSE](LICENSE) для подробиць.

<!-- textlint-enable -->
