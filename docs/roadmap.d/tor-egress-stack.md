<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Unified Tor egress with f5m/tor

- **Problem.** The HTTPS outproxy points at a third-party Tor node, so an operator trusts a stranger with their clearnet traffic, and I2P and Tor run as separate stacks with no shared egress or observability.
- **Under consideration.** A single compose stack that uses the operator’s own `f5m/tor` container as the I2P clearnet outproxy and reseed egress, removing third-party trust and unifying persistent identity and metrics across both.
- **Rests on.** The sibling `f5m/tor` image’s SOCKS port and the I2P outproxy and reseed keys already templated; the existing compose machinery both images share.
