<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# f5m/i2p

Docker image built on [b19/Ubuntu](../../b19/ubuntu/AGENTS.md), with a slim Java runtime from [b19/Java](../../b19/java/AGENTS.md)

I2P anonymity network router.

## Key facts

- Stages: `compile-java` (`FROM b19/java:oracle-27`) runs the silent installer as uid 1000, then `build-stage export` as root; the final stage is `FROM b19/ubuntu` and copies `/export`. `B19_JAVA_DISTRO=temurin` is pinned in this projectfile’s `org.projectfile.build.args`; the series comes from the `m6e/library` language fragment
- `B19_JAVA_BUILD_IMAGE` (no `_BASE_`: a copy edge, since the final image carries no `b19/java` layer) is declared in this projectfile’s `org.projectfile.images`; it belongs in `m6e/b19/images/java.yaml` once a second project exports from `b19/java`
- The runtime has no `jar` or `javac`: `get-i2p-version` asks I2P’s own `net.i2p.router.RouterVersion`. `java.desktop` (console graphs) and `jdk.localedata` are most of its 90 MB of modules
- `500-export-i2p.sh` copies every top-level entry of `${B19_HOME}` except `.i2p`, `jmx-exporter` and the installer’s `response.txt*`, plus `/deps/i2p/version.deps`
- Installed via silent installer (hash-verified via `b19-fetch`)
- Arch: amd64 only
- Pinned version: `.container/compile-java/deps/i2p/version.deps` (hash-verified via `b19-fetch`)
- No python: `extract-b32-address` uses I2P’s own `PrivateKeyFile` only. The copied interpreter tree was 263 MB (161 MB of it `test/` archive fixtures) and its nested archives tripped ClamAV `MaxRecursion` on the image tar — do not re-add one
- APT packages come from `.container/root/deps/common.apt.deps` — `install-apt` runs only where the stage user is root, and it reads no other filename, so a deps file in a `user` stage (or named anything but `*.apt.deps`) installs nothing and reports nothing
- Console graphs need a JVM font: `fontconfig` + `fonts-dejavu-core` in that file, or `viewstat.jsp` answers 500 (`Fontconfig head is null`) while every other console page stays healthy. `test.d/2300-check-console-graph.sh` is the guard
- Console setup wizard: the flag is `routerconsole.welcomeWizardComplete` in the router dir’s `router.config`, which the router dir loses on every recreate. `5000-start.sh` seeds it, `test.d/2200-check-console-home.sh` is the guard

## Ports

- `7657` — router console (web UI)
- `7654` — I2CP, loopback only unless `F5M_I2P_I2CP_BIND` says otherwise
- `7656` — SAM bridge (disabled by default, same bind)
- `4444` — HTTP proxy
- `4445` — HTTPS proxy (disabled by default)

## ENV (selected)

- `F5M_I2P_EEPSITE_ENABLED=true` (reverse proxies to `F5M_I2P_EEPSITE_TARGET`, `host:port` — one var, not split `_HOST`/`_PORT`, so a numeric port never lands in a `*PORT` env var and trips `check-ports`). `false` drops every eepsite tunnel, so it is the kill switch for the `mirrors.d` sites too
- `F5M_I2P_MIRRORS_DIR="/app/config/mirrors.d"` + `F5M_I2P_MIRROR_TARGET=""` — one `<site>.conf` per eepsite, the same directory `f5m/tor` reads its onion mirrors from: filename = site (tunnel `i2ptunnel.config.d/<site>.config`, key `eepsite/<site>.dat`, secret `f5m.i2p.<site>-eepsite-key`), optional `target=host:port` falling back to the mirror target, and a file with no usable target or an unknown key is logged by name and skipped while the other sites still render. With no file at all, the `F5M_I2P_EEPSITE_*` vars publish one eepsite named after its key file, so a single-eepsite deployment needs no file. Files are read as data, never sourced
- `F5M_I2P_EEPSITE_KEY_FILE="${XDG_DATA_HOME}/eepsite/eepPriv.dat"` — absolute, so the httpserver tunnel reads the key where `200-prepare-eepsites.sh` loads it (a relative default resolved against the router dir `/app` and the provisioned identity was ignored). It is the key file of the env-driven eepsite only; a `mirrors.d` site uses `eepsite/<site>.dat`
- `F5M_I2P_EEPSITE_SPOOFED_HOST=""` — empty by default so the original Host passes through (a reverse-proxy eepsite must not rewrite it)
- `F5M_I2P_HTTP_PROXY_ENABLED=true`
- `F5M_I2P_I2CP_BIND="127.0.0.1"` — one address for I2CP, the SAM listener and every tunnel’s `i2cpHost`; `router.config.j2` derives `i2cp.tcp.bindAllInterfaces` from it and `test.d/2460-check-i2cp-bind.sh` is the guard. I2CP authenticates nothing, so a sibling container that needs it (`f5m/i2p-reseed` serving I2P or a shared-peer bootstrap) sets `0.0.0.0` on the compose side, and that is the only reason to leave loopback. This is the bind variable `03-bind-address-remote-access.md` extends, not a second one
- `F5M_I2P_IPV4_FIREWALLED=true`, `F5M_I2P_IPV6=false`, `F5M_I2P_UPNP=false`
- `B19_JAVA_XMS=128m`, `B19_JAVA_XMX=256m`

