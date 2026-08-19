<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Configurable outproxy and SOCKS

- **Problem.** The outproxy hosts are hardcoded and there is no SOCKS tunnel at all, so an operator who wants a different clearnet exit — or any SOCKS5 client — must edit the template; worse, the default HTTPS outproxy silently routes clearnet traffic through a third-party Tor node.
- **Under consideration.** Template the HTTP and HTTPS outproxies from env and add a toggleable SOCKS client tunnel on a conventional port, so the operator picks the exit and any SOCKS app works.
- **Rests on.** I2P’s tunnel outproxy keys and its SOCKS client tunnel type; the existing Jinja2 tunnel template that already defines the HTTP and CONNECT tunnels.
