<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Reseed and subscription presets for censored networks

- Curated reseed server list ships in the image, so first boot finds peers without relying on the built-in defaults alone.
- Curated addressbook subscriptions ship in the image, so eepsite names resolve from first boot.
- Extra servers and subscriptions append via environment variables; each bundled preset can be switched off on its own.
- Existing router data is never overwritten — console edits survive restarts.
- Reseed-over-proxy (HTTP, SOCKS4/5, or the I2P outproxy) configurable via environment for firewalled networks.
