<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Eepsite hosting with persistent identity

- Reverse proxy capability publishes a local service as an I2P eepsite (hidden site).
- Eepsite identity key persisted across restarts via Docker volume.
- Identity key loadable from Docker secrets for reproducible `.b32.i2p` addresses.
- `.b32.i2p` address auto-extracted and logged at startup.
- Key generation command available via `docker-run` secret type.
- Spoofed Host header configurable for Traefik fronting with HostRegexp.
