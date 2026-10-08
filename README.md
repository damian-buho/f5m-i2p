<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

[Español](docs/es/README.md) · [Українська](docs/uk/README.md)

# F5M / I2P

Community-maintained distribution of I2P built on B19/Java. This repository holds only the packaging — Dockerfile, build scripts, and configuration, all MIT-licensed; the upstream I2P is fetched at build time and retains its own licensing.

[![Stand with Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://damian-buho.github.io/support-ukraine/) [![Projectfile inside](https://badges.kiota.ch/static/v1?label=projectfile&message=inside&labelColor=0d0d0d&color=8c6723&style=flat-square)](https://projectfile.org) [![License](https://badges.kiota.ch/static/v1?label=license&message=MIT&color=1e5913&style=flat-square)](LICENSE) [![Cosign](https://badges.kiota.ch/static/v1?label=cosign&message=enabled&color=1e5913&style=flat-square)](https://docs.sigstore.dev/cosign/verifying/verify/) ![ClamAV scanned](https://badges.kiota.ch/static/v1?label=clamav&message=scanned&color=1877aa&style=flat-square) [![PRs welcome](https://badges.kiota.ch/static/v1?label=PRs&message=welcome&color=1e5913&style=flat-square)](CONTRIBUTING.md) [![REUSE compliance](https://api.reuse.software/badge/github.com/damian-buho/f5m-i2p)](https://api.reuse.software/info/github.com/damian-buho/f5m-i2p)

![Project status](https://badges.kiota.ch/static/v1?label=status&message=maintained&color=1d63ed&style=flat-square) [![Last commit on GitHub](https://badges.kiota.ch/github/last-commit/damian-buho/f5m-i2p?label=last%20commit%20on%20GitHub&style=flat-square)](https://github.com/damian-buho/f5m-i2p) [![Last commit on kiota.ch](https://badges.kiota.ch/gitea/last-commit/f5m/i2p?gitea_url=https://kiota.ch&label=last%20commit%20on%20kiota.ch&style=flat-square)](https://kiota.ch/f5m/i2p)

[![Publish pipeline on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/published.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Vulnerability audit on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/audited.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Dependency freshness on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/check-outdated.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions) [![Analysis sweep on GitHub](https://github.com/damian-buho/f5m-i2p/actions/workflows/analyzed.yaml/badge.svg?style=flat-square)](https://github.com/damian-buho/f5m-i2p/actions)

[![Publish pipeline on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/published.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Vulnerability audit on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/audited.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Dependency freshness on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/check-outdated.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions) [![Analysis sweep on kiota.ch](https://kiota.ch/f5m/i2p/badges/workflows/analyzed.yaml/badge.svg?style=flat-square)](https://kiota.ch/f5m/i2p/actions)

## Features

- Jinja2-rendered I2P configuration
- Eepsite hosting with persistent identity
- I2P anonymity router
- Reseed and subscription presets for censored networks

It also inherits the features of B19 / Ubuntu — see [Features](docs/FEATURES.md) for the full list.

## What this provides

- **Container image** `ghcr.io/damian-buho/f5m/i2p:latest`
- **Container image** `damianbuho/f5m-i2p:latest`

## Installation

Pull the published container image:

### Pull from GHCR — linux/amd64

```sh
docker pull ghcr.io/damian-buho/f5m/i2p:latest
```

### Pull from DockerHub — linux/amd64

```sh
docker pull damianbuho/f5m-i2p:latest
```

Stable releases also publish `X.Y.Z`, `X.Y` and `X` tags — pull the precision you want to pin.

If the registries above are unreachable, pull from the origin instead:

### Pull from Kiota — linux/amd64

```sh
docker pull kiota.ch/f5m/i2p:latest
```

## Building

Clone the repository with its submodules:

```sh
git clone --recurse-submodules https://github.com/damian-buho/f5m-i2p i2p && cd i2p
```

Build the container image locally:

```sh
make container-build
```

- [Makefile reference](docs/how-to/MAKEFILE.md)

Run `make` with no arguments for the default target; run `make help` to list every target.

For the local dev loop, `make dev-container` brings up the dev-container.

Pipeline entry points:

- `make analyzed` — Run the heavy analysis sweep (mutation testing, benchmarks)
- `make audited` — Re-scan the pinned dependencies and published artifacts for new vulnerabilities
- `make check-outdated` — Report every pinned dependency that lags upstream
- `make ready-to-publish` — Run the pseudo-CI pipeline locally — build, test and scan, without publishing

## Roadmap

See the [Roadmap](docs/ROADMAP.md) for what is planned next.

## Policies

- [How to contribute](CONTRIBUTING.md)
- [Security policy](SECURITY.md)
- [Getting support](SUPPORT.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [AI and LLM Policy](AI_POLICY.md)

## Links

- [Projectfile Specification](https://projectfile.org)

Related projects: [F5M/Tor](https://kiota.ch/f5m/tor) | [F5M/Tor Snowflake](https://kiota.ch/f5m/tor-snowflake) | [F5M/OONI Probe](https://kiota.ch/f5m/ooni) | [F5M/Knot](https://kiota.ch/f5m/knot) | [F5M/Radicle](https://kiota.ch/f5m/radicle) | [F5M/Solid](https://kiota.ch/f5m/solid) | [F5M/SSH](https://kiota.ch/f5m/ssh)

## License

This project is licensed under MIT — see the [LICENSE](LICENSE) file for details.
