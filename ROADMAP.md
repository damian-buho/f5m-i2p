<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
-->

[Español](docs/es/ROADMAP.md) · [Українська](docs/uk/ROADMAP.md)

# Roadmap

## Project Roadmap

### Reseed that works behind a firewall

- **Problem.** The router config has no reseed keys, so it falls back to clearnet HTTPS reseed hosts — exactly what fails first behind a national firewall, leaving a censored-network operator with a router that never builds a network database.
- **Under consideration.** Env-configurable reseed URLs, an option to reseed over Tor, or a bundled offline reseed bundle, so first boot reaches a working netDb in a censored environment.
- **Rests on.** I2P’s `i2p.reseed.*` configuration keys; the sibling `f5m/tor` image a reseed-over-Tor path would egress through.

### Configurable outproxy and SOCKS

- **Problem.** The outproxy hosts are hardcoded and there is no SOCKS tunnel at all, so an operator who wants a different clearnet exit — or any SOCKS5 client — must edit the template; worse, the default HTTPS outproxy silently routes clearnet traffic through a third-party Tor node.
- **Under consideration.** Template the HTTP and HTTPS outproxies from env and add a toggleable SOCKS client tunnel on a conventional port, so the operator picks the exit and any SOCKS app works.
- **Rests on.** I2P’s tunnel outproxy keys and its SOCKS client tunnel type; the existing Jinja2 tunnel template that already defines the HTTP and CONNECT tunnels.

### Unified Tor egress with f5m/tor

- **Problem.** The HTTPS outproxy points at a third-party Tor node, so an operator trusts a stranger with their clearnet traffic, and I2P and Tor run as separate stacks with no shared egress or observability.
- **Under consideration.** A single compose stack that uses the operator’s own `f5m/tor` container as the I2P clearnet outproxy and reseed egress, removing third-party trust and unifying persistent identity and metrics across both.
- **Rests on.** The sibling `f5m/tor` image’s SOCKS port and the I2P outproxy and reseed keys already templated; the existing compose machinery both images share.
