<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# I2P anonymity router

- Full I2P router installed via silent installer with hash verification.
- Router console accessible on port 7657 with Traefik routing.
- HTTP proxy (port 4444) for browsing I2P eepsites; HTTPS proxy available (disabled by default).
- IPv4 firewalled detection, IPv6 disabled, and UPnP disabled by default for predictable NAT traversal.
- JVM memory constrained to 128m--256m heap by default, configurable via environment.