## Config templates

`router.config.j2`, `i2ptunnel.config.j2`, `clients.config.j2`, `wrapper.config.j2`, `vm.options.j2`

The router reads the router dir (`${B19_HOME}/.i2p`) and nothing else, and it never reads `${B19_HOME}/router.config` on its own. `5000-start.sh` restores a missing `hosts.txt` from the base; without it the naming service starts with zero entries, so every subscription (all `.i2p` URLs) fails and no eepsite resolves while the router reports healthy (`test.d/2800-check-hosts.sh` is the guard — a `router.config.d` drop-in is not read).

`250-apply-env-config.sh` is what makes the other templates take effect. I2P splits a monolithic `i2ptunnel.config` or `clients.config` into per-entry drop-ins under `<router dir>/<name>.config.d/` on the first boot (naming them `NN-<name>-i2ptunnel.config` and `NN-<main>-clients.config`) and then reads only those, so a file copied back into the router dir is ignored. The script therefore writes one drop-in per rendered entry on every start, under the same names, and re-applies the keys `router.config.j2` declares over the file the router itself rewrites on every boot — `test.d/2450-check-applied-config.sh` fails if any rendered entry or key is missing from the router dir. Before it existed, an env change on an existing volume was a silent no-op: every `F5M_I2P_*` var kept its first-boot value. A drop-in in those directories that this script did not render is logged as unreviewed, never deleted: operator drop-ins and console-created tunnels live there too.

A j2 tag closing with `-%}` on its own line strips the newline after itself and glues the next key onto the previous one. In `i2ptunnel.config.j2` that once turned `tunnel.3.type=httpserver` into the unknown type `httpservertunnel.3.targetHost=localhost`, so the eepsite tunnel never started and the router logged the failure once at startup. `test.d/2400-check-tunnel-types.sh` asserts every type line the template declares is rendered verbatim, and `test.d/2500-check-eepsite-tunnel.sh` skips unless `F5M_I2P_EEPSITE_ENABLED=true`.

Eepsites are NOT in the template: `200-prepare-eepsites.sh` renders one `httpserver` drop-in per declared site into `<router dir>/i2ptunnel.config.d/<site>.config` (keys without the `tunnel.N.` prefix, the form I2P itself writes), loads each site key from `/run/secrets/f5m.i2p.<site>-eepsite-key`, and drops the tunnel of a site that is no longer declared — the drop-ins it owns are listed in `<router dir>/eepsites.list`, which the sixth argument of `_ac_project_dropins` subtracts from the unreviewed-drop-in warning. It also deletes `03-I2P webserver-i2ptunnel.config`, the projection of the env-driven `tunnel.3` an older volume still carries, so an upgrade cannot leave a second stale eepsite answering. `test.d/2550-check-mirrors.sh` covers an empty dir, two sites and one malformed file.

`entrypoint.d` scripts are SOURCED by the harness under `set -euo pipefail`, not executed: fall off the end, never `exit` — an `exit 0` aborts the whole chain before `5000-start.sh`, so the router never starts and the container exits 0 with no error. (`test.d` scripts run as subprocesses, where `exit` is correct.)

## Reseed and subscription presets

