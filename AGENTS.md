<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# f5m/i2p

Docker image built on [b19/Java](../../b19/java/AGENTS.md)

I2P anonymity network router.

## Key facts

- Base: `b19/java/temurin-26` (`B19_JAVA_DISTRO=temurin`, `B19_JAVA_SERIES=26`, pinned in this projectfile’s `org.projectfile.build.args` — the base document wins over both include fragments)
- Installed via silent installer (hash-verified via `b19-fetch`)
- Arch: amd64 only
- Pinned version: `.container/user/deps/i2p/version.deps` (hash-verified via `b19-fetch`)
- Embedded python (for `extract-b32-address`): interpreter tree copied from `b19/python-3.14`; the `.makefile/b19/images/python.yaml` include composes `B19_PYTHON_BASE_IMAGE` and carries the pip-vendored (msgpack/setuptools) vulnerability suppressions the copied tree inherits
- APT packages come from `.container/root/deps/common.apt.deps` — `install-apt` runs only where the stage user is root, and it reads no other filename, so a deps file in a `user` stage (or named anything but `*.apt.deps`) installs nothing and reports nothing
- Console graphs need a JVM font: `fontconfig` + `fonts-dejavu-core` in that file, or `viewstat.jsp` answers 500 (`Fontconfig head is null`) while every other console page stays healthy. `test.d/2300-check-console-graph.sh` is the guard
- Console setup wizard: the flag is `routerconsole.welcomeWizardComplete` in the router dir’s `router.config`, which the router dir loses on every recreate. `5000-start.sh` seeds it, `test.d/2200-check-console-home.sh` is the guard

## Ports

- `7657` — router console (web UI)
- `4444` — HTTP proxy
- `4445` — HTTPS proxy (disabled by default)

## ENV (selected)

- `F5M_I2P_EEPSITE_ENABLED=true` (reverse proxies to `F5M_I2P_EEPSITE_TARGET`, `host:port` — one var, not split `_HOST`/`_PORT`, so a numeric port never lands in a `*PORT` env var and trips `check-ports`)
- `F5M_I2P_EEPSITE_KEY_FILE="${XDG_DATA_HOME}/eepsite/eepPriv.dat"` — absolute, so the httpserver tunnel reads the key where `200-prepare-eepsite.sh` loads it (a relative default resolved against the router dir `/app` and the provisioned identity was ignored)
- `F5M_I2P_EEPSITE_SPOOFED_HOST=""` — empty by default so the original Host passes through (a reverse-proxy eepsite must not rewrite it)
- `F5M_I2P_HTTP_PROXY_ENABLED=true`
- `F5M_I2P_IPV4_FIREWALLED=true`, `F5M_I2P_IPV6=false`, `F5M_I2P_UPNP=false`
- `B19_JAVA_XMS=128m`, `B19_JAVA_XMX=256m`

## Config templates

`router.config.j2`, `i2ptunnel.config.j2`, `clients.config.j2`, `wrapper.config.j2`, `vm.options.j2`

The router reads the router dir (`${B19_HOME}/.i2p`) and nothing else, and it never reads `${B19_HOME}/router.config` on its own. `5000-start.sh` copies `clients.config`, `i2ptunnel.config` and `router.config` from the base into the router dir when the file is missing, which is what makes all three templates take effect — a `router.config.d` drop-in is not read. Without the copy the router creates its own config and runs on stock defaults: `router.hiddenMode`, `i2np.ipv4.firewalled`, the IPv6 keys, `i2np.upnp.enable` and `i2cp.tcp.bindAllInterfaces` were all no-ops until the restore was extended, and a container with the copy reports `Network: Hidden` where a default one reports `Network: Firewalled`. The wizard flag is seeded separately, after the copy, so it also lands on a router dir that already existed.

A j2 tag closing with `-%}` on its own line strips the newline after itself and glues the next key onto the previous one. In `i2ptunnel.config.j2` that turned `tunnel.3.type=httpserver` into the unknown type `httpservertunnel.3.targetHost=localhost`, so the eepsite tunnel never started and the router logged the failure once at startup. `test.d/2400-check-tunnel-types.sh` asserts every type line the template declares is rendered verbatim, and `test.d/2500-check-eepsite-tunnel.sh` skips unless `F5M_I2P_EEPSITE_ENABLED=true`.

