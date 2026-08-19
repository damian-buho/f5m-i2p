<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# f5m/i2p

Docker image built on [b19/Java](../../b19/java/AGENTS.md)

I2P anonymity network router.

## Key facts

- Base: `b19/java/oracle-25` (`B19_JAVA_DISTRO=oracle`, `B19_JAVA_SERIES=25`)
- Installed via silent installer (hash-verified via `b19-fetch`)
- Arch: amd64 only
- Pinned version: `.container/user/deps/i2p/version.deps` (hash-verified via `b19-fetch`)
- Embedded python (for `extract-b32-address`): interpreter tree copied from `b19/python-3.14`; the `.makefile/b19/images/python.yaml` include composes `B19_PYTHON_BASE_IMAGE` and carries the pip-vendored (msgpack/setuptools) vulnerability suppressions the copied tree inherits

## Ports

- `7657` — router console (web UI)
- `4444` — HTTP proxy
- `4445` — HTTPS proxy (disabled by default)

## ENV (selected)

- `F5M_I2P_EEPSITE_ENABLED=true` (reverse proxies to `F5M_I2P_EEPSITE_TARGET_HOST`:`F5M_I2P_EEPSITE_TARGET_PORT`)
- `F5M_I2P_EEPSITE_KEY_FILE="${XDG_DATA_HOME}/eepsite/eepPriv.dat"` — absolute, so the httpserver tunnel reads the key where `200-prepare-eepsite.sh` loads it (a relative default resolved against the router dir `/app` and the provisioned identity was ignored)
- `F5M_I2P_EEPSITE_SPOOFED_HOST=""` — empty by default so the original Host passes through (a reverse-proxy eepsite must not rewrite it)
- `F5M_I2P_HTTP_PROXY_ENABLED=true`
- `F5M_I2P_IPV4_FIREWALLED=true`, `F5M_I2P_IPV6=false`, `F5M_I2P_UPNP=false`
- `B19_JAVA_XMS=128m`, `B19_JAVA_XMX=256m`

## Config templates

`router.config.j2`, `i2ptunnel.config.j2`, `clients.config.j2`, `wrapper.config.j2`, `vm.options.j2`

## Volume

`i2p-data` → `/app/data` — persists the eepsite identity key (`/app/data/eepsite/eepPriv.dat`) + router netDb across restarts. (`/app/bin/eepsite` is the installer’s stock skeleton and persists nothing.)

## Native crypto (java.io.tmpdir)

I2P extracts its native crypto libraries (`libjcpuid.so`, `libjbigi.so`) to the Java tmp dir. The b19 base sets `TMPDIR=/tmp`, which is **noexec** on hardened hosts — the libs then fail to load (`failed to map segment from shared object`) and I2P falls back to pure-Java crypto, far too slow to build tunnels. The wrapper config pins `java.io.tmpdir` to `${XDG_CACHE_HOME}/tmp` (writable AND executable); `5000-start.sh` creates it before the JVM starts.

## Secrets

- `f5m.i2p.persona-eepsite-key` — I2P eepsite private key, in I2P’s binary `eepPriv.dat` format
- Generated via `docker-run` secret type (runs `generate-eepsite-key` command). `generate-eepsite-key` writes ONLY the raw binary key to stdout — the Java `PrivateKeyFile` tool’s text dump (Destination/B32) is redirected to stderr so it never pollutes the captured secret
- `200-prepare-eepsite.sh` `cp`s the secret verbatim to `eepPriv.dat` if no existing key is found
- `.b32.i2p` address derived via `extract-b32-address`, which uses the Java `PrivateKeyFile` tool (authoritative for the binary format) with a python fallback
- The key is **binary** (non-UTF-8). `b19-load-secrets` therefore does NOT export it as an env var — it is read directly from `/run/secrets/f5m.i2p.persona-eepsite-key` by `200-prepare-eepsite.sh`. (Exporting it used to panic `minijinja-cli --env` during j2 rendering, silently leaving every config template at its build-time default — e.g. the eepsite forwarded to `localhost` instead of `F5M_I2P_EEPSITE_TARGET_HOST`.)

## Not included

No SAM bridge, no Jetty, no browser launch in default config.

## Documentation

- [Project goals and objectives](@docs/goal.md)
- [Fitness criteria and acceptance criteria](@docs/fit.md)
- [Completed features and milestones](@docs/done.md)
- [Known limitations and caveats](@docs/caveats.md)
- [Future development plans](@docs/roadmap.md)
- [Available make targets and usage](@docs/MAKEFILE.md)