- Preset files ship baked in: `${B19_HOME}/presets/subscriptions.txt` (one hosts.txt URL per line, trust order) and `${B19_HOME}/presets/reseeds.txt` (one directory URL per line, trailing slash) — mount over either path to customize without rebuilding
- `F5M_I2P_SUBSCRIPTIONS_URLS` / `F5M_I2P_RESEED_URLS` (comma/whitespace separated) append to the preset, deduped, preset first; `F5M_I2P_SUBSCRIPTIONS_PRESET_ENABLED=false` / `F5M_I2P_RESEED_PRESET_ENABLED=false` disables the file so only the ENV list applies (empty both means the router falls back to its own defaults)
- Seed-only-when-missing: `210-prepare-subscriptions.sh` writes `addressbook/subscriptions.txt` and `220-prepare-reseed.sh` appends `i2p.reseedURL` + proxy keys only where the file/key is absent, so console edits survive restarts; `test.d/2600-check-subscriptions.sh` + `2700-check-reseed.sh` are the guards
- The merge lives in entrypoint scripts, not j2: minijinja renders from ENV only and cannot read preset files, so `router.config.j2` carries no reseed keys and the scripts seed both the base file (fresh volumes inherit via the `5000-start.sh` copy) and the router-dir file (existing volumes)
- `reseed.kiota.ch` signs as `damian.buho@proton.me`, a signer stock I2P does not ship, so its public certificate ships at `${B19_HOME}/certificates/reseed/damian.buho_at_proton.me.crt` (the router names a signer file by replacing `@` with `_at_`); without it every bundle from that server fails with `unknown signer`. `test.d/2900-check-reseed-signer.sh` is the guard
- Reseed proxy is `router.reseedSSLProxy*` only (every bundled URL is HTTPS): `F5M_I2P_RESEED_PROXY_ENABLED`, `F5M_I2P_RESEED_PROXY_TYPE` (`HTTP`, `SOCKS4`, `SOCKS5`, `INTERNAL`), `F5M_I2P_RESEED_PROXY` as one `host:port` var — never a `*PORT` name, same `check-ports` reason as `F5M_I2P_EEPSITE_TARGET`; `INTERNAL` (I2P outproxy) leaves host/port blank and the router derives `localhost:4444` itself

## Volume

Two of them, and the split is not cosmetic: `${B19_HOME}/.i2p` is the router dir, where netDb, `router.keys.dat` (the router identity, and therefore the address), `router.info`, `peerProfiles`, `addressbook`, `i2psnark` and the rendered eepsite drop-ins are written; `${XDG_DATA_HOME}` (`/app/data`) carries the eepsite identity keys (`eepsite/<site>.dat` per `mirrors.d` site, plus `eepsite/eepPriv.dat` for the env-driven one) and the JVM tmp dir. `.container/user/build.d/volumes.deps` pre-creates both so a fresh named volume gets the right ownership, but a compose file that mounts only `/app/data` still re-bootstraps the router on every recreate — mount both. (`/app/bin/eepsite` is the installer’s stock skeleton and persists nothing.)

## Native crypto (java.io.tmpdir)

I2P extracts its native crypto libraries (`libjcpuid.so`, `libjbigi.so`) to the Java tmp dir. The b19 base sets `TMPDIR=/tmp`, which is **noexec** on hardened hosts — the libs then fail to load (`failed to map segment from shared object`) and I2P falls back to pure-Java crypto, far too slow to build tunnels. The wrapper config pins `java.io.tmpdir` to `${XDG_CACHE_HOME}/tmp` (writable AND executable); `5000-start.sh` creates it before the JVM starts.

## Secrets

- `f5m.i2p.<site>-eepsite-key` — I2P eepsite private key for one site, in I2P’s binary `eepPriv.dat` format; `site` is the `mirrors.d` filename, or the literal `site` for the env-driven eepsite. The image names no consumer
- Generated via `docker-run` secret type (runs `generate-eepsite-key` command). `generate-eepsite-key` writes ONLY the raw binary key to stdout, an Ed25519 destination (`-c EdDSA_SHA512_Ed25519`, 679 bytes, key certificate `05 0004 0007 0000` at byte 384; I2P’s default is the deprecated `DSA_SHA1`) — the Java `PrivateKeyFile` tool’s text dump is discarded, since it prints the private signing key — and FAILS instead of falling back (`test.d/2560-check-eepsite-keygen.sh` pins all three): an `openssl` Ed25519 DER blob base64-wrapped is not an `eepPriv.dat`, and the only symptom is an eepsite that answers on an address nobody recorded
- `200-prepare-eepsites.sh` `cp`s the secret verbatim to the site key file if no key exists yet
- `.b32.i2p` address derived per site via `extract-b32-address`, which uses the Java `PrivateKeyFile` tool (authoritative for the binary format)
- The key is **binary** (non-UTF-8). `b19-load-secrets` therefore does NOT export it as an env var — it is read directly from `/run/secrets/f5m.i2p.<site>-eepsite-key`. (Exporting it used to panic `minijinja-cli --env` during j2 rendering, silently leaving every config template at its build-time default — e.g. the eepsite forwarded to `localhost` instead of `F5M_I2P_EEPSITE_TARGET`.) A compose file must map the secret to that exact target name: the short source name alone lands at `/run/secrets/<name>` and a throwaway identity is minted instead

## Not included

No SAM bridge, no Jetty, no browser launch in default config.

## Documentation

- [Features](@docs/FEATURES.md), one fragment per feature in `docs/features.d/`
- [Roadmap](@docs/ROADMAP.md), one fragment per item in `docs/roadmap.d/`
- [Available make targets and usage](@docs/how-to/MAKEFILE.md)
