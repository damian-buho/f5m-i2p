#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -eou pipefail

# shellcheck source=/dev/null
. b19-i18n

# A tag that strips the newline after itself glues the next key onto a tunnel type, and the router then reads one unknown type and never starts that tunnel
TUNNELS_TEMPLATE="${B19_HOME}/i2ptunnel.config.j2"
TUNNELS_CONFIG="${B19_HOME}/i2ptunnel.config"

while read -r declared; do
  if ! grep --quiet --line-regexp --fixed-strings "${declared}" "${TUNNELS_CONFIG}"; then
    b19-log bad "TEST.D" "$(_p "Tunnel type is not rendered verbatim: %s" "${declared}")"
    exit 1
  fi
done < <(sed -n '/^tunnel\.[0-9]*\.type=/p' "${TUNNELS_TEMPLATE}")

b19-log good "TEST.D" "$(_p "Every tunnel type is rendered verbatim (%s)" "${TUNNELS_CONFIG}")"
