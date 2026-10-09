#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -eou pipefail

# shellcheck source=/dev/null
. b19-i18n

HOSTS_FILE="${B19_HOME}/.i2p/hosts.txt"
# The router dir needs the bundled hosts to resolve the .i2p subscription sources
if ! grep -q '^i2p-projekt\.i2p=' "${HOSTS_FILE}" 2>/dev/null; then
  b19-log bad "TEST.D" "$(_p "Bundled hosts missing from the router dir: %s" "${HOSTS_FILE}")"
  exit 1
fi
b19-log good "TEST.D" "$(_p "Bundled hosts are in the router dir (%s)" "${HOSTS_FILE}")"