`entrypoint.d` scripts are SOURCED by the harness under `set -euo pipefail`, not executed: fall off the end, never `exit` — an `exit 0` aborts the whole chain before `5000-start.sh`, so the router never starts and the container exits 0 with no error. (`test.d` scripts run as subprocesses, where `exit` is correct.)

## Reseed and subscription presets

- Preset files ship baked in: `${B19_HOME}/presets/subscriptions.txt` (one hosts.txt URL per line, trust order) and `${B19_HOME}/presets/reseeds.txt` (one directory URL per line, trailing slash) — mount over either path to customize without rebuilding
- `F5M_I2P_SUBSCRIPTIONS_URLS` / `F5M_I2P_RESEED_URLS` (comma/whitespace separated) append to the preset, deduped, preset first; `F5M_I2P_SUBSCRIPTIONS_PRESET_ENABLED=false` / `F5M_I2P_RESEED_PRESET_ENABLED=false` disables the file so only the ENV list applies (empty both means the router falls back to its own defaults)
- Seed-only-when-missing: `210-prepare-subscriptions.sh` writes `addressbook/subscriptions.txt` and `220-prepare-reseed.sh` appends `i2p.reseedURL` + proxy keys only where the file/key is absent, so console edits survive restarts; `test.d/2600-check-subscriptions.sh` + `2700-check-reseed.sh` are the guards
- The merge lives in entrypoint scripts, not j2: minijinja renders from ENV only and cannot read preset files, so `router.config.j2` carries no reseed keys and the scripts seed both the base file (fresh volumes inherit via the `5000-start.sh` copy) and the router-dir file (existing volumes)
- Reseed proxy is `router.reseedSSLProxy*` only (every bundled URL is HTTPS): `F5M_I2P_RESEED_PROXY_ENABLED`, `F5M_I2P_RESEED_PROXY_TYPE` (`HTTP`, `SOCKS4`, `SOCKS5`, `INTERNAL`), `F5M_I2P_RESEED_PROXY` as one `host:port` var — never a `*PORT` name, same `check-ports` reason as `F5M_I2P_EEPSITE_TARGET`; `INTERNAL` (I2P outproxy) leaves host/port blank and the router derives `localhost:4444` itself

## Volume

`i2p-data` → `/app/data` — persists the eepsite identity key (`/app/data/eepsite/eepPriv.dat`) + router netDb across restarts. (`/app/bin/eepsite` is the installer’s stock skeleton and persists nothing.)

## Native crypto (java.io.tmpdir)

I2P extracts its native crypto libraries (`libjcpuid.so`, `libjbigi.so`) to the Java tmp dir. The b19 base sets `TMPDIR=/tmp`, which is **noexec** on hardened hosts — the libs then fail to load (`failed to map segment from shared object`) and I2P falls back to pure-Java crypto, far too slow to build tunnels. The wrapper config pins `java.io.tmpdir` to `${XDG_CACHE_HOME}/tmp` (writable AND executable); `5000-start.sh` creates it before the JVM starts.

## Secrets

- `f5m.i2p.persona-eepsite-key` — I2P eepsite private key, in I2P’s binary `eepPriv.dat` format
- Generated via `docker-run` secret type (runs `generate-eepsite-key` command). `generate-eepsite-key` writes ONLY the raw binary key to stdout — the Java `PrivateKeyFile` tool’s text dump (Destination/B32) is redirected to stderr so it never pollutes the captured secret
- `200-prepare-eepsite.sh` `cp`s the secret verbatim to `eepPriv.dat` if no existing key is found
- `.b32.i2p` address derived via `extract-b32-address`, which uses the Java `PrivateKeyFile` tool (authoritative for the binary format) with a python fallback
- The key is **binary** (non-UTF-8). `b19-load-secrets` therefore does NOT export it as an env var — it is read directly from `/run/secrets/f5m.i2p.persona-eepsite-key` by `200-prepare-eepsite.sh`. (Exporting it used to panic `minijinja-cli --env` during j2 rendering, silently leaving every config template at its build-time default — e.g. the eepsite forwarded to `localhost` instead of `F5M_I2P_EEPSITE_TARGET`.)

## Not included

No SAM bridge, no Jetty, no browser launch in default config.

## Documentation

- [Project goals and objectives](@docs/goal.md)
- [Fitness criteria and acceptance criteria](@docs/fit.md)
- [Completed features and milestones](@docs/done.md)
- [Known limitations and caveats](@docs/caveats.md)
- [Future development plans](@docs/roadmap.md)
- [Available make targets and usage](@docs/MAKEFILE.md)
