<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Reseed that works behind a firewall

- **Problem.** The router has no reseed information, so it falls back to clearnet HTTPS reseed hosts — exactly what fails first behind a national firewall, leaving a censored-network operator with a router that never builds a network database.
- **Under consideration.** Configurable reseed URLs, an option to reseed over Tor, or a bundled offline reseed bundle, so first boot reaches a working netDb in a censored environment.
- **Rests on.** The sibling `f5m/tor` image a reseed-over-Tor path would egress through.
